module Tools.Control exposing (interface)

import Control


interface =
    { string = Control.string
    , int = Control.int
    , bool = Control.bool "yes" "no"
    , list = Control.list
    , record = Control.record
    , field = Control.field
    , endRecord = Control.end
    , custom = Control.customType
    , tag0 = Control.tag0
    , tag1 = Control.tag1
    , endCustom = Control.end
    }
