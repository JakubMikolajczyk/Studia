let rec halve = function
| [] -> ([],[])
| x :: y :: t -> (fun (a, b) -> (x :: a, y :: b)) (halve t)
| h :: [] -> ([h], []);;


let rec merge cmp l1 l2 = match l1,l2 with
| [], [] -> []
| lst, [] | [], lst -> lst
| h1 :: t1, h2 :: t2 -> if (cmp h1 h2) then h1 :: (merge cmp t1 l2) else h2 :: (merge cmp l1 t2)

let tailMerge cmp l1 l2 =
    let rec tailRec acc l1 l2 = match l1, l2 with
    | [],[] -> acc
    | lst, [] | [], lst -> List.rev_append acc lst
    | h1 :: t1, h2 :: t2 -> if (cmp h1 h2) then (tailRec (h1 :: acc) t1 l2) else (tailRec (h2 :: acc) l1 t2)
    in tailRec [] l1 l2;;

let rec mergeSort cmp lst = match lst with
| [] -> []
| h :: [] -> [h]
| _ -> (fun (a, b) -> merge cmp (mergeSort cmp a) (mergeSort cmp b)) (halve lst);;


(*let halveTest = [1;2;3;4;5;6]*)
(*let mergeTest = ([1;4;10;20], [2;3;9;21]);;*)

mergeSort (<=) [1;5;3;2;40;12;4];;
tailMerge (<=) [1;4;10;20] [2;3;9;21];;