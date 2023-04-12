module Tools.ToComparable exposing (interface)

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
        List.concatMap child listData


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
        (\ok err tag ->
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
    \arrayData -> list item (Array.toList arrayData)


dict key value =
    \dictData -> list (tuple key value) (Dict.toList dictData)


set member =
    \setData -> list member (Set.toList setData)


tuple a b =
    \( aData, bData ) -> List.concat [ a aData, b bData ]


triple a b c =
    \( aData, bData, cData ) -> List.concat [ a aData, b bData, c cData ]


record ctor =
    \recordData -> []


field fieldName getField toComparable builder =
    \recordData -> builder recordData ++ toComparable (getField recordData)


endRecord builder =
    \recordData -> builder recordData


custom dtor =
    { dtor = dtor, index = 0 }


tag0 tagName tagCtor { dtor, index } =
    { dtor = dtor [ String.fromInt index ], index = index + 1 }


tag1 tagName tagCtor child { dtor, index } =
    { dtor = dtor (\c -> String.fromInt index :: child c)
    , index = index + 1
    }


endCustom { dtor } =
    dtor


string : String -> List String
string =
    String.toLower >> List.singleton


char : Char -> List String
char c =
    c
        |> String.fromChar
        |> String.toLower
        |> List.singleton


int : Int -> List String
int i =
    i
        |> String.fromInt
        |> List.singleton


float : Float -> List String
float f =
    f
        |> String.fromFloat
        |> List.singleton


bool : Bool -> List String
bool b =
    if b then
        [ "1" ]

    else
        [ "0" ]
