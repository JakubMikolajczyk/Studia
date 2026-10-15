type 'a dllist = 'a dllist_data lazy_t
and 'a dllist_data ={
    prev : 'a dllist;
    elem : 'a;
    next : 'a dllist
  }


let prev dlst =
    failwith "TODO"

let elem dlst =
    failwith "TODO"

let next dlst =
    failwith "TODO"

let of_list lst =
    let rec