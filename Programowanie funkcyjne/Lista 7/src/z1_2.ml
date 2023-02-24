module type RandomMonad = sig
     type 'a t
     val return : 'a -> 'a t
     val bind   : 'a t -> ('a -> 'b t) -> 'b t
     val random : int t
end

module Shuffle(R : RandomMonad) : sig
     val shuffle : 'a list -> 'a list R.t
end = struct
    let shuffle lst = lst
end