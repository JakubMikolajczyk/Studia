open Proc

let rec map f con =
    recv (fun v ->
    send (f v)(fun () -> map f con))

let rec filter f con =
    recv (fun v ->
    if f v then send v(fun () -> filter f con) else filter f con)

let rec nats_from n con =
    send n (fun () -> nats_from (n + 1) con)

let rec filer_x x con =
    recv (fun v ->
    if v mod x <> 0 then send v (fun () -> filer_x x con) else filer_x x con)

let rec sieve con =
    recv (fun v ->
        send v (fun _ -> (filter (fun x -> x mod v <> 0) >|> sieve) con))


run (filtermap (fun s -> String.length s >= 5) (fun s -> "zero"));;