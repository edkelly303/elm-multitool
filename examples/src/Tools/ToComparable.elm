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
        List.concatMap child listData


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
        (\ok err tag ->
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


customType dtor =
    { dtor = dtor, index = 0 }


variant0 tagName tagCtor { dtor, index } =
    { dtor = dtor [ String.fromInt index ], index = index + 1 }


variant1 tagName tagCtor toComp1 { dtor, index } =
    { dtor = dtor (\arg1 -> String.fromInt index :: toComp1 arg1)
    , index = index + 1
    }


variant2 tagName tagCtor toComp1 toComp2 { dtor, index } =
    { dtor =
        dtor
            (\arg1 arg2 ->
                String.fromInt index
                    :: (toComp1 arg1 ++ toComp2 arg2)
            )
    , index = index + 1
    }


variant3 tagName tagCtor toComp1 toComp2 toComp3 { dtor, index } =
    { dtor =
        dtor
            (\arg1 arg2 arg3 ->
                String.fromInt index
                    :: (toComp1 arg1
                            ++ toComp2 arg2
                            ++ toComp3 arg3
                       )
            )
    , index = index + 1
    }


variant4 tagName tagCtor toComp1 toComp2 toComp3 toComp4 { dtor, index } =
    { dtor =
        dtor
            (\arg1 arg2 arg3 arg4 ->
                String.fromInt index
                    :: (toComp1 arg1
                            ++ toComp2 arg2
                            ++ toComp3 arg3
                            ++ toComp4 arg4
                       )
            )
    , index = index + 1
    }


variant5 tagName tagCtor toComp1 toComp2 toComp3 toComp4 toComp5 { dtor, index } =
    { dtor =
        dtor
            (\arg1 arg2 arg3 arg4 arg5 ->
                String.fromInt index
                    :: (toComp1 arg1
                            ++ toComp2 arg2
                            ++ toComp3 arg3
                            ++ toComp4 arg4
                            ++ toComp5 arg5
                       )
            )
    , index = index + 1
    }


endCustomType { dtor } =
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
