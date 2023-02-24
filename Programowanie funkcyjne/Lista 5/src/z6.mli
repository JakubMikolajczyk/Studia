type 'a my_lazy = 'a lazy_node ref and
 'a lazy_node =
| Value of 'a
| Delayed of (unit -> 'a)
| Calc

type 'a lazy_list =
| Nil
| Cons of 'a * 'a lazy_list my_lazy

val force: 'a my_lazy -> 'a

val fix: ('a my_lazy -> 'a) -> 'a my_lazy

