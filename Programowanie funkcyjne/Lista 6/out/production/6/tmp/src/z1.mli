type ('a, 'b) format = (string -> 'b) -> string -> 'a

val lit: string -> ('a, 'a) format

val int: (int -> 'a, 'a) format

val str: (string -> 'a, 'a) format

(*val (^^): ('a, 'b) format -> ('c, 'd) format ->*)

val ksprintf: ('a,'b) format -> (string -> 'b) -> 'a

val sprintf: ('a, string) format -> 'a