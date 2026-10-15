module Identity :
  sig
    type 'a t
    val return : 'a -> 'a t
    val bind : 'a t -> ('a -> 'b t) -> 'b t
  end =
  struct
    type 'a t = 'a
    let return x = x
    let bind x f = f x
  end



let add x y = x + y

let result =
  Identity.return 3
  |> Identity.bind (add 2)
  |> Identity.bind (add 5)

let () =
  print_int result;
  print_newline ()
