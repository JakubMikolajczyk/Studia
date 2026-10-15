type cbool = { cbool : 'a. 'a -> 'a -> 'a }

let ctrue = {cbool = fun tt ff -> tt}
let cfalse = {cbool = fun tt ff -> ff}

let cand ca cb = {cbool = fun tt ff -> ca.cbool (cb.cbool tt ff) ff}
let cor ca cb = {cbool = fun tt ff -> ca.cbool tt (cb.cbool tt ff)}

let cbool_of_bool bool =  if bool then ctrue else cfalse;;
let bool_of_cbool cb = if cb.cbool true false then true else false;;

(******************************************************************************************************************)
type cnum ={cnum :'a.('a->'a)->'a->'a}
let zero = {cnum = fun successor base -> base}
let succ cn = {cnum = fun successor base -> successor (cn.cnum successor base)}

let add cn1 cn2 = {cnum = fun successor base -> cn1.cnum successor (cn2.cnum successor base)}
let mul cn1 cn2 = {cnum = fun successor base -> cn1.cnum (cn2.cnum successor) base}

let is_zero cn1 = {cbool = cn1.cnum (fun x -> cfalse) ctrue}

let cnum_of_int num = let rec reccnum n = if n = 0 then zero else succ (reccnum (n - 1)) in reccnum num;;
let int_of_cnum cn = cn.cnum ((+) 1) 0;;