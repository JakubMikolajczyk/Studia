let tlist1 = [1;2;3;4;5;6;7;8;15]

let lenght = fun lst -> List.fold_left (fun acc x -> acc + 1) 0 lst;;
let rev = fun lst -> List.fold_left (fun acc x -> x :: acc) [] lst;;
let map f = fun lst -> List.fold_right (fun x acc -> (f x) :: acc) lst [];;
let append elm = fun lst -> List.fold_right (fun x acc -> x :: acc) lst [elm]
let rev_append elm = fun lst -> List.fold_left (fun acc x -> x :: acc) [elm] lst;;
let filter f = fun lst -> List.fold_right (fun x acc -> if f x then x :: acc else acc) lst [];;
let rev_map f = fun lst -> List.fold_left (fun acc x -> (f x) :: acc) [] lst;;

lenght tlist1;;
rev tlist1;;
map (fun x -> x * 2) tlist1;;
append 20 tlist1;;
rev_append 20 tlist1;;
filter (fun x -> x mod 2 == 0) tlist1;;
rev_map (fun x -> x * 2) tlist1;;