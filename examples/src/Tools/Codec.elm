module Tools.Codec exposing (interface)

import Codec


interface =
    { record = Codec.object
    , field = Codec.field
    , end = Codec.buildObject
    , string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    }
