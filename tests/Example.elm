module Example exposing (..)

import Control
import Expect
import MultiTool
import Test exposing (..)
import Tools.Control
import Tools.ToString


type alias Tools control toString =
    { control : control
    , toString : toString
    }


t =
    MultiTool.define Tools Tools
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.add .toString Tools.ToString.interface
        |> MultiTool.end


type alias All string int bool float char list maybe array dict set tuple triple result custom =
    { string : string
    , int : int
    , bool : bool
    , float : float
    , char : char
    , list : list
    , maybe : maybe
    , array : array
    , dict : dict
    , set : set
    , tuple : tuple
    , triple : triple
    , result : result
    , custom : custom
    }


allSpec =
    t.record All
        |> t.field "string" .string t.string
        |> t.field "int" .int t.int
        |> t.field "bool" .bool t.bool
        |> t.field "float" .float t.float
        |> t.field "char" .char t.char
        |> t.field "list" .list (t.list t.int)
        |> t.field "maybe" .maybe (t.maybe t.int)
        |> t.field "array" .array (t.array t.int)
        |> t.field "dict" .dict (t.dict t.int t.string)
        |> t.field "set" .set (t.set t.int)
        |> t.field "tuple" .tuple (t.tuple t.int t.string)
        |> t.field "triple" .triple (t.triple t.int t.string t.float)
        |> t.field "result" .result (t.result t.int t.string)
        |> t.field "custom"
            .custom
            (let
                match =
                    \a b c d e f tag ->
                        case tag of
                            A ->
                                a

                            B i ->
                                b i

                            C i1 i2 ->
                                c i1 i2

                            D i1 i2 i3 ->
                                d i1 i2 i3

                            E i1 i2 i3 i4 ->
                                e i1 i2 i3 i4

                            F i1 i2 i3 i4 i5 ->
                                f i1 i2 i3 i4 i5
             in
             t.customType { control = match, toString = match }
                |> t.variant0 "a" A
                |> t.variant1 "b" B t.int
                |> t.variant2 "c" C t.int t.int
                |> t.variant3 "d" D t.int t.int t.int
                |> t.variant4 "e" E t.int t.int t.int t.int
                |> t.variant5 "f" F t.int t.int t.int t.int t.int
                |> t.endCustomType
            )
        |> t.endRecord


type Custom
    = A
    | B Int
    | C Int Int
    | D Int Int Int
    | E Int Int Int Int
    | F Int Int Int Int Int


control =
    t.build allSpec
        |> .control


suite : Test
suite =
    test "all built-in ToolSpecs compile" <|
        \_ ->
            let
                form =
                    Control.simpleForm
                        { control = control
                        , onUpdate = Just
                        , onSubmit = Nothing
                        }

                ( state, _ ) =
                    form.blank

                ( _, output ) =
                    form.submit state
            in
            Expect.err output
