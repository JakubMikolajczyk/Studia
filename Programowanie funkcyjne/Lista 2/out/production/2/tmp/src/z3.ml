let tlist1 = [1;2;3;4;5];;

let suffix = fun lst -> List.fold_right (fun x acc -> (x :: List.hd acc) :: acc) lst [[]];;
let prefix = fun lst -> List.fold_right (fun x acc -> [] :: (List.map (fun l -> x :: l) acc)) lst [[]];;

suffix tlist1;;
prefix tlist1;;


