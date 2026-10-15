let ctrue = fun tt ff -> tt;;
let cfalse = fun tt ff -> ff;;


let cand ca cb = fun tt ff -> ca (cb tt ff) ff;;
let cor ca cb = fun tt ff -> ca tt (cb tt ff);;

let cbool_of_bool bool = if bool then ctrue else cfalse;;
let bool_of_cbool cbool = cbool true false;;

let iff cbool a b = cbool a b;;