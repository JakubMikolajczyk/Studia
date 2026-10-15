let ctrue = fun tt ff -> if true then tt else ff;;
let cfalse = fun tt ff -> if false then tt else ff;;

let cand ca cb = fun tt ff -> if (ctrue tt ff) == (ca tt ff) && (ca tt ff) == (cb tt ff) then ctrue tt ff else cfalse tt ff;;
let cor ca cb = fun tt ff -> if (ca tt ff) == (ctrue tt ff) || (cb tt ff) == (ctrue tt ff) then ctrue tt ff else cfalse tt ff;;

let cbool_of_bool bool = if bool then ctrue else cfalse;;
let bool_of_cbool cbool = if (cbool true false) then true else false;;