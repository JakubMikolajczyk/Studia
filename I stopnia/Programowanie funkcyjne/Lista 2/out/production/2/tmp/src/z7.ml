type 'a leftist =
| Leaf
| Node of 'a leftist * 'a * 'a leftist * int

let singleton v = Node (Leaf, v, Leaf, 1)
let rank = function
| Leaf -> 0
| Node (_,_,_,r) -> r

let rec merge t1 t2 = match t1,t2 with
| Leaf, t | t, Leaf -> t
| Node (l, v1, r, _) , Node (_, v2, _, _) ->
    if (>) v1  v2 then merge t2 t1
    else
    let merged = merge r t2 in
        if (>) (rank merged) (rank l) then Node (merged, v1, l, (rank l) + 1)
        else Node (l, v1, merged, (rank merged) + 1)

let make v t1 t2 = if (>) (rank t1) (rank t2) then Node (t1, v, t2, (rank t2) + 1) else Node(t2, v, t1, (rank t1) + 1)
let insert v t = merge (singleton v) t
let getMin = function
| Leaf -> failwith "No min"
| Node (_,v,_,_) -> v
let deleteMin = function
| Leaf -> failwith "No min"
| Node (l,v,r,_) -> merge l r

let test1 = insert 12 (insert 5 (insert 3 (insert 14 Leaf)))
(*            3*)
(*        14      5*)
(*             12*)

let test2 = insert 1 (insert 4 (insert 40 Leaf))
(*                1*)
(*             4*)
(*          40*)

let test3 = insert 20 (insert 12 (insert 40 (insert 10 (insert 1 (insert 25 Leaf)))));;
(*                           1*)
(*                    10          20*)
(*                40      12    25*)



make 0 test1 test2;;
(*              0*)
(*         3          1*)
(*      14    5    4*)
(*         12    40*)


merge test1 test3;;
(*                        1*)
(*               10               3*)
(*           40     12        5       20*)
(*                        12      25*)

getMin test1;;
deleteMin (merge test1 test3);;
(*                   3*)
(*             5          10*)
(*         12     20    40    12*)
(*             25           14*)
