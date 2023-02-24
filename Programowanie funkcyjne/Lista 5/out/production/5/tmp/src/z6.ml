type 'a my_lazy = 'a lazy_node ref and
 'a lazy_node =
| Value of 'a
| Delayed of (unit -> 'a)
| Calc

let rec force m_lazy = match !m_lazy with
| Calc -> failwith "Calculating"
| Value a -> a
| Delayed f ->
    m_lazy := Calc;
    let calcval = f () in
    m_lazy := Value(calcval);
    calcval

let rec fix f = ref (Delayed(fun () -> f (fix f)))



type 'a lazy_list =
| Nil
| Cons of 'a * 'a lazy_list my_lazy

let rec nth n xs = match n, (force xs) with
| _, Nil -> failwith "nth"
| 0, Cons(x, _) -> x
| _, Cons(_, xs) -> nth (n - 1) xs

let stream_of_ones = fix (fun stream_of_ones -> Cons(1, stream_of_ones))

let rec nats_from n = fix (fun f -> Cons(n, nats_from (n + 1)))
