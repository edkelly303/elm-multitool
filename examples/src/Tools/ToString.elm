module Tools.ToString exposing (interface)

import Array
import Dict
import Set


interface =
    { string = string
    , int = int
    , bool = bool
    , float = float
    , char = char
    , list = list
    , maybe = maybe
    , array = array
    , dict = dict
    , set = set
    , tuple = tuple
    , triple = triple
    , result = result
    , record = record
    , field = field
    , endRecord = endRecord
    , customType = customType
    , variant0 = variant0
    , variant1 = variant1
    , variant2 = variant2
    , variant3 = variant3
    , variant4 = variant4
    , variant5 = variant5
    , endCustomType = endCustomType
    }


list child =
    \listData ->
        case listData of
            [] ->
                "[]"

            _ ->
                "[ " ++ (List.map child listData |> String.join ", ") ++ " ]"


maybe child =
    customType
        (\just nothing tag ->
            case tag of
                Just child_ ->
                    just child_

                Nothing ->
                    nothing
        )
        |> variant1 "Just" Just child
        |> variant0 "Nothing" Nothing
        |> endCustomType


result error value =
    customType
        (\err ok tag ->
            case tag of
                Ok value_ ->
                    ok value_

                Err error_ ->
                    err error_
        )
        |> variant1 "Err" Err error
        |> variant1 "Ok" Ok value
        |> endCustomType


array item =
    \arrayData -> "Array.fromList " ++ list item (Array.toList arrayData)


dict key value =
    \dictData -> "Dict.fromList " ++ list (tuple key value) (Dict.toList dictData)


set member =
    \setData -> "Set.fromList " ++ list member (Set.toList setData)


tuple a b =
    \( aData, bData ) -> "( " ++ a aData ++ ", " ++ b bData ++ " )"


triple a b c =
    \( aData, bData, cData ) -> "( " ++ a aData ++ ", " ++ b bData ++ ", " ++ c cData ++ " )"


record : ctor -> recordData -> List String
record ctor =
    \recordData -> []


field : String -> (recordData -> field) -> (field -> String) -> (recordData -> List String) -> recordData -> List String
field fieldName getField toString builder =
    \recordData ->
        (fieldName ++ " = " ++ toString (getField recordData)) :: builder recordData


endRecord : (recordData -> List String) -> recordData -> String
endRecord builder =
    \recordData -> "{ " ++ String.join ", " (builder recordData |> List.reverse) ++ " }"


customType dtor =
    dtor


variant0 tagName tagCtor dtor =
    dtor tagName


variant1 tagName tagCtor toString1 dtor =
    dtor (\arg1 -> tagName ++ parensIfNeeded (toString1 arg1))


variant2 tagName tagCtor toString1 toString2 dtor =
    dtor
        (\arg1 arg2 ->
            tagName
                ++ parensIfNeeded (toString1 arg1)
                ++ parensIfNeeded (toString2 arg2)
        )


variant3 tagName tagCtor toString1 toString2 toString3 dtor =
    dtor
        (\arg1 arg2 arg3 ->
            tagName
                ++ parensIfNeeded (toString1 arg1)
                ++ parensIfNeeded (toString2 arg2)
                ++ parensIfNeeded (toString3 arg3)
        )


variant4 tagName tagCtor toString1 toString2 toString3 toString4 dtor =
    dtor
        (\arg1 arg2 arg3 arg4 ->
            tagName
                ++ parensIfNeeded (toString1 arg1)
                ++ parensIfNeeded (toString2 arg2)
                ++ parensIfNeeded (toString3 arg3)
                ++ parensIfNeeded (toString4 arg4)
        )


variant5 tagName tagCtor toString1 toString2 toString3 toString4 toString5 dtor =
    dtor
        (\arg1 arg2 arg3 arg4 arg5 ->
            tagName
                ++ parensIfNeeded (toString1 arg1)
                ++ parensIfNeeded (toString2 arg2)
                ++ parensIfNeeded (toString3 arg3)
                ++ parensIfNeeded (toString4 arg4)
                ++ parensIfNeeded (toString5 arg5)
        )


parensIfNeeded childString =
    let
        getEarliest needle haystack =
            String.indices needle haystack
                |> List.minimum
                |> Maybe.withDefault (String.length haystack)

        earliestSpace =
            getEarliest " " childString

        earliestLeftParen =
            getEarliest "(" childString

        earliestDoubleQuote =
            getEarliest "\"" childString

        earliestSingleQuote =
            getEarliest "'" childString

        needsParens =
            List.all (\earliestThing -> earliestSpace < earliestThing)
                [ earliestLeftParen
                , earliestSingleQuote
                , earliestDoubleQuote
                ]
    in
    " "
        ++ (if needsParens then
                "(" ++ childString ++ ")"

            else
                childString
           )


endCustomType dtor =
    dtor


string : String -> String
string str =
    "\"" ++ str ++ "\""


char : Char -> String
char c =
    "'" ++ String.fromChar c ++ "'"


float : Float -> String
float f =
    String.fromFloat f


int : Int -> String
int i =
    String.fromInt i


bool : Bool -> String
bool b =
    if b then
        "True"

    else
        "False"
