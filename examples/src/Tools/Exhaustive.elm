module Tools.Exhaustive exposing (interface)

import Exhaustive
import Set
interface =
    { string = Exhaustive.string
    , int = Exhaustive.int
    , bool = Exhaustive.bool
    , float = Exhaustive.float
    , char = Exhaustive.char
    , list = Exhaustive.list 3
    , maybe = Exhaustive.maybe
    , array = Exhaustive.array
    , dict = Exhaustive.dict
    , set = Exhaustive.list 3 >> Exhaustive.map Set.fromList
    , tuple = Exhaustive.pair
    , triple = Exhaustive.triple
    , result = Exhaustive.result
    , record = Exhaustive.record
    , field = \_ _ field -> Exhaustive.field field
    , endRecord = Basics.identity
    , customType = \_ -> Exhaustive.customType
    , variant0 = \_ -> Exhaustive.variant0
    , variant1 = \_ -> Exhaustive.variant1
    , variant2 = \_ -> Exhaustive.variant2
    , variant3 = \_ -> Exhaustive.variant3
    , variant4 = \_ -> Exhaustive.variant4
    , variant5 = \_ -> Exhaustive.variant5
    , endCustomType = Basics.identity
    }