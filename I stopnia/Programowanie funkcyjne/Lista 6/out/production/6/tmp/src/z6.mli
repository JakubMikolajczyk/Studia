open Proc

val map: ('i -> 'o) -> ('a, 'z, 'i, 'o) proc

val filter: ('i -> bool) -> ('a, 'z, 'i, 'o) proc

val nats_from : int -> ('a, 'z, 'i, int) proc

val sieve: ('a, 'a, int, int) proc