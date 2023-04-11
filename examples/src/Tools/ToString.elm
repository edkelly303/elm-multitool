module Tools.ToString exposing (interface)


interface =
    { string = strString
    , int = strInt
    , bool = strBool
    , list = strList
    , record = strRecord
    , field = strField
    , endRecord = strEnd
    , custom = strCustom
    , tag0 = strTag0
    , tag1 = strTag1
    , endCustom = strEndCustom
    }


strList child =
    \listData ->
        case listData of
            [] ->
                "[]"

            _ ->
                "[ " ++ (List.map child listData |> String.join ", ") ++ " ]"


strRecord : ctor -> recordData -> List String
strRecord ctor =
    \recordData -> []


strField : String -> (recordData -> field) -> (field -> String) -> (recordData -> List String) -> recordData -> List String
strField fieldName getField toString builder =
    \recordData ->
        (fieldName ++ " = " ++ toString (getField recordData)) :: builder recordData


strEnd : (recordData -> List String) -> recordData -> String
strEnd builder =
    \recordData -> "{ " ++ String.join ", " (builder recordData |> List.reverse) ++ " }"


strCustom dtor =
    dtor


strTag0 tagName tagCtor dtor =
    dtor tagName


strTag1 tagName tagCtor child dtor =
    dtor (\c -> tagName ++ " " ++ child c)


strEndCustom dtor =
    dtor


strString : String -> String
strString =
    identity


strInt : Int -> String
strInt =
    String.fromInt


strBool : Bool -> String
strBool b =
    if b then
        "True"

    else
        "False"
