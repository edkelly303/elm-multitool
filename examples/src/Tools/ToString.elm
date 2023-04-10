module Tools.ToString exposing (interface)


interface =
    { record = strRecord
    , field = strField
    , endRecord = strEnd
    , string = strString
    , int = strInt
    , bool = strBool
    , custom = strCustom
    , tag0 = strTag0
    , tag1 = strTag1
    , endCustom = strEndCustom
    }


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
