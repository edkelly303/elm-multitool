module Tools.Random exposing (interface)

import Random
import Random.Array
import Random.Char
import Random.Dict
import Random.Extra
import Random.Set
import Random.String


interface =
    { string = Random.String.string 10 Random.Char.latin
    , int = Random.int Random.minInt Random.maxInt
    , bool = Random.Extra.bool
    , float = Random.float -100000000 10000000
    , char = Random.Char.latin
    , list = Random.Extra.rangeLengthList 0 10
    , maybe = Random.Extra.maybe (Random.Extra.oneIn 10)
    , array = Random.Array.rangeLengthArray 0 10
    , dict = Random.Dict.rangeLengthDict 0 10
    , set = Random.Set.set 10
    , tuple = Random.pair
    , triple = Random.map3 (\a b c -> ( a, b, c ))
    , result = Random.Extra.result (Random.Extra.oneIn 10)
    , record = record
    , field = field
    , endRecord = endRecord
    , custom = custom
    , tag0 = tag0
    , tag1 = tag1
    , endCustom = endCustom
    }


record constructor =
    Random.constant constructor


field fieldName fieldGetter fuzzer builder =
    builder
        |> Random.Extra.andMap fuzzer


endRecord builder =
    builder


custom destructor =
    { generators = identity
    , construct = identity
    }


tag0 tagName tagConstructor builder =
    { generators = builder.generators << Tuple.pair (Random.constant tagConstructor)
    , construct = builder.construct >> construct
    }


tag1 tagName tagConstructor fuzzer builder =
    { generators = builder.generators << Tuple.pair (Random.map tagConstructor fuzzer)
    , construct = builder.construct >> construct
    }


endCustom builder =
    let
        generators =
            builder.generators {}

        ( firstGenerator, _ ) =
            generators
    in
    builder.construct
        (\generatorsList {} ->
            case generatorsList of
                first :: rest ->
                    Random.Extra.choices first rest

                [] ->
                    firstGenerator
        )
        []
        generators


construct next output ( gen, restGens ) =
    next (gen :: output) restGens
