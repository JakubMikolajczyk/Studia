type id =
| RootId
| SingleId
| NodeId
| TripleId

type 'a tree =
| Leaf
| Single of 'a * 'a tree
| Node of 'a * 'a tree * 'a tree
| Triple of 'a * 'a tree * 'a tree * 'a tree

type 'a context =
| Root
| MidSingle of 'a context * 'a
| LeftDouble  of 'a context * 'a * 'a tree
| RightDouble of 'a context * 'a * 'a tree
| LeftTriple of 'a context * 'a * 'a tree * 'a tree
| MidTriple of 'a context * 'a * 'a tree * 'a tree
| RightTriple of 'a context * 'a * 'a tree * 'a tree

type 'a zipper = 'a context * 'a tree

let by_id id x l m r =
    match id with
    | SingleId -> Single(x, m)
    | NodeId -> Node(x, l, r)
    | TripleId -> Triple(x, l, m, r)
    | RootId -> failwith "root"

let go_up (ctx, t) =
  match ctx with
  | Root -> failwith "root"
  | MidSingle(ctx, x) -> (ctx, Single(x, t))
  | LeftDouble(ctx, x, r) -> (ctx, Node(x, t, r))
  | RightDouble(ctx, x, l) -> (ctx, Node(x, l, t))
  | LeftTriple(ctx, x, m, r) -> (ctx, Triple(x, t, m, r))
  | MidTriple(ctx, x, l, r) -> (ctx, Triple(x, l, t, r))
  | RightTriple(ctx, x, l, m) -> (ctx , Triple(x, l, m, t))

let go_left (ctx, t) =
  match t with
  | Leaf -> failwith "Leaf"
  | Single(_,_) -> failwith "Single2"
  | Node(x, l, r) -> (LeftDouble(ctx, x, r), l)
  | Triple(x, l, m, r) -> (LeftTriple(ctx, x, m, r), l)

let go_mid (ctx, t) =
    match t with
    | Leaf -> failwith "Leaf"
    | Node(_,_,_) -> failwith "Node"
    | Single(x, m) -> (MidSingle(ctx, x), m)
    | Triple(x, l, m, r) -> (MidTriple(ctx, x, l, r), m)

let go_right (ctx, t) =
  match t with
  | Leaf -> failwith "Leaf"
  | Single(_,_) -> failwith "Single"
  | Node(x, l, r) -> (RightDouble(ctx, x, l),  r)
  | Triple(x, l, m, r) -> (RightTriple(ctx, x, l, m), r)

let get (_, t) = t

let set (ctx, _) t = (ctx, t)


let tree1 = Node(1, Node(15 ,Node(10, Leaf, Leaf), Leaf), Single(3 ,Single(2, Triple(100, Leaf, Leaf, Leaf))))

let a = (Root, tree1)