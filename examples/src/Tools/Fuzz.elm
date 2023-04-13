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


endCustom builder =
    Fuzz.oneOf builder
