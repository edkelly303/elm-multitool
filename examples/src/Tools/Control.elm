module Tools.Control exposing (interface)

import Control


interface =
    { record = Control.record
    , field = Control.field
    , end = Control.end
    , string = Control.string
    , int = Control.int
    , bool = Control.bool "yes" "no"
    }
