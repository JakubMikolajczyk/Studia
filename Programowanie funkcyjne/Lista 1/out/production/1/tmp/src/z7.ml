let ctrue = fun tt ff -> tt;;
let cfalse = fun tt ff -> ff;;


let cand ca cb = fun tt ff -> ca (cb tt ff) ff;;
let cor ca cb = fun tt ff -> ca tt (cb tt ff);;

let cbool_of_bool bool = if bool then ctrue else cfalse;;
let bool_of_cbool cbool = cbool true false;;

(*****************************************************************************)

let zero = fun successor base -> base;;
let succ cnum = fun successor base -> successor (cnum successor base);;
let add cnum1 cnum2 = fun successor base -> cnum1 successor (cnum2 successor base);;
let mul cnum1 cnum2 = fun successor base -> cnum1 (cnum2 successor) base;;

let is_zero cnum = (cnum (fun x -> cfalse) ctrue);;


let cnum_of_int num = let rec reccnum n = if n = 0 then zero else succ (reccnum (n - 1)) in reccnum num;;
let int_of_cnum cnum = cnum (( + ) 1) 0;;

let one = succ zero;;
let two = succ one;;
let three = succ two;;

