module Tools.ToComparable exposing (interface)


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
        List.concatMap child listData


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


int : Int -> List String
int =
    String.fromInt >> List.singleton


bool : Bool -> List String
bool b =
    if b then
        [ "1" ]

    else
        [ "0" ]
