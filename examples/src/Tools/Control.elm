module Tools.Control exposing (interface)

import Control


interface =
    { string = Control.string
    , int = Control.int
    , bool = Control.bool
    , float = Control.float
    , char = Control.char
    , list = Control.list
    , maybe = Control.maybe
    , array = Control.array
    , dict = Control.dict
    , set = Control.set
    , tuple = Control.tuple
    , triple = Control.triple
    , result = Control.result
    , record = Control.record
    , field =
        -- Control.field doesn't use the field name
        \_ getter subControl -> Control.field getter subControl
    , endRecord = Control.endRecord
    , custom = Control.customType
    , variant0 = Control.variant0
    , variant1 = Control.variant1
    , variant2 = Control.variant2
    , variant3 = Control.variant3
    , variant4 = Control.variant4
    , variant5 = Control.variant5
    , endCustom = Control.endCustomType
    }
