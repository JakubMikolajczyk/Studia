
let for_all f lst =
    try
        List.fold_left (fun acc x -> if f x then acc else raise Exit) true lst
    with
    Exit -> print_string "EXIT"; false

let mult_list lst =
    try
        List.fold_left (fun acc x -> if x = 0 then raise Exit else acc * x) 1 lst
    with
    Exit -> print_string "EXIT"; 0

let sorted lst =
    try
        let a = List.fold_left (fun acc x -> if x < acc then raise Exit else x) (List.hd lst) lst in true
    with
    Exit -> print_string "EXIT"; false