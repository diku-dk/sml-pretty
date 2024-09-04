structure Example =
struct

  (*
  Small demonstration of how to use sml-pretty and the utilities.
  
  An often occurring challenge is to format if-then-else nicely, so that
  is mainly what we'll demonstrate,
  *)

  local structure U = Utility val $ = U.$ val ^+^ = U.^+^ infix ^+^
  in

    datatype Ast =
      Var of string
    | Lit of int
    | Opr of Ast * string * Ast
    | Cond of Ast * Ast * Ast

    fun toDoc ast =
      case ast of
        Var v => $v
      | Lit n => Pretty.int n
      | Opr (x, opr, y) => U.bin toDoc ($opr) (x, y)
      | Cond (test, pos, neg) =>
          Pretty.group (U.spread
            [ U.block 2 ($ "if" ^+^ toDoc test)
            , U.block 2 ($ "then" ^+^ toDoc pos)
            , U.block 2 ($ "else" ^+^ toDoc neg)
            ])

    (* AST for `if (x > y) then x+1 else y*z` *)
    val maxEx = Cond
      ( Opr (Var "x", ">", Var "y")
      , Opr (Var "x", "+", Lit 1)
      , Opr (Var "y", "*", Var "z")
      )
    val maxDoc = toDoc maxEx
    val maxS50 =
      Pretty.toString 50
        maxDoc (* equals "if (x > y) then (x + 1) else (y * z)\n" *)
    val maxS30 =
      Pretty.toString 30
        maxDoc (* equals "if (x > y)\nthen (x + 1)\nelse (y * z)\n" *)
    val maxS10 =
      Pretty.toString 10
        maxDoc (* equals "if (x > y)\nthen\n  (x + 1)\nelse\n  (y * z)\n" *)


    val nested = Cond
      (Opr (Var "x", ">", Var "y"), Opr (Var "x", "+", Lit 1), maxEx)
    val nestDoc = toDoc nested
    val nestS50 = Pretty.toString 50 nestDoc
    val nestS30 = Pretty.toString 30 nestDoc
    val nestS10 = Pretty.toString 10 nestDoc


  end
end

val () =
  ( print ("S50:\n" ^ Example.nestS50 ^ "\n")
  ; print ("S30:\n" ^ Example.nestS30 ^ "\n")
  ; print ("S10:\n" ^ Example.nestS10 ^ "\n")
  )
