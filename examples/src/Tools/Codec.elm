module Tools.Codec exposing (interface)

import Codec


interface =
    { string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    , float = Codec.float
    , char = Codec.char
    , list = Codec.list
    , maybe = Codec.maybe
    , array = Codec.array
    , dict = \_ x -> Codec.dict x
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
