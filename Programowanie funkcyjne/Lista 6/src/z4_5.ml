let rec fold_left_cps f acc lst con =
        match lst with
        | [] -> con acc
        | x :: xs -> f acc x (fun a -> fold_left_cps f a xs con)

let fold_left_cps_id f acc lst =
    fold_left_cps f acc lst (fun x -> x)

let fold_left f acc lst =
    fold_left_cps (fun acc x con -> con (f acc x)) acc lst (fun x -> x)

let sum acc x con =
    con (acc + x)

let all_values f lst =
    let all_values' acc x con =
        if not (f x) then false else con acc
    in fold_left_cps_id all_values' true lst

let mult_list lst =
    let mult_list' acc x con =
        if x = 0 then 0 else con (acc * x)
    in fold_left_cps_id mult_list' 1 lst

let sorted lst =
    let sorted' acc x con =
        if (x < acc) then false else con x
    in fold_left_cps sorted' (List.hd lst) lst (fun a -> true)