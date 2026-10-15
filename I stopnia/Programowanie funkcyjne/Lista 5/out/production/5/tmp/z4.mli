type 'a dllist = 'a dllist_data lazy_t
and 'a dllist_data ={
    prev : 'a dllist;
    elem : 'a;
    next : 'a dllist
  }


val prev: 'a dllist -> 'a dllist

val elem: 'a dllist -> 'a

val next: 'a dllist -> 'a dllist

val of_list: 'a list -> 'a dllist