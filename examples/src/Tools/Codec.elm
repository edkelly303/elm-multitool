module Tools.Codec exposing (interface)

import Codec


interface =
    { string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    , list = Codec.list
    , record = Codec.object
    , field = Codec.field
    , endRecord = Codec.buildObject
    , custom = Codec.custom
    , tag0 = Codec.variant0
    , tag1 = Codec.variant1
    , endCustom = Codec.buildCustom
    }
