module Tools.Codec exposing (interface)

import Codec


interface =
    { record = Codec.object
    , field = Codec.field
    , endRecord = Codec.buildObject
    , string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    , custom = Codec.custom
    , tag0 = Codec.variant0
    , tag1 = Codec.variant1
    , endCustom = Codec.buildCustom
    }
