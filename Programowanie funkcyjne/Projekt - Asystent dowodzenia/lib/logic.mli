type formula =
| False
| True
| VAR of string
| NOT of formula
| IMP of formula * formula
| OR of formula * formula
| AND of formula * formula

type theorem = formula list * formula

val assumptions : theorem -> formula list

val consequence : theorem -> formula

val by_assumption : formula -> theorem

val imp_i : formula -> theorem -> theorem

val imp_e : theorem -> theorem -> theorem

val bot_e : formula -> theorem -> theorem

val and_i : theorem -> theorem -> theorem

val and_e : formula -> theorem -> theorem

val or_i1 : theorem -> formula -> theorem

val or_i2 : formula -> theorem -> theorem

val or_e : theorem -> theorem -> theorem -> theorem

val top_i : theorem

val not_i : formula -> theorem -> theorem

val not_e : theorem -> theorem -> theorem

val d_not_e : theorem -> theorem

val pp_print_theorem : Format.formatter -> theorem -> unit

val pp_print_formula: Format.formatter -> formula -> unit

val string_of_formula: formula -> string

val print_theorem: theorem -> unit