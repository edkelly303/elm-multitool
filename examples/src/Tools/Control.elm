module Tools.Control exposing (interface)

import Control


interface =
    { record = Control.record
    , field = Control.field
    , endRecord = Control.end
    , string = Control.string
    , int = Control.int
    , bool = Control.bool "yes" "no"
    , custom = Control.customType
    , tag0 = Control.tag0
    , tag1 = Control.tag1
    , endCustom = Control.end
    }
