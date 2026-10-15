open Proc

let rec map f con =
    recv (fun v ->
    send (f v)(fun () -> map f con))