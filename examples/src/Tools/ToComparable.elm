module Tools.ToComparable exposing (interface)

-- COMPARE


interface =
    { record = compRecord
    , field = compField
    , endRecord = compEnd
    , string = compString
    , int = compInt
    , bool = compBool
    }


compRecord : ctor -> rest -> recordData -> rest
compRecord ctor =
    \rest _ -> rest


compField : String -> (recordData -> field) -> (field -> comparable) -> (( comparable, rest ) -> recordData -> builder) -> rest -> recordData -> builder
compField fieldName getField toComparable builder =
    \rest recordData ->
        let
            this =
                recordData
                    |> getField
                    |> toComparable
        in
        builder ( this, rest ) recordData


compEnd : (Int -> rest -> output) -> (rest -> output)
compEnd builder =
    \rest -> builder 0 rest


compString : String -> String
compString =
    String.toLower


compInt : Int -> Int
compInt =
    identity


compBool : Bool -> Int
compBool b =
    if b then
        1

    else
        0
