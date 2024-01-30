/* Jakub Mikolajczyk 324504
 * Oswiadczam, że jestem jedynym autorem pracy, oprócz zaznaczonych fragmentów
 *
 *
 *
 * Header in structure is 4 byte, contain size of block (multiple of 16, so 2
 * lower bits are unused) in this 2 bits we will store information about
 * previous block allocation status (bcs of that we dont have to store footer of
 * allocated block) and information about this block allocation status
 *
 * ALLOC block structure:
 * [header|payload] - minimum 16 bytes bcs of alignment
 * header
 * payload - memory for user
 *
 * FREE block structure:
 * [header|prev|next|footer]
 * header
 * prev - pointer to prev free block, store as offset from begin of heap
 * next - pointer to next free block, store as offset from begin of heap
 * footer - same information as header, bcs of that we can get previous block
 *
 * We store free block in segregate lists
 * seg[0] max size is 32, and next max size increased by power of 2
 * Finding policy is best-fit
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include <unistd.h>

#include "mm.h"
#include "memlib.h"

/* If you want debugging output, use the following macro.  When you hand
 * in, remove the #define DEBUG line. */
// #define DEBUG
#ifdef DEBUG
#define debug(...) printf(__VA_ARGS__)
#define debugF(fun, ...) (fun)(__VA_ARGS__)
#define I(i) printf("%d\n", i)
#else
#define debug(...)
#define debugF(...)
#define I(i)
#endif

/* do not change the following! */
#ifdef DRIVER
/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#endif /* def DRIVER */

//***************************************************************************************************************************
// From CSAPP
#define WSIZE 4 /* Word and header/footer size (bytes) */
#define DSIZE 8 /* Doubleword size (bytes) */
#define CHUNKSIZE (1 << 12)

#define MAX(x, y) ((x) > (y) ? (x) : (y))

/* Read and write a word at address p */
#define GET(p) (*(unsigned int *)(p))
#define PUT(p, val) (*(unsigned int *)(p) = (val))

/* Given block ptr bp, compute address of its header and footer */
#define HDRP(bp) ((char *)(bp)-WSIZE)
#define FTRP(bp) ((char *)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

/* Given block ptr bp, compute address of next and previous blocks */
#define NEXT_BLKP(bp) ((char *)(bp) + GET_SIZE(((char *)(bp)-WSIZE)))
#define PREV_BLKP(bp) ((char *)(bp)-GET_SIZE(((char *)(bp)-DSIZE)))
//***************************************************************************************************************************

#define MIN_POW 5
#define MAX_POW 30
#define LISTS (MAX_POW - MIN_POW)
#define MIN_SIZE (1 << MIN_POW)

#define MIN_BLK_SIZE 16

// pack size of block, previous block allocation status, this block allocation
// into a word (header)
#define PACK(size, prev_alloc, alloc) ((size) | (prev_alloc << 1) | (alloc))

#define GET_SIZE(p) (GET(p) & -4)
#define GET_PREV_ALLOC(p) ((GET(p) & 2) >> 1)
#define GET_ALLOC(p) (GET(p) & 1)

#define SET_SIZE(p, size) (PUT(p, (GET(p) & 3) | (size)))
#define SET_PREV_ALLOC(p, prev_alloc)                                          \
  (PUT(p, (GET(p) & -3) | (prev_alloc << 1)))
#define SET_ALLOC(p, alloc) (PUT(p, (GET(p) & -2) | alloc))

#define IS_GUARD(bp) ((GET_SIZE(HDRP(bp))) == 0)
#define SET_GUARD(bp) (PUT(bp, PACK(0, 1, 1)))

#define POLICY 0 // 0 - bestfit, 1 - firstfit
static void *find_block(size_t size);
static void place(void *bp, size_t size);
static void *coalesce(void *bp);
static void *extend_heap(size_t size);

// list function
#define PREV(p) (p)
#define NEXT(p) ((p) + WSIZE)
#define NEXT_SEG(p) ((p) + WSIZE)

static void delete_blk(void *bp);
static void insert_blk(void *bp);
static void *get_seg(int size);
static unsigned int nearest_log2(unsigned int n);

// checkheap functions
static bool in_heap(void *bp);
static bool in_list(void *head, void *bp);
static void check_seg_list(int verbose);
static void check_block(void *bp, int verbose);
static void check_list(void *head, int min_size, int max_size, int verbose);

// print functions
static void print_seg_list(void *failp);
static void print_block(void *bp, bool fail);
static void print_list(void *head, void *failp);
static void print_heap(void *failp);
static void print_heap(void *failp);
static void print_node_i(void *node);
static void print_node_p(void *node);
// static void print_bytes(void *begin, size_t n);

static size_t round_up(size_t size) {
  return (size + ALIGNMENT - 1) & -ALIGNMENT;
}

static unsigned int nearest_log2(unsigned int n) {
  n--;
  n |= n >> 1;
  n |= n >> 2;
  n |= n >> 4;
  n |= n >> 8;
  n |= n >> 16;
  n++;
  return ((int32_t)31 - (int32_t)__builtin_clz(n));
}

// Because we create blocks in range of heap, we can store pointer as offset
// from begin of heap so instead of 8 byte pointer we have 4 byte offset

// ?Maybe divide offset by 16, because we alignment to multiple of 16?

// cast pointer to offset from begin of heaap
static unsigned int ptoi(void *bp) {
  return (unsigned int)(bp - mem_heap_lo());
}

// cast offset from begin of heap to pointer
static void *itop(unsigned int bpi) {
  return bpi ? (((void *)((long)(bpi)) + (long)(mem_heap_lo()))) : NULL;
}

// get pointer to prev block in list
static void *prev_p(void *bp) {
  return itop(GET(PREV(bp)));
}

// get pointer to next block in list
static void *next_p(void *bp) {
  return itop(GET(NEXT(bp)));
}

static void *bp_start;
static void *seg_start;
static void *seg_end;
/*
 * mm_init - Called when a new trace starts.
 * Create segregated lists with null pointers,
 * first header, footer and guard
 */
int mm_init(void) {
  debug("init\n");
  if ((seg_start = mem_sbrk(LISTS * WSIZE + WSIZE)) < 0)
    return -1;
  seg_start = seg_start + WSIZE; // + WSIZE = padding bcs 0 is my null
  seg_end = seg_start + LISTS * WSIZE + 2 * WSIZE; // END after last block

  int seg_padding = ALIGNMENT - (LISTS * WSIZE + WSIZE) % ALIGNMENT;

  if ((bp_start = mem_sbrk(seg_padding + 4 * WSIZE)) < 0)
    return -1;

  bp_start = bp_start + seg_padding;

  void *iter = seg_start;
  while (iter != bp_start) { // 0 seg list and padding
    PUT(iter, 0);
    iter = NEXT_SEG(iter);
  }

  PUT(bp_start + (1 * WSIZE), PACK(DSIZE, 1, 1)); // Prologue header
  PUT(bp_start + (2 * WSIZE), PACK(DSIZE, 1, 1)); // Prologue footer
  PUT(bp_start + (3 * WSIZE), PACK(0, 1, 1));     // GUARD
  bp_start = bp_start + 2 * WSIZE;

  extend_heap(CHUNKSIZE);

  return 0;
}

/*
 * malloc - search for fit block and then allocate (with possible split)
 * if not find fit block, extend heap and allocate block
 * Always allocate a block whose size is a multiple of the alignment.
 */
void *malloc(size_t size) {
  debug("malloc size %d\n", size);
  void *bp;
  size_t asize;

  if (size == 0) {
    return NULL;
  }

  asize = round_up(size + WSIZE); // + size for next header

  if ((bp = find_block(asize)) != NULL) {
    place(bp, asize);
    return bp;
  }

  if ((bp = extend_heap(asize)) == NULL)
    return NULL;

  place(bp, asize);
  return bp;
}

// set header and footer of free block and next block, then coalesce
void free(void *bp) {
  debug("free\n");
  if (bp == NULL)
    return;

  SET_ALLOC(HDRP(bp), false);
  SET_PREV_ALLOC(HDRP(NEXT_BLKP(bp)), false);
  PUT(FTRP(bp), GET(HDRP(bp)));
  coalesce(bp);
}

void *realloc(void *old_bp, size_t size) {
  debug("realloc\n");
  /* If size == 0 then this is just free, and we return NULL. */
  if (size == 0) {
    free(old_bp);
    return NULL;
  }

  /* If old_ptr is NULL, then this is just malloc. */
  if (!old_bp)
    return malloc(size);

  size_t new_asize = round_up(size + WSIZE);
  size_t old_size = GET_SIZE(HDRP(old_bp));
  void *next_blk = NEXT_BLKP(old_bp);

  // new size is smaller
  if (new_asize <= old_size) {
    debug("smaller size\n");

    // we can shrink block
    if (old_size - new_asize >= MIN_BLK_SIZE) {
      debug("shrink\n");
      // not need to change footer bcs if block is free coalesce will merge with
      // new block and set correct footer
      SET_PREV_ALLOC(HDRP(next_blk), 0);
      SET_SIZE(HDRP(old_bp), new_asize);

      // set header for new free block, coalesce will set footer
      PUT(HDRP(NEXT_BLKP(old_bp)), PACK(old_size - new_asize, 1, 0));
      coalesce(NEXT_BLKP(old_bp));
    }

    return old_bp;
  }

  // next block is free and have enough size, so we extend our block
  if (!GET_ALLOC(HDRP(next_blk)) &&
      old_size + GET_SIZE(HDRP(next_blk)) >= new_asize) {
    debug("extend block\n");
    delete_blk(next_blk);
    size_t next_blksize = GET_SIZE(HDRP(next_blk));
    SET_SIZE(HDRP(old_bp), new_asize);
    size_t new_block_size = next_blksize + old_size - new_asize;

    // we take full next block, (NO SPLIT)
    if (new_block_size == 0) {
      SET_PREV_ALLOC(HDRP(NEXT_BLKP(next_blk)), 1);
      memset(HDRP(next_blk), 0, new_asize - old_size);
      return old_bp;
    }

    // set header of new free block
    PUT(HDRP(NEXT_BLKP(old_bp)), PACK(new_block_size, 1, 0));
    PUT(FTRP(NEXT_BLKP(old_bp)), GET(HDRP(NEXT_BLKP(old_bp))));
    insert_blk(NEXT_BLKP(old_bp));
    memset(HDRP(next_blk), 0, new_asize - old_size);

    return old_bp;
  }

  void *new_bp;
  if ((new_bp = malloc(size)) == NULL) {
    return NULL;
  }

  if (size < old_size) {
    old_size = size;
  }
  memcpy(new_bp, old_bp, old_size);
  memset(new_bp + old_size, 0, size - old_size);
  free(old_bp);
  return new_bp;
}

/*
 * calloc - Allocate the block and set it to zero.
 */
void *calloc(size_t nmemb, size_t size) {
  debug("calloc\n");
  size_t bytes = nmemb * size;
  void *new_ptr = malloc(bytes);

  /* If malloc() fails, skip zeroing out the memory. */
  if (new_ptr)
    memset(new_ptr, 0, bytes);

  return new_ptr;
}

//
static void *extend_heap(size_t size) {
  debug("extend_heap\n");
  void *bp;

  if ((bp = mem_sbrk(size)) < 0)
    return (void *)-1;

  PUT(HDRP(bp), PACK(size, GET_PREV_ALLOC(HDRP(bp)), 0));
  PUT(FTRP(bp), PACK(size, GET_PREV_ALLOC(HDRP(bp)), 0));

  PUT(HDRP(NEXT_BLKP(bp)), PACK(0, 0, 1)); // new GUARD
  return coalesce(bp);
}

// find segregated list which size < max size
void *get_seg(int size) {
  debug("get_seg\n");
  return (seg_start + WSIZE * (nearest_log2(size) - MIN_POW + 1));
}

// insert block to list
static void insert_blk(void *bp) {
  debug("insert_blk\n");

  if (GET_ALLOC(HDRP(bp))) {
    debug("INSERT ERROR\n");
    assert(true);
  }

  void *seg = get_seg(GET_SIZE(HDRP(bp)));
  void *list_head = itop(GET(seg));

  if (list_head == NULL) {
    debug("empty list\n");
    PUT(PREV(bp), 0);
    PUT(NEXT(bp), 0);
    PUT(seg, ptoi(bp));
    return;
  }

  debug("not empty\n");
  PUT(PREV(list_head), ptoi(bp));
  PUT(NEXT(bp), ptoi(list_head));
  PUT(PREV(bp), 0);
  PUT(seg, ptoi(bp));
}

// delete block from list
static void delete_blk(void *bp) {
  debug("delete_blk\n");

  void *prev_blk = prev_p(bp);
  void *next_blk = next_p(bp);
  void *seg = get_seg(GET_SIZE(HDRP(bp)));

  if (prev_blk != NULL && next_blk != NULL) { // middle node
    debug("middle node\n");
    PUT(NEXT(prev_blk), ptoi(next_blk));
    PUT(PREV(next_blk), ptoi(prev_blk));
    return;
  }

  if (prev_blk == NULL && next_blk != NULL) {
    debug("head delete\n");
    PUT(PREV(next_blk), 0);
    PUT(seg, ptoi(next_blk)); // set new seg start
    return;
  }

  if (prev_blk != NULL && next_blk == NULL) {
    debug("tail delete");
    PUT(NEXT(prev_blk), 0);
    return;
  }

  debug("one element delete\n");
  PUT(seg, 0);
}

// allocate block and split if possibly
static void place(void *bp, size_t asize) {
  debug("place\n");
  size_t this_size = GET_SIZE(HDRP(bp));
  delete_blk(bp);

  if ((this_size - asize) >= MIN_BLK_SIZE) { // check if split is possibly
    debug("SPLIT\n");
    PUT(HDRP(bp), PACK(asize, 1, 1));

    // Split, change next block size and status (free block)
    void *next_bp = NEXT_BLKP(bp);
    PUT(HDRP(next_bp), PACK(this_size - asize, 1, 0));
    PUT(FTRP(next_bp), PACK(this_size - asize, 1, 0));
    insert_blk(next_bp);
    return;
  }

  // cant split, so fill block
  PUT(HDRP(bp), PACK(this_size, 1, 1));
  PUT(FTRP(bp), PACK(this_size, 1, 1));
  SET_PREV_ALLOC(HDRP(NEXT_BLKP(bp)), true);
}

// merge free blocks
static void *coalesce(void *bp) {
  debug("coalesce\n");
  bool next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
  bool prev_alloc = GET_PREV_ALLOC(HDRP(bp));

  // next block is free
  if (!next_alloc) {
    debug("next coalesce\n");
    delete_blk(NEXT_BLKP(bp)); // delete next block from list
    SET_SIZE(HDRP(bp), GET_SIZE(HDRP(bp)) + GET_SIZE(HDRP(NEXT_BLKP(bp))));
  }

  // prev block is free
  if (!prev_alloc) {
    debug("prev coalesce\n");
    delete_blk(PREV_BLKP(bp));
    SET_SIZE(HDRP(PREV_BLKP(bp)),
             GET_SIZE(HDRP(bp)) + GET_SIZE(HDRP(PREV_BLKP(bp))));
    bp = PREV_BLKP(bp);
  }

  PUT(FTRP(bp), GET(HDRP(bp))); // create footer
  insert_blk(bp);               // add block to list
  return bp;
}

// finding smallest block, where we fit
static void *best_fit(size_t size) {
  debug("best fit\n");
  void *min = NULL;
  void *seg = get_seg(size);
  while (seg != seg_end) {
    void *iter = itop(GET(seg));
    while (iter != NULL) {
      if (GET_SIZE(HDRP(iter)) >= size && // check if we can fill
          (min == NULL ||
           GET_SIZE(HDRP(iter)) <
             GET_SIZE(HDRP(min)))) { // check if it is best option
        min = iter;
      }
      iter = next_p(iter);
    }
    if (min != NULL)
      return min;
    seg = NEXT_SEG(seg);
  }

  return min;
}

static void *first_fit(size_t size) {
  debug("best fit\n");
  void *seg = get_seg(size);
  //  debug("size: %d\n", size);
  while (seg != seg_end) {
    void *iter = itop(GET(seg));
    while (iter != NULL) {
      if (GET_SIZE(HDRP(iter)) >= size) // check if it is best option
        return iter;
      iter = next_p(iter);
    }
    seg = NEXT_SEG(seg);
  }

  return NULL;
}

static void *find_block(size_t size) {
  if (POLICY == 0)
    return best_fit(size);
  if (POLICY == 1)
    return first_fit(size);
}

/*
 * mm_checkheap - So simple, it doesn't need a checker!
 */
void mm_checkheap(int verbose) {

  check_seg_list(verbose);
  // check if GUARD is valid
  if (GET_SIZE(HDRP(mem_heap_hi() + 1)) != 0 ||
      GET_ALLOC(HDRP(mem_heap_hi() + 1)) != 1) {
    printf("GUARD ERROR\n");
    if (verbose == 1) {
      print_heap(mem_heap_hi() + 1);
    }
    exit(1);
  }

  // cheack if first header is valid
  if (GET_SIZE(HDRP(bp_start)) != DSIZE || GET_ALLOC(HDRP(bp_start)) != 1) {
    printf("PROLOG HEADER ERROR\n");
    if (verbose)
      print_block(bp_start, false);
  }

  // check all blocks
  void *iter = bp_start;
  while (IS_GUARD(iter)) {
    check_block(iter, verbose);
    iter = NEXT_BLKP(iter);
  }
}

// check if pointer is in heap range
static bool in_heap(void *bp) {
  return mem_heap_lo() <= bp && mem_heap_hi() >= bp;
}

// check if block is in list
static bool in_list(void *head, void *bp) {
  void *iter = head;
  while (iter != NULL) {
    if (iter == bp)
      return true;
    iter = next_p(iter);
  }
  return false;
}

// check if all seg list all valid
static void check_seg_list(int verbose) {
  void *seg = seg_start;
  int min_size = 0;
  int max_size = MIN_SIZE;

  while (seg != seg_end) {
    check_list(itop(GET(seg)), min_size, max_size, verbose);
    min_size = max_size;
    max_size <<= 1;
    seg = NEXT_SEG(seg);
  }
}

// check if block is valid
static void check_block(void *bp, int verbose) {
  bool prev_alloc = GET_PREV_ALLOC(HDRP(bp));
  bool alloc = GET_ALLOC(HDRP(bp));

  if (!in_heap(bp)) {
    printf("BLOCK NOT IN HEAP\n");
    if (verbose == 1)
      print_block(bp, false);
    exit(1);
  }

  // check if next block status is same as this block status
  if (alloc != GET_PREV_ALLOC(HDRP(NEXT_BLKP(bp)))) {
    printf("WRONG PREV_ALLOC\n");
    if (verbose == 1)
      print_heap(bp);
    exit(1);
  }

  if (alloc) {
    ;
  } else { // free block

    void *seg = itop(GET(get_seg(GET_SIZE(HDRP(bp)))));
    // check if free block is in list of free blocks
    if (!in_list(seg, bp)) {
      printf("FREE BLOCK NOT IN FREE LIST\n");
      if (verbose == 1)
        print_heap(bp);
      exit(1);
    }

    // check if header is same as footer
    if (GET(HDRP(bp)) != GET(FTRP(bp))) {
      printf("HEADER AND FOOTER DIFF\n");
      if (verbose == 1)
        print_heap(bp);
      exit(1);
    }
  }

  // check if blocks are coalesce, cannot be 2 free block next to each other
  if (!prev_alloc || !GET_ALLOC(HDRP(NEXT_BLKP(bp)))) {
    printf("NOT COALESCE BLOCK\n");
    if (verbose == 1)
      print_seg_list(bp);
    exit(1);
  }
}

static void check_list(void *head, int min_size, int max_size, int verbose) {
  void *iter = head;
  void *prev_iter = NULL;
  while (iter != NULL) {
    // check if block is free
    if (GET_ALLOC(HDRP(iter))) {
      printf("ALLOC BLOCK IN LIST\n");
      if (verbose) {
        print_seg_list(iter);
      }
      exit(1);
    }

    // check if this block is pointing to prev block
    if (prev_p(iter) != prev_iter) {
      printf("this.prev != prev_iter");

      if (verbose == 1) {
        print_node_i(iter);
        print_node_p(iter);
        print_list(head, iter);
      }
      exit(1);
    }

    // check if prev block is pointing to this block
    if (prev_p(iter) != NULL) {
      if (next_p((prev_p(iter))) != iter) {
        printf("PREV.next != THIS\n");

        if (verbose == 1) {
          print_node_i(iter);
          print_node_p(iter);
          print_list(head, iter);
        }
        exit(1);
      }
    }

    // check if next block is pointing to this block
    if (next_p(iter) != NULL) {
      if (prev_p((next_p(iter))) != iter) {
        printf("NEXT.prev != THIS\n");
        if (verbose == 1) {
          print_node_i(iter);
          print_node_p(iter);
          print_list(head, iter);
        }
      }
    }

    int block_size = GET_SIZE(HDRP(iter));

    // check if block is in good segregate list
    if (min_size > block_size || block_size > max_size) {
      printf("WRONG SEG LIST MINSIZE: %d MAXSIZE: %d BLOCKSIZE: %d", min_size,
             max_size, block_size);
      print_seg_list(iter);
      exit(1);
    }

    check_block(iter, verbose);
    prev_iter = iter;
    iter = next_p(iter);
  }
}

static void print_block(void *bp, bool fail) {

  printf("ADR:[0x%lx|%u] H:[%d|%d|%d]", (long)bp, ptoi(bp), GET_SIZE(HDRP(bp)),
         GET_PREV_ALLOC(HDRP(bp)), GET_ALLOC(HDRP(bp)));

  if (!GET_ALLOC(HDRP(bp)))
    printf("   F:[%d|%d|%d]", GET_SIZE(FTRP(bp)), GET_PREV_ALLOC(FTRP(bp)),
           GET_ALLOC(FTRP(bp)));

  if (fail) // mark block
    printf("  <-----------\n");
  else
    printf("\n");
}

static void print_seg_list(void *failp) {
  void *seg = seg_start;
  int min_size = 0;
  int max_size = MIN_SIZE;

  while (seg != seg_end) {
    printf("\n\nSEG off: %d min size: %d max size: %d\n head adrr: %ld",
           ptoi(seg), min_size, max_size, (long)GET(seg));
    print_list(itop(GET(seg)), failp);
    min_size = max_size;
    max_size <<= 1;
    seg = NEXT_SEG(seg);
  }

  printf("**********************************\n");
}

// print list and park pointed block
static void print_list(void *head, void *failp) {
  void *iter = head;
  printf("\nLIST\n");
  while (iter != NULL) {
    print_block(iter, iter == failp);
    iter = itop(GET(NEXT(iter)));
  }
}

// print heap and mark pointer block
static void print_heap(void *failp) {
  printf("\nHEAP \n");
  void *heap = bp_start;
  while (!IS_GUARD(heap)) {
    print_block(heap, failp == heap);
    heap = NEXT_BLKP(heap);
  }
  print_block(heap, failp == heap);
  printf("**********************************\n");
}

static void print_node_i(void *node) {
  printf("NODE I:\n");
  printf("prev: %d\n", ptoi(prev_p(node)));
  printf("this: %d\n", ptoi(node));
  printf("next: %d\n", ptoi(next_p(node)));
}

static void print_node_p(void *node) {
  printf("NODE P:\n");
  printf("prev: %ld\n", (long)prev_p(node));
  printf("this: %ld\n", (long)node);
  printf("next: %ld\n", (long)next_p(node));
}

// static void print_bytes(void *begin, size_t n) {
//
//   for (int i = 0; i < n; ++i) {
//     printf("%02x ", ((unsigned char *)begin)[i]);
//   }
// }