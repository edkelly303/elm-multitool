module Tools.ToComparable exposing (interface)

-- COMPARE


interface =
    { record = compRecord
    , field = compField
    , endRecord = compEndRecord
    , custom = compCustom
    , tag0 = compTag0
    , tag1 = compTag1
    , endCustom = compEndCustom
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


compEndRecord : (Int -> rest -> output) -> (rest -> output)
compEndRecord builder =
    \rest -> builder 0 rest


compCustom dtor =
    { dtor = dtor, index = 0 }


compTag0 tagName tagCtor { dtor, index } =
    { dtor = dtor ( index, 0 ), index = index + 1 }


compTag1 tagName tagCtor child { dtor, index } =
    { dtor = dtor (\c -> ( index, child c ))
    , index = index + 1
    }


compEndCustom { dtor } =
    dtor


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
