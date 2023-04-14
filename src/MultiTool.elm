module MultiTool exposing (define, add, end)

{-|


# MultiTool

**Fun fact**: The type annotations for the functions in this package are pretty 
horrifying..

**Hot tip**: Ignore them! There's no need to put any of these functions, or the 
tools they produce, in your application's `Msg` or `Model` type. So you don't need 
to know or care about what their type signatures are. Just read the docs and 
look at the examples. It'll be fine.*

*Unless you make any kind of minor typo in your code, in which case the Elm 
compiler may respond with a Lovecraftian error message 😱.

@docs define, add, end

-}


{-| Begin a definition for a MultiTool. 

This function takes two identical arguments. Both arguments should be a function 
that constructs a record with a field for each of the tools you intend 
to include in your MultiTool.

For example, if you are making a MultiTool that includes a ToString tool and a
ToComparable tool, you could do something like this:

    import ToString
    import ToComparable

    type alias Tools toString toComparable = 
        { toString : toString
        , toComparable : toComparable 
        }

    tools =
        MultiTool.define Tools Tools 
            |> MultiTool.add .toString ToString.interface
            |> MultiTool.add .toComparable ToComparable.interface
            |> MultiTool.end

**Note**: The order of the type parameters in the `Tools` definition is 
important. It needs to match the order in which you add the tool interfaces 
with `MultiTool.add`. 

In this example, we see that `toString` comes first and
`toComparable` comes second in _both_ the `Tools` type alias and the 
`tools` definition.
-}
define :
    b
    -> c
    ->
        { after : {}
        , afters : {}
        , applyDelta : a41 -> a41
        , array : a40 -> a40
        , arrayMaker : a39 -> a39
        , before : a38 -> a38
        , befores : a37 -> a37
        , bool : a36 -> a36
        , char : a35 -> a35
        , constructMultiTool : a34 -> a34
        , constructTweak : a33 -> a33
        , custom : a32 -> a32
        , customEnder : a31 -> a31
        , customMaker : a30 -> a30
        , destructorFieldGetter : a29 -> a29
        , dict : a28 -> a28
        , dictMaker : a27 -> a27
        , endCustom : a26 -> a26
        , endRecord : a25 -> a25
        , field : a24 -> a24
        , fieldMaker : a23 -> a23
        , float : a22 -> a22
        , int : a21 -> a21
        , list : a20 -> a20
        , listMaker : a19 -> a19
        , maybe : a18 -> a18
        , maybeMaker : a17 -> a17
        , record : a16 -> a16
        , recordEnder : a15 -> a15
        , recordMaker : a14 -> a14
        , result : a13 -> a13
        , resultMaker : a12 -> a12
        , set : a11 -> a11
        , setMaker : a10 -> a10
        , string : a9 -> a9
        , tag0 : a8 -> a8
        , tag0Maker : a7 -> a7
        , tag1 : a6 -> a6
        , tag1Maker : a5 -> a5
        , toolConstructor : b
        , triple : a4 -> a4
        , tripleMaker : a3 -> a3
        , tuple : a2 -> a2
        , tupleMaker : a1 -> a1
        , tweakConstructor : c
        , tweakerMaker : a -> a
        }
define toolConstructor tweakConstructor =
    { -- primitives
      string = identity
    , int = identity
    , bool = identity
    , float = identity
    , char = identity

    -- built-in combinators
    , list = identity
    , listMaker = identity
    , maybe = identity
    , maybeMaker = identity
    , array = identity
    , arrayMaker = identity
    , dict = identity
    , dictMaker = identity
    , set = identity
    , setMaker = identity
    , tuple = identity
    , tupleMaker = identity
    , triple = identity
    , tripleMaker = identity
    , result = identity
    , resultMaker = identity

    -- record combinators
    , record = identity
    , recordMaker = identity
    , field = identity
    , fieldMaker = identity
    , endRecord = identity
    , recordEnder = identity

    -- custom type combinators
    , custom = identity
    , customMaker = identity
    , tag0 = identity
    , tag0Maker = identity
    , tag1 = identity
    , tag1Maker = identity
    , endCustom = identity
    , customEnder = identity

    -- constructing the multitool
    , toolConstructor = toolConstructor
    , destructorFieldGetter = identity
    , constructMultiTool = identity

    -- constructing tweakers
    , before = identity
    , befores = identity
    , after = {}
    , afters = {}
    , tweakerMaker = identity
    , constructTweak = identity
    , applyDelta = identity
    , tweakConstructor = tweakConstructor
    }


{-| Add a tool to your MultiTool. 

This function takes three arguments. The first is a field accessor, which should
match one of the fields of the record constructor you passed to 
`MultiTool.define`. For example: `.codec`.

The second is a tool interface - a record whose fields contain all the functions
we will need to make the tool work. Here's an example of an interface for the 
awesome `miniBill/elm-codec` package:

    import Codec

    codecInterface =
        { string = Codec.string
        , int = Codec.int
        , bool = Codec.bool
        , float = Codec.float
        , char = Codec.char
        , list = Codec.list
        , maybe = Codec.maybe
        , array = Codec.array
        , dict =
            \k v ->
                Codec.tuple k v
                    |> Codec.list
                    |> Codec.map Dict.fromList Dict.toList
        , set = Codec.set
        , tuple = Codec.tuple
        , triple = Codec.triple
        , result = Codec.result
        , record = Codec.object
        , field = Codec.field
        , endRecord = Codec.buildObject
        , custom = Codec.custom
        , tag0 = Codec.variant0
        , tag1 = Codec.variant1
        , endCustom = Codec.buildCustom
        }


(You'll notice that this interface definition mostly looks straighforward, 
except for the `dict` field. The problem here is that we need a `Dict` 
implementation that can take any `comparable` as a key, but `elm-codec`'s 
built-in `dict` function only accepts `String`s as keys. Fortunately, we can 
build the function we need using `elm-codec`'s lower-level primitives.)

The third and final argument is the data structure that you've already created 
using `define`. The API here is designed for piping with the `|>` operator, so 
you'll usually want to apply this final argument like this:

    tools = 
        MultiTool.define Tools Tools
            |> MultiTool.add .codec codecInterface
-}
add :
    a76
    ->
        { j
            | array : a81
            , bool : a79
            , char : a78
            , custom : a77
            , dict : a75
            , endCustom : a74
            , endRecord : a73
            , field : a72
            , float : a71
            , int : a70
            , list : a69
            , maybe : a68
            , record : a67
            , result : a66
            , set : a65
            , string : a64
            , tag0 : a63
            , tag1 : a62
            , triple : a61
            , tuple : a60
        }
    ->
        { l1
            | after : k
            , afters : l
            , applyDelta : a58 -> m -> n -> o
            , array : ( a81, a57 ) -> c38
            , arrayMaker : a56 -> b15 -> a55 -> c37
            , before : ( Maybe a80, a54 ) -> c36
            , befores : ( ( Maybe a80, a54 ) -> c36, a53 ) -> c35
            , bool : ( a79, a52 ) -> c34
            , char : ( a78, a51 ) -> c33
            , constructMultiTool : a50 -> a49 -> b14 -> c32
            , constructTweak : a48 -> p -> q -> r
            , custom : ( a77, a47 ) -> c31
            , customEnder : a46 -> b13 -> a45 -> c30
            , customMaker : a44 -> b12 -> a43 -> c29 -> d12
            , destructorFieldGetter : ( a76, a42 ) -> c28
            , dict : ( a75, a41 ) -> c27
            , dictMaker : a40 -> b11 -> a39 -> c26 -> d11
            , endCustom : ( a74, a38 ) -> c25
            , endRecord : ( a73, a37 ) -> c24
            , field : ( a72, a36 ) -> c23
            , fieldMaker : a35 -> b10 -> c22 -> a34 -> d10 -> e9 -> f5
            , float : ( a71, a33 ) -> c21
            , int : ( a70, a32 ) -> c20
            , list : ( a69, a31 ) -> c19
            , listMaker : a30 -> b9 -> a29 -> c18
            , maybe : ( a68, a28 ) -> c17
            , maybeMaker : a27 -> b8 -> a26 -> c16
            , record : ( a67, a25 ) -> c15
            , recordEnder : a24 -> b7 -> a23 -> c14
            , recordMaker : a22 -> b6 -> a21 -> c13
            , result : ( a66, a20 ) -> c12
            , resultMaker : a19 -> b5 -> a18 -> c11 -> d5
            , set : ( a65, a17 ) -> c10
            , setMaker : a16 -> b4 -> a15 -> c9
            , string : ( a64, a14 ) -> c8
            , tag0 : ( a63, a13 ) -> c7
            , tag0Maker : a12 -> b3 -> c6 -> a11 -> d3 -> e3
            , tag1 : ( a62, a10 ) -> c5
            , tag1Maker : a9 -> b2 -> c4 -> a8 -> d2 -> e2 -> f2
            , toolConstructor : s
            , triple : ( a61, a7 ) -> c3
            , tripleMaker : a6 -> b1 -> a5 -> c2 -> d1 -> e1
            , tuple : ( a60, a4 ) -> c1
            , tupleMaker : a3 -> b -> a2 -> c -> d
            , tweakConstructor : t
            , tweakerMaker :
                a1 -> (({} -> {} -> {}) -> w -> x -> y) -> z -> j1 -> k1
        }
    ->
        { after : ( Maybe a59, k )
        , afters : ( k, l )
        , applyDelta : a58 -> ( Maybe (m1 -> m1), m ) -> ( m1, n ) -> ( m1, o )
        , array : a57 -> c38
        , arrayMaker : a56 -> ( d15, b15 ) -> ( d15 -> e13, a55 ) -> ( e13, c37 )
        , before : a54 -> c36
        , befores : a53 -> c35
        , bool : a52 -> c34
        , char : a51 -> c33
        , constructMultiTool : a50 -> (d14 -> a49) -> ( d14, b14 ) -> c32
        , constructTweak : a48 -> (n1 -> p) -> ( n1, q ) -> r
        , custom : a47 -> c31
        , customEnder : a46 -> ( d13, b13 ) -> ( d13 -> e12, a45 ) -> ( e12, c30 )
        , customMaker :
            a44 -> b12 -> ( b12 -> e11, a43 ) -> ( e11 -> f7, c29 ) -> ( f7, d12 )
        , destructorFieldGetter : a42 -> c28
        , dict : a41 -> c27
        , dictMaker :
            a40
            -> ( e10, b11 )
            -> ( f6, a39 )
            -> ( e10 -> f6 -> g6, c26 )
            -> ( g6, d11 )
        , endCustom : a38 -> c25
        , endRecord : a37 -> c24
        , field : a36 -> c23
        , fieldMaker :
            a35
            -> b10
            -> c22
            -> ( g5, a34 )
            -> ( h2, d10 )
            -> ( b10 -> c22 -> g5 -> h2 -> i2, e9 )
            -> ( i2, f5 )
        , float : a33 -> c21
        , int : a32 -> c20
        , list : a31 -> c19
        , listMaker : a30 -> ( d9, b9 ) -> ( d9 -> e8, a29 ) -> ( e8, c18 )
        , maybe : a28 -> c17
        , maybeMaker : a27 -> ( d8, b8 ) -> ( d8 -> e7, a26 ) -> ( e7, c16 )
        , record : a25 -> c15
        , recordEnder : a24 -> ( d7, b7 ) -> ( d7 -> e6, a23 ) -> ( e6, c14 )
        , recordMaker : a22 -> b6 -> ( b6 -> d6, a21 ) -> ( d6, c13 )
        , result : a20 -> c12
        , resultMaker :
            a19
            -> ( e5, b5 )
            -> ( f4, a18 )
            -> ( e5 -> f4 -> g4, c11 )
            -> ( g4, d5 )
        , set : a17 -> c10
        , setMaker : a16 -> ( d4, b4 ) -> ( d4 -> e4, a15 ) -> ( e4, c9 )
        , string : a14 -> c8
        , tag0 : a13 -> c7
        , tag0Maker :
            a12
            -> b3
            -> c6
            -> ( f3, a11 )
            -> ( b3 -> c6 -> f3 -> g3, d3 )
            -> ( g3, e3 )
        , tag1 : a10 -> c5
        , tag1Maker :
            a9
            -> b2
            -> c4
            -> ( g2, a8 )
            -> ( h1, d2 )
            -> ( b2 -> c4 -> g2 -> h1 -> i1, e2 )
            -> ( i1, f2 )
        , toolConstructor : s
        , triple : a7 -> c3
        , tripleMaker :
            a6
            -> ( f1, b1 )
            -> ( g1, a5 )
            -> ( h, c2 )
            -> ( f1 -> g1 -> h -> i, d1 )
            -> ( i, e1 )
        , tuple : a4 -> c1
        , tupleMaker : a3 -> ( e, b ) -> ( f, a2 ) -> ( e -> f -> g, c ) -> ( g, d )
        , tweakConstructor : t
        , tweakerMaker :
            a1
            -> (({} -> {} -> {}) -> w -> x -> y)
            -> ( ( Maybe a, o1 ) -> w, z )
            -> ( o1, j1 )
            -> ( a -> x -> y, k1 )
        }
add destructorFieldGetter tool builder =
    { -- primitives
      string = builder.string << Tuple.pair tool.string
    , int = builder.int << Tuple.pair tool.int
    , bool = builder.bool << Tuple.pair tool.bool
    , float = builder.float << Tuple.pair tool.float
    , char = builder.char << Tuple.pair tool.char

    -- built-in combinators
    , list = builder.list << Tuple.pair tool.list
    , listMaker = builder.listMaker >> listMaker
    , maybe = builder.maybe << Tuple.pair tool.maybe
    , maybeMaker = builder.maybeMaker >> maybeMaker
    , array = builder.array << Tuple.pair tool.array
    , arrayMaker = builder.arrayMaker >> arrayMaker
    , dict = builder.dict << Tuple.pair tool.dict
    , dictMaker = builder.dictMaker >> dictMaker
    , set = builder.set << Tuple.pair tool.set
    , setMaker = builder.setMaker >> setMaker
    , tuple = builder.tuple << Tuple.pair tool.tuple
    , tupleMaker = builder.tupleMaker >> tupleMaker
    , triple = builder.triple << Tuple.pair tool.triple
    , tripleMaker = builder.tripleMaker >> tripleMaker
    , result = builder.result << Tuple.pair tool.result
    , resultMaker = builder.resultMaker >> resultMaker

    -- record combinators
    , record = builder.record << Tuple.pair tool.record
    , recordMaker = builder.recordMaker >> recordMaker
    , field = builder.field << Tuple.pair tool.field
    , fieldMaker = builder.fieldMaker >> fieldMaker
    , endRecord = builder.endRecord << Tuple.pair tool.endRecord
    , recordEnder = builder.recordEnder >> recordEnder

    -- custom type combinators
    , custom = builder.custom << Tuple.pair tool.custom
    , customMaker = builder.customMaker >> customMaker
    , tag0 = builder.tag0 << Tuple.pair tool.tag0
    , tag0Maker = builder.tag0Maker >> tag0Maker
    , tag1 = builder.tag1 << Tuple.pair tool.tag1
    , tag1Maker = builder.tag1Maker >> tag1Maker
    , endCustom = builder.endCustom << Tuple.pair tool.endCustom
    , customEnder = builder.customEnder >> customEnder

    -- constructing the multitool
    , toolConstructor = builder.toolConstructor
    , destructorFieldGetter = builder.destructorFieldGetter << Tuple.pair destructorFieldGetter
    , constructMultiTool = builder.constructMultiTool >> constructMultiTool

    -- constructing tweakers
    , before = builder.before << Tuple.pair Nothing
    , befores = builder.befores << Tuple.pair builder.before
    , after = ( Nothing, builder.after )
    , afters = ( builder.after, builder.afters )
    , tweakerMaker = builder.tweakerMaker >> tweakerMaker
    , applyDelta = builder.applyDelta >> applyDelta
    , constructTweak = builder.constructTweak >> constructTweak
    , tweakConstructor = builder.tweakConstructor
    }


{-| Complete the definition of a MultiTool.

    tools =
        MultiTool.define Tools Tools 
            |> MultiTool.add .toString ToString.interface
            |> MultiTool.add .toComparable ToComparable.interface
            |> MultiTool.end

This function produces a record that contains all the functions you'll need to 
create tool definitions for the types in your application. If you define a 
MultiTool like `tools` in the example above, it'll give you access to the 
following functions:

### Definitions for primitive tools
We've got `tools.bool`, `tools.string`, `tools.int`, `tools.float`, and 
`tools.char`.

For example:

    boolTool = 
        tools.build tools.bool
    
    trueFact =
        boolTool.toString True == "True"

### Definitions for common combinators
We've got `tools.maybe`, `tools.result`, `tools.list`, `tools.array`, 
`tools.dict`, `tools.set`, `tools.tuple`, _and_ `tools.triple`.

For example:

    listBoolDefinition = 
        tools.list tools.bool

    tupleIntStringDefinition =
        tools.tuple tools.int tools.string

### Definitions for combinators for custom types

To define tools for your own custom types, use `tools.custom`, `tools.tag0`, 
`tools.tag1`, and `tools.endCustom`.

For example, if we really hated Elm's `Maybe` type and wanted it to be called 
`Option` instead:

    type Option value 
        = Some value
        | None

    optionDefinition valueDefinition =
        let
            match some none tag =
                case tag of 
                    Some value -> 
                        some value
                        
                    None  -> 
                        none
        in
        tools.custom 
            { toString = match, toComparable = match } 
            |> tools.tag1 "Some" Some valueDefinition
            |> tools.tag0 "None" None
            |> tools.endCustom

**Note**: You _must_ define the `match` function either in a `let-in` block 
within your tool definition, or as a top-level function in one of your modules. 
If you try and parameterise your tool definition to take a `match` function as 
one of its arguments, it won't work - you'll get a compiler error.

The explanation for this is a bit beyond me, but I think it goes: "something 
something `forall`, something something let-polymorphism."

### Definitions for combinators for records
For records (and indeed any kind of "product" type), check out `tools.record`, 
`tools.field`, and `tools.endRecord`.

For example:

    type alias User = 
        { name : String, age : Int }

    userToolDefinition = 
        tools.record User
            |> tools.field "name" .name tools.string
            |> tools.field "age" .age tools.int
            |> tools.endRecord

### Build a tool from a tool definition
`tools.build` turns a tool definition into a usable tool.

For example:
   
    userTool = 
        tools.build userToolDefinition

    user = 
        { name = "Ed", age = 41 }
    
    trueFact =
        userTool.toString user == "{ name = \"Ed\", age = 41 }"


### Customise a tool definition
`tools.tweak` allows you to alter or replace the default tool definitions 
specified in the tool's interface.

For example, if you've defined a MultiTool that includes an interface for using 
`edkelly303/elm-any-type-forms`, you could customise the default `string` 
control like this:

    import Control

    myStringControl = 
        tools.string
            |> tools.tweak.control (Control.debounce 1000)
            |> tools.tweak.control 
                (Control.failIf String.isEmpty "Field can't be blank")
-}
end :
    { m1
        | afters : l
        , applyDelta : m
        , array : {} -> d11
        , arrayMaker : ({} -> {} -> {}) -> c6 -> d11 -> e12
        , befores : {} -> n
        , bool : {} -> o
        , char : {} -> p
        , constructMultiTool : (a5 -> {} -> a5) -> c7 -> d4 -> e11
        , constructTweak : (q -> {} -> q) -> s -> t -> u
        , custom : {} -> f7
        , customEnder : ({} -> {} -> {}) -> c5 -> d10 -> e9
        , customMaker : (a4 -> {} -> {} -> {}) -> d3 -> e13 -> f7 -> g7
        , destructorFieldGetter : {} -> e13
        , dict : {} -> f6
        , dictMaker : ({} -> {} -> {} -> {}) -> d2 -> e10 -> f6 -> g6
        , endCustom : {} -> d10
        , endRecord : {} -> d7
        , field : {} -> j1
        , fieldMaker :
            (a3 -> b2 -> {} -> {} -> {} -> {}) -> f3 -> g5 -> h1 -> i3 -> j1 -> k1
        , float : {} -> v
        , int : {} -> w
        , list : {} -> d9
        , listMaker : ({} -> {} -> {}) -> c3 -> d9 -> e7
        , maybe : {} -> d8
        , maybeMaker : ({} -> {} -> {}) -> c2 -> d8 -> e6
        , record : {} -> d6
        , recordEnder : ({} -> {} -> {}) -> c4 -> d7 -> e8
        , recordMaker : (a2 -> {} -> {}) -> c1 -> d6 -> e5
        , result : {} -> f5
        , resultMaker : ({} -> {} -> {} -> {}) -> d1 -> e4 -> f5 -> g4
        , set : {} -> d5
        , setMaker : ({} -> {} -> {}) -> c -> d5 -> e3
        , string : {} -> x
        , tag0 : {} -> h3
        , tag0Maker : (a1 -> b1 -> {} -> {} -> {}) -> e2 -> f2 -> g3 -> h3 -> i2
        , tag1 : {} -> j
        , tag1Maker :
            (a -> b -> c8 -> {} -> {} -> {}) -> f1 -> g2 -> h -> i1 -> j -> k
        , toolConstructor : c7
        , triple : {} -> h2
        , tripleMaker : ({} -> {} -> {} -> {} -> {}) -> e1 -> f -> g1 -> h2 -> i
        , tuple : {} -> f4
        , tupleMaker : ({} -> {} -> {} -> {}) -> d -> e -> f4 -> g
        , tweakConstructor : s
        , tweakerMaker : (y -> {} -> {} -> {}) -> m -> n -> l -> t
    }
    ->
        { array : c6 -> e12
        , bool : o
        , build : d4 -> e11
        , char : p
        , custom : d3 -> g7
        , dict : d2 -> e10 -> g6
        , endCustom : c5 -> e9
        , endRecord : c4 -> e8
        , field : f3 -> g5 -> h1 -> i3 -> k1
        , float : v
        , int : w
        , list : c3 -> e7
        , maybe : c2 -> e6
        , record : c1 -> e5
        , result : d1 -> e4 -> g4
        , set : c -> e3
        , string : x
        , tag0 : e2 -> f2 -> g3 -> i2
        , tag1 : f1 -> g2 -> h -> i1 -> k
        , triple : e1 -> f -> g1 -> i
        , tuple : d -> e -> g
        , tweak : u
        }
end toolBuilder =
    let
        -- primitives
        strings =
            toolBuilder.string {}

        ints =
            toolBuilder.int {}

        bools =
            toolBuilder.bool {}

        floats =
            toolBuilder.float {}

        chars =
            toolBuilder.char {}

        -- built-in combinators
        lists =
            toolBuilder.list {}

        maybes =
            toolBuilder.maybe {}

        arrays =
            toolBuilder.array {}

        dicts =
            toolBuilder.dict {}

        sets =
            toolBuilder.set {}

        tuples =
            toolBuilder.tuple {}

        triples =
            toolBuilder.triple {}

        results =
            toolBuilder.result {}

        -- record combinators
        records =
            toolBuilder.record {}

        fields =
            toolBuilder.field {}

        endRecords =
            toolBuilder.endRecord {}

        -- custom type combinators
        customs =
            toolBuilder.custom {}

        tag0s =
            toolBuilder.tag0 {}

        tag1s =
            toolBuilder.tag1 {}

        endCustoms =
            toolBuilder.endCustom {}

        destructorFieldGetters =
            toolBuilder.destructorFieldGetter {}
    in
    { -- primitive types
      string = strings
    , int = ints
    , bool = bools
    , float = floats
    , char = chars

    -- built-in combinators
    , list =
        \listChildren ->
            doMakeList toolBuilder.listMaker listChildren lists
    , maybe =
        \maybeContents ->
            doMakeMaybe toolBuilder.maybeMaker maybeContents maybes
    , array =
        \contents ->
            doMakeArray toolBuilder.arrayMaker contents arrays
    , dict =
        \keys values ->
            doMakeDict toolBuilder.dictMaker keys values dicts
    , set =
        \contents ->
            doMakeSet toolBuilder.setMaker contents sets
    , tuple =
        \a b ->
            doMakeTuple toolBuilder.tupleMaker a b tuples
    , triple =
        \a b c ->
            doMakeTriple toolBuilder.tripleMaker a b c triples
    , result =
        \errors values ->
            doMakeResult toolBuilder.resultMaker errors values results

    -- records
    , record =
        \recordConstructor ->
            doMakeRecord toolBuilder.recordMaker recordConstructor records
    , field =
        \fieldName getField child recordBuilder ->
            doMakeFields toolBuilder.fieldMaker fieldName getField child recordBuilder fields
    , endRecord =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder endRecords

    -- custom types
    , custom =
        \customDestructors ->
            doMakeCustom toolBuilder.customMaker customDestructors destructorFieldGetters customs
    , tag0 =
        \tagName tagConstructor customBuilder ->
            doMakeTag0 toolBuilder.tag0Maker tagName tagConstructor customBuilder tag0s
    , tag1 =
        \tagName tagConstructor child1 customBuilder ->
            doMakeTag1 toolBuilder.tag1Maker tagName tagConstructor child1 customBuilder tag1s
    , endCustom =
        \customBuilder ->
            doEndCustom toolBuilder.customEnder customBuilder endCustoms

    -- turn a definition into a usable multiTool
    , build =
        \toolDefinition ->
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.toolConstructor toolDefinition
    , tweak =
        let
            tweakers =
                doMakeTweakers toolBuilder.tweakerMaker toolBuilder.applyDelta (toolBuilder.befores {}) toolBuilder.afters
        in
        doConstructTweak toolBuilder.constructTweak toolBuilder.tweakConstructor tweakers
    }


doMakeTweakers tweakerMaker_ applyDelta_ befores afters =
    tweakerMaker_ (\_ {} {} -> {}) applyDelta_ befores afters


tweakerMaker next applyDelta_ ( before, restBefores ) ( after, restAfters ) =
    ( \mapper toolDef ->
        let
            delta =
                before ( Just mapper, after )
        in
        applyDelta_ (\{} {} -> {}) delta toolDef
    , next applyDelta_ restBefores restAfters
    )


applyDelta next ( delta, restDeltas ) ( toolDef, restToolDefs ) =
    ( case delta of
        Just mapper ->
            mapper toolDef

        Nothing ->
            toolDef
    , next restDeltas restToolDefs
    )


doConstructTweak constructTweak_ tweakConstructor tweakers =
    constructTweak_ (\tc {} -> tc) tweakConstructor tweakers


constructTweak next tweakConstructor ( tweaker, restTweakers ) =
    next (tweakConstructor tweaker) restTweakers


doMakeList : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeList listMaker_ listChildren_ lists_ =
    listMaker_ (\{} {} -> {}) listChildren_ lists_


listMaker : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
listMaker next ( listChild, restListChildren ) ( list_, restLists ) =
    ( list_ listChild
    , next restListChildren restLists
    )


doMakeMaybe : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeMaybe maybeMaker_ maybeContents_ maybes_ =
    maybeMaker_ (\{} {} -> {}) maybeContents_ maybes_


maybeMaker : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
maybeMaker next ( maybeContent, restMaybeContents ) ( maybe_, restMaybes ) =
    ( maybe_ maybeContent
    , next restMaybeContents restMaybes
    )


doMakeArray : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeArray maker_ contents_ containers_ =
    maker_ (\{} {} -> {}) contents_ containers_


arrayMaker : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
arrayMaker next ( content, restContents ) ( array_, restArrays ) =
    ( array_ content
    , next restContents restArrays
    )


doMakeDict : (({} -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeDict dictMaker_ keys_ values_ dicts_ =
    dictMaker_ (\{} {} {} -> {}) keys_ values_ dicts_


dictMaker : (b -> a -> c -> d) -> ( e, b ) -> ( f, a ) -> ( e -> f -> g, c ) -> ( g, d )
dictMaker next ( key_, restKeys ) ( value_, restValues ) ( dict_, restDicts ) =
    ( dict_ key_ value_
    , next restKeys restValues restDicts
    )


doMakeSet : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeSet setMaker_ contents_ sets =
    setMaker_ (\{} {} -> {}) contents_ sets


setMaker : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
setMaker next ( content, restContents ) ( set_, restSets ) =
    ( set_ content
    , next restContents restSets
    )


doMakeTuple : (({} -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeTuple tupleMaker_ a b tuples =
    tupleMaker_ (\{} {} {} -> {}) a b tuples


tupleMaker : (b -> a -> c -> d) -> ( e, b ) -> ( f, a ) -> ( e -> f -> g, c ) -> ( g, d )
tupleMaker next ( a, restAs ) ( b, restBs ) ( tuple_, restTuples ) =
    ( tuple_ a b
    , next restAs restBs restTuples
    )


doMakeTriple : (({} -> {} -> {} -> {} -> {}) -> e -> f -> g -> h -> i) -> e -> f -> g -> h -> i
doMakeTriple tripleMaker_ a b c triples =
    tripleMaker_ (\{} {} {} {} -> {}) a b c triples


tripleMaker : (b -> a -> c -> d -> e) -> ( f, b ) -> ( g, a ) -> ( h, c ) -> ( f -> g -> h -> i, d ) -> ( i, e )
tripleMaker next ( a, restAs ) ( b, restBs ) ( c, restCs ) ( triple, restTriples ) =
    ( triple a b c
    , next restAs restBs restCs restTriples
    )


doMakeResult : (({} -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeResult resultMaker_ errors values results =
    resultMaker_ (\{} {} {} -> {}) errors values results


resultMaker : (b -> a -> c -> d) -> ( e, b ) -> ( f, a ) -> ( e -> f -> g, c ) -> ( g, d )
resultMaker next ( error, restErrors ) ( value, restValues ) ( result, restResults ) =
    ( result error value
    , next restErrors restValues restResults
    )


doMakeRecord : ((a -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeRecord recordMaker_ recordConstructor records =
    recordMaker_ (\_ {} -> {}) recordConstructor records


recordMaker : (b -> a -> c) -> b -> ( b -> d, a ) -> ( d, c )
recordMaker next recordConstructor ( record_, records ) =
    ( record_ recordConstructor
    , next recordConstructor records
    )


doMakeFields : ((a -> b -> {} -> {} -> {} -> {}) -> f -> g -> h -> i -> j -> k) -> f -> g -> h -> i -> j -> k
doMakeFields fieldMaker_ fieldName getField child recordBuilders fields =
    fieldMaker_ (\_ _ {} {} {} -> {}) fieldName getField child recordBuilders fields


fieldMaker : (b -> c -> a -> d -> e -> f) -> b -> c -> ( g, a ) -> ( h, d ) -> ( b -> c -> g -> h -> i, e ) -> ( i, f )
fieldMaker next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )


doEndRecord : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doEndRecord recordEnder_ builder endRecords =
    recordEnder_ (\{} {} -> {}) builder endRecords


recordEnder : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
recordEnder next ( builder, restBuilders ) ( endRecord_, restEndRecords ) =
    ( endRecord_ builder
    , next restBuilders restEndRecords
    )


doMakeCustom : ((a -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeCustom customMaker_ customDestructors destructorFieldGetters customs =
    customMaker_ (\_ {} {} -> {}) customDestructors destructorFieldGetters customs


customMaker : (b -> a -> c -> d) -> b -> ( b -> e, a ) -> ( e -> f, c ) -> ( f, d )
customMaker next customDestructors ( destructorFieldGetter, restDestructorFieldGetters ) ( custom, restCustoms ) =
    ( custom (destructorFieldGetter customDestructors)
    , next customDestructors restDestructorFieldGetters restCustoms
    )


doMakeTag0 : ((a -> b -> {} -> {} -> {}) -> e -> f -> g -> h -> i) -> e -> f -> g -> h -> i
doMakeTag0 tag0Maker_ tagName tagConstructor customBuilder tag0s =
    tag0Maker_ (\_ _ {} {} -> {}) tagName tagConstructor customBuilder tag0s


tag0Maker : (b -> c -> a -> d -> e) -> b -> c -> ( f, a ) -> ( b -> c -> f -> g, d ) -> ( g, e )
tag0Maker next tagName tagConstructor ( customBuilder, restCustomBuilders ) ( tag0, restTag0s ) =
    ( tag0 tagName tagConstructor customBuilder
    , next tagName tagConstructor restCustomBuilders restTag0s
    )


doMakeTag1 : ((a -> b -> c -> {} -> {} -> {}) -> f -> g -> h -> i -> j -> k) -> f -> g -> h -> i -> j -> k
doMakeTag1 tag1Maker_ tagName tagConstructor child1 customBuilder tag1s =
    tag1Maker_ (\_ _ _ {} {} -> {}) tagName tagConstructor child1 customBuilder tag1s


tag1Maker : (b -> c -> a -> d -> e -> f) -> b -> c -> ( g, a ) -> ( h, d ) -> ( b -> c -> g -> h -> i, e ) -> ( i, f )
tag1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( tag1, restTag1s ) =
    ( tag1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doEndCustom : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doEndCustom customEnder_ customBuilder endCustoms =
    customEnder_ (\{} {} -> {}) customBuilder endCustoms


customEnder : (b -> a -> c) -> ( d, b ) -> ( d -> e, a ) -> ( e, c )
customEnder next ( customBuilder, restCustomBuilders ) ( endCustom, restEndCustoms ) =
    ( endCustom customBuilder
    , next restCustomBuilders restEndCustoms
    )


doConstructMultiTool : ((a -> {} -> a) -> c -> d -> e) -> c -> d -> e
doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output {} -> output) ctor builder


constructMultiTool : (a -> b -> c) -> (d -> a) -> ( d, b ) -> c
constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
