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
    , custom = custom
    , tag0 = tag0
    , tag1 = tag1
    , endCustom = endCustom
    }


list child =
    \listData ->
        case listData of
            [] ->
                "[]"

            _ ->
                "[ " ++ (List.map child listData |> String.join ", ") ++ " ]"


maybe child =
    custom
        (\just nothing tag ->
            case tag of
                Just child_ ->
                    just child_

                Nothing ->
                    nothing
        )
        |> tag1 "Just" Just child
        |> tag0 "Nothing" Nothing
        |> endCustom


result error value =
    custom
        (\err ok tag ->
            case tag of
                Ok value_ ->
                    ok value_

                Err error_ ->
                    err error_
        )
        |> tag1 "Err" Err error
        |> tag1 "Ok" Ok value
        |> endCustom


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


custom dtor =
    dtor


tag0 tagName tagCtor dtor =
    dtor tagName


tag1 tagName tagCtor child dtor =
    dtor
        (\c ->
            let
                childString =
                    child c

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
            tagName
                ++ " "
                ++ (if needsParens then
                        "(" ++ childString ++ ")"

                    else
                        childString
                   )
        )


endCustom dtor =
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
