type empty = |
type _ fin_type =
| Unit : unit fin_type
| Bool : bool fin_type
| Pair : 'a fin_type * 'b fin_type -> ('a * 'b) fin_type
| Empty : empty fin_type
| Either : 'a fin_type * 'b fin_type -> ('a, 'b) Either.t fin_type

let rec all_values : type a. a fin_type -> a Seq.t = function
| Unit -> Seq.return ()
| Bool -> Seq.append (Seq.return true) (Seq.return false)
| Pair(a, b) -> Seq.product (all_values a) (all_values b)
| Empty -> Seq.empty
| Either(a, b) -> Seq.append (Seq.map (fun x -> Either.Right(x)) (all_values b)) (Seq.map (fun x -> Either.Left(x)) (all_values a))


let rec to_list seq =
    Seq.fold_left (fun v acc -> acc ::v) [] seq