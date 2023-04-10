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


compRecord ctor =
    \recordData -> []


compField fieldName getField toComparable builder =
    \recordData -> builder recordData ++ toComparable (getField recordData)


compEndRecord builder =
    \recordData -> builder recordData


compCustom dtor =
    { dtor = dtor, index = 0 }


compTag0 tagName tagCtor { dtor, index } =
    { dtor = dtor [ String.fromInt index ], index = index + 1 }


compTag1 tagName tagCtor child { dtor, index } =
    { dtor = dtor (\c -> String.fromInt index :: child c)
    , index = index + 1
    }


compEndCustom { dtor } =
    dtor


compString : String -> List String
compString =
    String.toLower >> List.singleton


compInt : Int -> List String
compInt =
    String.fromInt >> List.singleton


compBool : Bool -> List String
compBool b =
    if b then
        [ "1" ]

    else
        [ "0" ]
