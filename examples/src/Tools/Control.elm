module Tools.Control exposing (interface)

import Control


interface =
    { string = Control.string
    , int = Control.int
    , bool = Control.bool "yes" "no"
    , float = Control.float
    , char = Control.char
    , list = Control.list
    , maybe = Control.maybe
    , array = Control.array
    , dict = \k v -> Control.dict "" k "" v
    , set = Control.set
    , tuple = Control.tuple
    , triple = Control.triple
    , result = Control.result
    , record = Control.record
    , field = Control.field
    , endRecord = Control.end
    , custom = Control.customType
    , tag0 = Control.tag0
    , tag1 = Control.tag1
    , endCustom = Control.end
    }
