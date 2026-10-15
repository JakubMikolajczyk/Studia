type frac = int * int;;

let frac_add a b =
    fst a + fst b, snd a + snd b

type tree = Node of tree lazy_t * frac * tree lazy_t

let rec make_tree a b =
    let add = frac_add a b in
    Node(
        (lazy (make_tree a add)),
        (frac_add a b),
        (lazy (make_tree add b))
    )

let value = function
| Node(l, v, r) ->  v

let left = function
| Node(l, v, r) -> Lazy.force l

let right = function
| Node(l, v, r) -> Lazy.force r