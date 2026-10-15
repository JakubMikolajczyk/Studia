module type RandomMonad : sig
     type ’a t
     val return : ’a -> ’a t
     val bind   : ’a t -> (’a -> ’b t) -> ’b t
     val random : int t
end