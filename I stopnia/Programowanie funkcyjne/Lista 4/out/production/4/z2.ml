type 'a zlist = Zip of 'a list * 'a list

let of_list lst = Zip([], lst)
let to_list (Zip(ls, rs)) = (List.rev ls) @ rs

let empty = Zip([], [])

let elem = function
| Zip(_, a :: hs) -> Some a
| Zip(_, []) -> None

let move_left = function
| Zip(a :: ls, rs) -> Zip(ls, a :: rs)
| Zip([], _) -> failwith "At begin"

let move_right = function
| Zip(ls, a :: rs) -> Zip(a::ls, rs)
| Zip(_, []) -> failwith "At end"

let insert a (Zip(ls, rs)) = Zip(a :: ls, rs)
let remove = function
| Zip(a :: ls, rs) -> Zip(ls, rs)
| Zip([], _) -> failwith "At begin"