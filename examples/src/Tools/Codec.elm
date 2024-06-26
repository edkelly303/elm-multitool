module Tools.Codec exposing (interface)

import Codec
import Dict


interface =
    { string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    , float = Codec.float
    , char = Codec.char
    , list = Codec.list
    , maybe = Codec.maybe
    , array = Codec.array
    , dict =
        \k v ->
            Codec.tuple k v
                |> Codec.list
                |> Codec.map Dict.fromList Dict.toList
    , set = Codec.set
    , tuple = Codec.tuple
    , triple = Codec.triple
    , result = Codec.result
    , record = Codec.object
    , field = Codec.field
    , endRecord = Codec.buildObject
    , customType = Codec.custom
    , variant0 = Codec.variant0
    , variant1 = Codec.variant1
    , variant2 = Codec.variant2
    , variant3 = Codec.variant3
    , variant4 = Codec.variant4
    , variant5 = Codec.variant5
    , endCustomType = Codec.buildCustom
    }
