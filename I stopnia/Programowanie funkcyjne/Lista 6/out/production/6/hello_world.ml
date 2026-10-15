let rec fact k = function
   | 0 -> (k 1)
   | n -> fact (fun x -> k (n * x)) (n - 1)