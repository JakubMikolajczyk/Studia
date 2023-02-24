let rec fold_left_cps' f acc lst con =
        match lst with
        | [] -> con acc
        | x :: xs -> f acc x (fun a -> fold_left_cps' a xs con)

let fold_left_cps f acc lst =
    fold_left_cps' f acc lst (fun x -> x)


let sum acc x con =
    con (acc + x)

let all_values f lst =
    let all_values' acc x con =
        if (f x) then con acc else false
    in fold_left_cps all_values' true lst

let mult_list lst =
    let mult_list' acc x con =
        if x = 0 then 0 else con (acc * x)
    in fold_left_cps mult_list' 1 lst

let sorted lst =
    let sorted' acc x con =
        if (x < acc) then false else con x
    in fold_left_cps' sorted' (List.hd lst) lst (fun a -> true)