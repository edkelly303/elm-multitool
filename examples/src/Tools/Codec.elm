module Tools.Codec exposing (interface)

import Codec


interface =
    { string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    , float = Codec.float
    , char = Codec.char
    , maybe = Codec.maybe
    , list = Codec.list
    , array = Codec.array
    , dict = Codec.dict
    , set = Codec.set
    , tuple = Codec.tuple
    , triple = Codec.triple
    , result = Codec.result
    , record = Codec.object
    , field = Codec.field
    , endRecord = Codec.buildObject
    , custom = Codec.custom
    , tag0 = Codec.variant0
    , tag1 = Codec.variant1
    , endCustom = Codec.buildCustom
    }
