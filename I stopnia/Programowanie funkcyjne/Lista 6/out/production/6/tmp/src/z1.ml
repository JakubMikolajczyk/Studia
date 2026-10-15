type ('a, 'b) format = (string -> 'b) -> string -> 'a

let id x = x

let lit str con =
    fun cstr -> con (cstr ^ str)

let int con =
    fun cstr -> (fun n -> con (cstr ^ (string_of_int n)))

let str con =
    fun cstr -> (fun str -> con (cstr ^ str))

let (^^) con1 con2 =
    fun con -> con1 (con2 con)

let sprintf con =
    con (fun x:string -> x) ""

let ksprintf format f =
    format f ""


(*let sprintf con = *)
(*    ksprintf con (fun x:string -> x)*)

(*(lit "aaa" ^^ lit "abc" ^^ int ^^ str id);;*)
(*sprintf (lit "aaa" ^^ lit "abc" ^^ int ^^ str) 53 " sgf";;*)