module Tools.Fuzz exposing (interface)

import Dict
import Fuzz
import Set


interface =
    { string = Fuzz.string
    , int = Fuzz.int
    , bool = Fuzz.bool
    , float = Fuzz.float
    , char = Fuzz.char
    , list = Fuzz.list
    , maybe = Fuzz.maybe
    , array = Fuzz.array
    , dict =
        \k v ->
            Fuzz.pair k v
                |> Fuzz.list
                |> Fuzz.map Dict.fromList
    , set =
        \m ->
            Fuzz.list m
                |> Fuzz.map Set.fromList
    , tuple = Fuzz.pair
    , triple = Fuzz.triple
    , result = Fuzz.result
    , record = record
    , field = field
    , endRecord = endRecord
    , custom = custom
    , tag0 = tag0
    , tag1 = tag1
    , tag2 = tag2
    , tag3 = tag3
    , tag4 = tag4
    , tag5 = tag5
    , endCustom = endCustom
    }


record constructor =
    Fuzz.constant constructor


field fieldName fieldGetter fuzzer builder =
    builder
        |> Fuzz.andMap fuzzer


endRecord builder =
    builder


custom destructor =
    []


tag0 tagName tagConstructor builder =
    Fuzz.constant tagConstructor :: builder


tag1 tagName tagConstructor fuzzer builder =
    Fuzz.map tagConstructor fuzzer :: builder


tag2 tagName tagConstructor f1 f2 builder =
    Fuzz.map2 tagConstructor f1 f2 :: builder


tag3 tagName tagConstructor f1 f2 f3 builder =
    Fuzz.map3 tagConstructor f1 f2 f3 :: builder


tag4 tagName tagConstructor f1 f2 f3 f4 builder =
    Fuzz.map4 tagConstructor f1 f2 f3 f4 :: builder


tag5 tagName tagConstructor f1 f2 f3 f4 f5 builder =
    Fuzz.map5 tagConstructor f1 f2 f3 f4 f5 :: builder


endCustom builder =
    Fuzz.oneOf builder
