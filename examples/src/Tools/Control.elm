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
    , tuple = \a b -> Control.tuple "" a "" b
    , triple = \a b c -> Control.triple "" a "" b "" c
    , result = Control.result
    , record = Control.record
    , field = Control.field
    , endRecord = Control.end
    , custom = Control.customType
    , tag0 = Control.tag0
    , tag1 = Control.tag1
    , tag2 = \tagName tagConstructor c1 c2 -> Control.tag2 tagName tagConstructor ( "", c1 ) ( "", c2 )
    , tag3 = \tagName tagConstructor c1 c2 c3 -> Control.tag3 tagName tagConstructor ( "", c1 ) ( "", c2 ) ( "", c3 )
    , tag4 = \tagName tagConstructor c1 c2 c3 c4 -> Control.tag4 tagName tagConstructor ( "", c1 ) ( "", c2 ) ( "", c3 ) ( "", c4 )
    , tag5 = \tagName tagConstructor c1 c2 c3 c4 c5 -> Control.tag5 tagName tagConstructor ( "", c1 ) ( "", c2 ) ( "", c3 ) ( "", c4 ) ( "", c5 )
    , endCustom = Control.end
    }
