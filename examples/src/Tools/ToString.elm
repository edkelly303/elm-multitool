module Tools.ToString exposing (interface)


interface =
    { string = string
    , int = int
    , bool = bool

    -- , float = float
    -- , char = char
    -- , maybe = maybe
    , list = list

    -- , array = array
    -- , dict = dict
    -- , set = set
    -- , tuple = tuple
    -- , triple = triple
    -- , result = result
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
    dtor (\c -> tagName ++ " " ++ child c)


endCustom dtor =
    dtor


string : String -> String
string str =
    "\"" ++ str ++ "\""


int : Int -> String
int =
    String.fromInt


bool : Bool -> String
bool b =
    if b then
        "True"

    else
        "False"
