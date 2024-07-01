module MultiTool exposing
    ( define, Builder
    , add
    , end, ToolSpec
    )

{-| **Fun fact**: The type annotations for the functions in this package are pretty horrifying.

**Hot tip**: Ignore them! There's no need to put any of these functions, or the tools they produce, in your
application's `Msg` or `Model` type. So you don't need to know or care about what their type signatures are. Just read
the docs and look at the examples. It'll be fine.\*

\* Unless you make any kind of minor typo in your code, in which case the Elm compiler may respond with a Lovecraftian
error message 😱.

@docs define, Builder

@docs add

@docs end, ToolSpec

-}


{-| A data structure produced by `define`, used to create MultiTools
-}
type Builder a
    = Builder a


{-|


### `define`

Begin creating a new MultiTool.

This function takes two identical arguments. Both arguments should be a function that constructs a record with a field
for each of the tools you intend to include in your MultiTool.

For example, if you want to combine a `ToString` tool and a `ToComparable` tool, you could do something like this:

    import ToComparable
    import ToString

    type alias Tools toString toComparable =
        { toString : toString
        , toComparable : toComparable
        }

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add
                .toString
                ToString.interface
            |> MultiTool.add
                .toComparable
                ToComparable.interface
            |> MultiTool.end

**Note**: The order of the type parameters in the `Tools` type alias is important. It needs to match the order in which
you add the tool interfaces with `MultiTool.add`.

In this example, we see that `toString` comes first and `toComparable` comes second in _both_ the `Tools` type alias and
the interfaces added to `tools`.

-}
define :
    a
    -> b
    ->
        Builder
            { string : c -> c
            , int : d -> d
            , bool : e -> e
            , float : f -> f
            , char : g -> g
            , listMaker : h -> h
            , maybeMaker : i -> i
            , arrayMaker : j -> j
            , dictMaker : k -> k
            , setMaker : l -> l
            , tupleMaker : m -> m
            , tripleMaker : n -> n
            , resultMaker : o -> o
            , record : p -> p
            , recordMaker : q -> q
            , field : r -> r
            , fieldMaker : s -> s
            , endRecord : t -> t
            , recordEnder : u -> u
            , customType : v -> v
            , customMaker : w -> w
            , variant0 : x -> x
            , variant0Maker : y -> y
            , variant1 : z -> z
            , variant1Maker : a1 -> a1
            , variant2 : b1 -> b1
            , variant2Maker : c1 -> c1
            , variant3 : d1 -> d1
            , variant3Maker : e1 -> e1
            , variant4 : f1 -> f1
            , variant4Maker : g1 -> g1
            , variant5 : h1 -> h1
            , variant5Maker : i1 -> i1
            , endCustomType : j1 -> j1
            , customEnder : k1 -> k1
            , toolConstructor : a
            , destructorFieldGetter : l1 -> l1
            , constructMultiTool : m1 -> m1
            , before : n1 -> n1
            , befores : o1 -> o1
            , after : {}
            , afters : {}
            , tweakerMaker : p1 -> p1
            , constructTweak : q1 -> q1
            , applyDelta : r1 -> r1
            , tweakConstructor : b
            }
define toolConstructor tweakConstructor =
    Builder
        { -- primitives
          string = identity
        , int = identity
        , bool = identity
        , float = identity
        , char = identity

        -- built-in combinators
        , listMaker = identity
        , maybeMaker = identity
        , arrayMaker = identity
        , dictMaker = identity
        , setMaker = identity
        , tupleMaker = identity
        , tripleMaker = identity
        , resultMaker = identity

        -- record combinators
        , record = identity
        , recordMaker = identity
        , field = identity
        , fieldMaker = identity
        , endRecord = identity
        , recordEnder = identity

        -- custom type combinators
        , customType = identity
        , customMaker = identity
        , variant0 = identity
        , variant0Maker = identity
        , variant1 = identity
        , variant1Maker = identity
        , variant2 = identity
        , variant2Maker = identity
        , variant3 = identity
        , variant3Maker = identity
        , variant4 = identity
        , variant4Maker = identity
        , variant5 = identity
        , variant5Maker = identity
        , endCustomType = identity
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


{-|


### `add`

Add a tool to your MultiTool.

This function takes three arguments. The first is a field accessor, which should match one of the fields of the record
constructor you passed to `MultiTool.define`. For example: `.codec`.

The second is a tool interface - a record whose fields contain all the functions we will need to make the tool work.
Here's an example of an interface for the awesome `miniBill/elm-codec` package:

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
        , customType = Codec.custom
        , variant0 = Codec.variant0
        , variant1 = Codec.variant1
        , variant2 = Codec.variant2
        , variant3 = Codec.variant3
        , variant4 = Codec.variant4
        , variant5 = Codec.variant5
        , endCustomType = Codec.buildCustom
        }

(You'll notice that this interface type mostly looks straightforward, except for the `dict` field. The problem here
is that we need a `Dict` implementation that can take any `comparable` as a key, but `elm-codec`'s built-in `dict`
function only accepts `String`s as keys. Fortunately, we can build the function we need using `elm-codec`'s lower-level
primitives.)

The third and final argument is the `MultiTool.Builder` that you've already created using `define`. The API here is
designed for piping with the `|>` operator, so you'll usually want to apply this final argument like this:

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add .codec codecInterface

-}
add :
    a80
    ->
        { r
            | array : a62 -> b20
            , bool : a83
            , char : a82
            , customType : a81
            , dict : a46 -> b15 -> c28
            , endCustomType : a79
            , endRecord : a78
            , field : a77
            , float : a76
            , int : a75
            , list : a37 -> b13
            , maybe : a35 -> b12
            , record : a74
            , result : a28 -> b9 -> c16
            , set : a26 -> b8
            , string : a73
            , triple : a23 -> b7 -> c13 -> d7
            , tuple : a21 -> b6 -> c12
            , variant0 : a72
            , variant1 : a71
            , variant2 : a70
            , variant3 : a69
            , variant4 : a68
            , variant5 : a67
        }
    ->
        Builder
            { r1
                | after : s
                , afters : t
                , applyDelta : a65 -> b21 -> a64 -> c40
                , arrayMaker : a63 -> c39 -> d20
                , before : ( Maybe a84, a61 ) -> c38
                , befores : ( ( Maybe a84, a61 ) -> c38, a60 ) -> c37
                , bool : ( a83, a59 ) -> c36
                , char : ( a82, a58 ) -> c35
                , constructMultiTool : a57 -> a56 -> b19 -> c34
                , constructTweak : a55 -> a54 -> b18 -> c33
                , customEnder : a53 -> b17 -> a52 -> c32
                , customMaker : a51 -> b16 -> a50 -> c31 -> d16
                , customType : ( a81, a49 ) -> c30
                , destructorFieldGetter : ( a80, a48 ) -> c29
                , dictMaker : a47 -> d15 -> e11 -> f10
                , endCustomType : ( a79, a45 ) -> c27
                , endRecord : ( a78, a44 ) -> c26
                , field : ( a77, a43 ) -> c25
                , fieldMaker : a42 -> b14 -> c24 -> a41 -> d14 -> e10 -> f9
                , float : ( a76, a40 ) -> c23
                , int : ( a75, a39 ) -> c22
                , listMaker : a38 -> c21 -> d13
                , maybeMaker : a36 -> c20 -> d12
                , record : ( a74, a34 ) -> c19
                , recordEnder : a33 -> b11 -> a32 -> c18
                , recordMaker : a31 -> b10 -> a30 -> c17
                , resultMaker : a29 -> d9 -> e8 -> f8
                , setMaker : a27 -> c15 -> d8
                , string : ( a73, a25 ) -> c14
                , toolConstructor : u
                , tripleMaker : a24 -> e7 -> f7 -> g6 -> h5
                , tupleMaker : a22 -> d6 -> e6 -> f6
                , tweakConstructor : v
                , tweakerMaker :
                    a20
                    -> (({} -> {} -> {}) -> y -> toolSpec -> a18)
                    -> z
                    -> p1
                    -> q1
                , variant0 : ( a72, a17 ) -> c11
                , variant0Maker : a16 -> b5 -> c10 -> a15 -> d5 -> e5
                , variant1 : ( a71, a14 ) -> c9
                , variant1Maker : a13 -> b4 -> c8 -> a12 -> d4 -> e4 -> f4
                , variant2 : ( a70, a11 ) -> c7
                , variant2Maker : a10 -> b3 -> c6 -> a9 -> d3 -> e3 -> f3 -> g3
                , variant3 : ( a69, a8 ) -> c5
                , variant3Maker : a7 -> b2 -> c4 -> a6 -> d2 -> e2 -> f2 -> g2 -> h2
                , variant4 : ( a68, a5 ) -> c3
                , variant4Maker :
                    a4 -> b1 -> c2 -> a3 -> d1 -> e1 -> f1 -> g1 -> h1 -> i1
                , variant5 : ( a67, a2 ) -> c1
                , variant5Maker :
                    a1 -> b -> c -> a -> d -> e -> f -> g -> h -> i -> j
            }
    ->
        Builder
            { after : ( Maybe a66, s )
            , afters : ( s, t )
            , applyDelta :
                a65 -> ( Maybe (d21 -> d21), b21 ) -> ( d21, a64 ) -> ( d21, c40 )
            , arrayMaker : a63 -> ( a62, c39 ) -> ( b20, d20 )
            , before : a61 -> c38
            , befores : a60 -> c37
            , bool : a59 -> c36
            , char : a58 -> c35
            , constructMultiTool : a57 -> (d19 -> a56) -> ( d19, b19 ) -> c34
            , constructTweak : a55 -> (d18 -> a54) -> ( d18, b18 ) -> c33
            , customEnder :
                a53 -> ( d17, b17 ) -> ( d17 -> e13, a52 ) -> ( e13, c32 )
            , customMaker :
                a51
                -> b16
                -> ( b16 -> e12, a50 )
                -> ( e12 -> f11, c31 )
                -> ( f11, d16 )
            , customType : a49 -> c30
            , destructorFieldGetter : a48 -> c29
            , dictMaker : a47 -> ( a46, d15 ) -> ( b15, e11 ) -> ( c28, f10 )
            , endCustomType : a45 -> c27
            , endRecord : a44 -> c26
            , field : a43 -> c25
            , fieldMaker :
                a42
                -> b14
                -> c24
                -> ( g7, a41 )
                -> ( h6, d14 )
                -> ( b14 -> c24 -> g7 -> h6 -> i5, e10 )
                -> ( i5, f9 )
            , float : a40 -> c23
            , int : a39 -> c22
            , listMaker : a38 -> ( a37, c21 ) -> ( b13, d13 )
            , maybeMaker : a36 -> ( a35, c20 ) -> ( b12, d12 )
            , record : a34 -> c19
            , recordEnder : a33 -> ( d11, b11 ) -> ( d11 -> e9, a32 ) -> ( e9, c18 )
            , recordMaker : a31 -> b10 -> ( b10 -> d10, a30 ) -> ( d10, c17 )
            , resultMaker : a29 -> ( a28, d9 ) -> ( b9, e8 ) -> ( c16, f8 )
            , setMaker : a27 -> ( a26, c15 ) -> ( b8, d8 )
            , string : a25 -> c14
            , toolConstructor : u
            , tripleMaker :
                a24 -> ( a23, e7 ) -> ( b7, f7 ) -> ( c13, g6 ) -> ( d7, h5 )
            , tupleMaker : a22 -> ( a21, d6 ) -> ( b6, e6 ) -> ( c12, f6 )
            , tweakConstructor : v
            , tweakerMaker :
                a20
                -> (({} -> {} -> {}) -> y -> toolSpec -> a18)
                -> ( ( Maybe a19, s1 ) -> y, z )
                -> ( s1, p1 )
                -> ( a19 -> ToolSpec toolSpec -> ToolSpec a18, q1 )
            , variant0 : a17 -> c11
            , variant0Maker :
                a16
                -> b5
                -> c10
                -> ( f5, a15 )
                -> ( b5 -> c10 -> f5 -> g5, d5 )
                -> ( g5, e5 )
            , variant1 : a14 -> c9
            , variant1Maker :
                a13
                -> b4
                -> c8
                -> ( g4, a12 )
                -> ( h4, d4 )
                -> ( b4 -> c8 -> g4 -> h4 -> i4, e4 )
                -> ( i4, f4 )
            , variant2 : a11 -> c7
            , variant2Maker :
                a10
                -> b3
                -> c6
                -> ( h3, a9 )
                -> ( i3, d3 )
                -> ( j3, e3 )
                -> ( b3 -> c6 -> h3 -> i3 -> j3 -> k3, f3 )
                -> ( k3, g3 )
            , variant3 : a8 -> c5
            , variant3Maker :
                a7
                -> b2
                -> c4
                -> ( i2, a6 )
                -> ( j2, d2 )
                -> ( k2, e2 )
                -> ( l2, f2 )
                -> ( b2 -> c4 -> i2 -> j2 -> k2 -> l2 -> m2, g2 )
                -> ( m2, h2 )
            , variant4 : a5 -> c3
            , variant4Maker :
                a4
                -> b1
                -> c2
                -> ( j1, a3 )
                -> ( k1, d1 )
                -> ( l1, e1 )
                -> ( m1, f1 )
                -> ( n1, g1 )
                -> ( b1 -> c2 -> j1 -> k1 -> l1 -> m1 -> n1 -> o1, h1 )
                -> ( o1, i1 )
            , variant5 : a2 -> c1
            , variant5Maker :
                a1
                -> b
                -> c
                -> ( k, a )
                -> ( l, d )
                -> ( m, e )
                -> ( n, f )
                -> ( o, g )
                -> ( p, h )
                -> ( b -> c -> k -> l -> m -> n -> o -> p -> q, i )
                -> ( q, j )
            }
add destructorFieldGetter tool (Builder builder) =
    Builder
        { -- primitives
          string = builder.string << Tuple.pair tool.string
        , int = builder.int << Tuple.pair tool.int
        , bool = builder.bool << Tuple.pair tool.bool
        , float = builder.float << Tuple.pair tool.float
        , char = builder.char << Tuple.pair tool.char

        -- built-in combinators
        , listMaker = builder.listMaker >> listMaker tool.list
        , maybeMaker = builder.maybeMaker >> maybeMaker tool.maybe
        , arrayMaker = builder.arrayMaker >> arrayMaker tool.array
        , dictMaker = builder.dictMaker >> dictMaker tool.dict
        , setMaker = builder.setMaker >> setMaker tool.set
        , tupleMaker = builder.tupleMaker >> tupleMaker tool.tuple
        , tripleMaker = builder.tripleMaker >> tripleMaker tool.triple
        , resultMaker = builder.resultMaker >> resultMaker tool.result

        -- record combinators
        , record = builder.record << Tuple.pair tool.record
        , recordMaker = builder.recordMaker >> recordMaker
        , field = builder.field << Tuple.pair tool.field
        , fieldMaker = builder.fieldMaker >> fieldMaker
        , endRecord = builder.endRecord << Tuple.pair tool.endRecord
        , recordEnder = builder.recordEnder >> recordEnder

        -- custom type combinators
        , customType = builder.customType << Tuple.pair tool.customType
        , customMaker = builder.customMaker >> customMaker
        , variant0 = builder.variant0 << Tuple.pair tool.variant0
        , variant0Maker = builder.variant0Maker >> variant0Maker
        , variant1 = builder.variant1 << Tuple.pair tool.variant1
        , variant1Maker = builder.variant1Maker >> variant1Maker
        , variant2 = builder.variant2 << Tuple.pair tool.variant2
        , variant2Maker = builder.variant2Maker >> variant2Maker
        , variant3 = builder.variant3 << Tuple.pair tool.variant3
        , variant3Maker = builder.variant3Maker >> variant3Maker
        , variant4 = builder.variant4 << Tuple.pair tool.variant4
        , variant4Maker = builder.variant4Maker >> variant4Maker
        , variant5 = builder.variant5 << Tuple.pair tool.variant5
        , variant5Maker = builder.variant5Maker >> variant5Maker
        , endCustomType = builder.endCustomType << Tuple.pair tool.endCustomType
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


{-|


### `end`

Complete the definition of a MultiTool.

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add
                .toString
                ToString.interface
            |> MultiTool.add
                .toComparable
                ToComparable.interface
            |> MultiTool.end

This function converts a `MultiTool.Builder` into a record that contains all the functions you'll need to create tool
specifications (`ToolSpec`s) for the types in your application. If you define a MultiTool like `tools` in the example
above, it'll give you access to the following `ToolSpecs` and helper functions:


## `ToolSpec`s for primitive types

We've got `tools.bool`, `tools.string`, `tools.int`, `tools.float`, and `tools.char`.

For example:

    boolTool =
        tools.build tools.bool

    trueFact =
        boolTool.toString True == "True"


## `ToolSpec`s for common combinators

We've got `tools.maybe`, `tools.result`, `tools.list`, `tools.array`, `tools.dict`, `tools.set`, `tools.tuple`, _and_
`tools.triple`.

For example:

    listBoolSpec =
        tools.list tools.bool

    tupleIntStringSpec =
        tools.tuple tools.int tools.string


## `ToolSpec`s for combinators for custom types

To define `ToolSpec`s for your own custom types, use `tools.customType`, `tools.variant0`, `tools.variant1`, `tools.variant2`,
`tools.variant3`, `tools.variant4`, `tools.variant5`, and `tools.endCustomType`.

For example, if we really hated Elm's `Maybe` type and wanted it to be called `Option` instead:

    type Option value
        = Some value
        | None

    optionSpec valueSpec =
        let
            match some none tag =
                case tag of
                    Some value ->
                        some value

                    None ->
                        none
        in
        tools.customType
            { toString = match, toComparable = match }
            |> tools.variant1 "Some" Some valueSpec
            |> tools.variant0 "None" None
            |> tools.endCustomType

**Note**: You _must_ define the `match` function either in a `let-in` block within your tool specification, or as a
top-level function in one of your modules. If you try and parameterise your tool specification to take a `match`
function as one of its arguments, it won't work - you'll get a compiler error.

The explanation for this is a bit beyond me, but I think it goes: "something something `forall`, something something
let-polymorphism."


## `ToolSpec`s for combinators for records

For records (and indeed any kind of "product" type), check out `tools.record`, `tools.field`, and `tools.endRecord`.

For example:

    type alias User =
        { name : String, age : Int }

    userToolSpec =
        tools.record User
            |> tools.field "name" .name tools.string
            |> tools.field "age" .age tools.int
            |> tools.endRecord


## Converting a `ToolSpec` into a usable tool

`tools.build` turns a `ToolSpec` into a usable tool.

For example:

    userTool =
        tools.build userToolSpec

    user =
        { name = "Ed", age = 41 }

    trueFact =
        userTool.toString user
            == "{ name = \"Ed\", age = 41 }"


## Customising a `ToolSpec`

`tools.tweak` allows you to alter (or replace) the tools contained within a `ToolSpec`.

For example, if you're using `edkelly303/elm-any-type-forms`, you could customise the `tools.string` and `tools.int`
`ToolSpec`s like this:

    import Control

    myIntSpec =
        tools.int
            |> tools.tweak.control
                (Control.failIf
                    (\int -> int < 0)
                    "Must be greater than or equal to 0"
                )

    myStringSpec =
        tools.string
            |> tools.tweak.control
                (\_ ->
                    -- throw away whatever control we
                    -- had in tools.string, and use
                    -- this instead:
                    Control.string
                        |> Control.debounce 1000
                )

-}
end :
    Builder
        { t
            | afters : f4
            , applyDelta : d7
            , arrayMaker : ({} -> {}) -> b3 -> a9
            , befores : {} -> e5
            , bool : {} -> toolSpec4
            , char : {} -> toolSpec3
            , constructMultiTool : (a21 -> {} -> a21) -> c7 -> d5 -> e4
            , constructTweak : (a20 -> {} -> a20) -> c6 -> d6 -> e1
            , customEnder : ({} -> {} -> {}) -> c4 -> d10 -> a7
            , customMaker : (a19 -> {} -> {} -> {}) -> d4 -> e6 -> f5 -> g4
            , customType : {} -> f5
            , destructorFieldGetter : {} -> e6
            , dictMaker : ({} -> {} -> {}) -> c5 -> d3 -> a8
            , endCustomType : {} -> d10
            , endRecord : {} -> d9
            , field : {} -> j5
            , fieldMaker :
                (a18 -> b10 -> {} -> {} -> {} -> {})
                -> f3
                -> g3
                -> h3
                -> i5
                -> j5
                -> k5
            , float : {} -> toolSpec2
            , int : {} -> toolSpec1
            , listMaker : ({} -> {}) -> b2 -> a5
            , maybeMaker : ({} -> {}) -> b1 -> a4
            , record : {} -> d8
            , recordEnder : ({} -> {} -> {}) -> c3 -> d9 -> a6
            , recordMaker : (a17 -> {} -> {}) -> c2 -> d8 -> e3
            , resultMaker : ({} -> {} -> {}) -> c1 -> d2 -> a3
            , setMaker : ({} -> {}) -> b -> a2
            , string : {} -> toolSpec
            , toolConstructor : c7
            , tripleMaker : ({} -> {} -> {} -> {}) -> d1 -> e2 -> f2 -> a1
            , tupleMaker : ({} -> {} -> {}) -> c -> d -> a
            , tweakConstructor : c6
            , tweakerMaker : (a16 -> {} -> {} -> {}) -> d7 -> e5 -> f4 -> d6
            , variant0 : {} -> h4
            , variant0Maker :
                (a15 -> b9 -> {} -> {} -> {}) -> e -> f1 -> g2 -> h4 -> i4
            , variant1 : {} -> j4
            , variant1Maker :
                (a14 -> b8 -> {} -> {} -> {} -> {})
                -> f
                -> g1
                -> h2
                -> i3
                -> j4
                -> k4
            , variant2 : {} -> l3
            , variant2Maker :
                (a13 -> b7 -> {} -> {} -> {} -> {} -> {})
                -> g
                -> h1
                -> i2
                -> j3
                -> k3
                -> l3
                -> m3
            , variant3 : {} -> n2
            , variant3Maker :
                (a12 -> b6 -> {} -> {} -> {} -> {} -> {} -> {})
                -> h
                -> i1
                -> j2
                -> k2
                -> l2
                -> m2
                -> n2
                -> o2
            , variant4 : {} -> p1
            , variant4Maker :
                (a11 -> b5 -> {} -> {} -> {} -> {} -> {} -> {} -> {})
                -> i
                -> j1
                -> k1
                -> l1
                -> m1
                -> n1
                -> o1
                -> p1
                -> q1
            , variant5 : {} -> r
            , variant5Maker :
                (a10 -> b4 -> {} -> {} -> {} -> {} -> {} -> {} -> {} -> {})
                -> j
                -> k
                -> l
                -> m
                -> n
                -> o
                -> p
                -> q
                -> r
                -> s
        }
    ->
        { array : ToolSpec b3 -> ToolSpec a9
        , bool : ToolSpec toolSpec4
        , build : ToolSpec d5 -> e4
        , char : ToolSpec toolSpec3
        , customType : d4 -> g4
        , dict : ToolSpec c5 -> ToolSpec d3 -> ToolSpec a8
        , endCustomType : c4 -> ToolSpec a7
        , endRecord : c3 -> ToolSpec a6
        , field : f3 -> g3 -> ToolSpec h3 -> i5 -> k5
        , float : ToolSpec toolSpec2
        , int : ToolSpec toolSpec1
        , list : ToolSpec b2 -> ToolSpec a5
        , maybe : ToolSpec b1 -> ToolSpec a4
        , record : c2 -> e3
        , result : ToolSpec c1 -> ToolSpec d2 -> ToolSpec a3
        , set : ToolSpec b -> ToolSpec a2
        , string : ToolSpec toolSpec
        , triple : ToolSpec d1 -> ToolSpec e2 -> ToolSpec f2 -> ToolSpec a1
        , tuple : ToolSpec c -> ToolSpec d -> ToolSpec a
        , tweak : e1
        , variant0 : e -> f1 -> g2 -> i4
        , variant1 : f -> g1 -> ToolSpec h2 -> i3 -> k4
        , variant2 : g -> h1 -> ToolSpec i2 -> ToolSpec j3 -> k3 -> m3
        , variant3 :
            h -> i1 -> ToolSpec j2 -> ToolSpec k2 -> ToolSpec l2 -> m2 -> o2
        , variant4 :
            i
            -> j1
            -> ToolSpec k1
            -> ToolSpec l1
            -> ToolSpec m1
            -> ToolSpec n1
            -> o1
            -> q1
        , variant5 :
            j
            -> k
            -> ToolSpec l
            -> ToolSpec m
            -> ToolSpec n
            -> ToolSpec o
            -> ToolSpec p
            -> q
            -> s
        }
end (Builder toolBuilder) =
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

        -- record combinators
        records =
            toolBuilder.record {}

        fields =
            toolBuilder.field {}

        endRecords =
            toolBuilder.endRecord {}

        -- custom type combinators
        customs =
            toolBuilder.customType {}

        variant0s =
            toolBuilder.variant0 {}

        variant1s =
            toolBuilder.variant1 {}

        variant2s =
            toolBuilder.variant2 {}

        variant3s =
            toolBuilder.variant3 {}

        variant4s =
            toolBuilder.variant4 {}

        variant5s =
            toolBuilder.variant5 {}

        endCustoms =
            toolBuilder.endCustomType {}

        destructorFieldGetters =
            toolBuilder.destructorFieldGetter {}
    in
    { -- primitive types
      string = ToolSpec strings
    , int = ToolSpec ints
    , bool = ToolSpec bools
    , float = ToolSpec floats
    , char = ToolSpec chars

    -- built-in combinators
    , list =
        \(ToolSpec itemSpec) ->
            doMakeList toolBuilder.listMaker itemSpec
                |> ToolSpec
    , maybe =
        \(ToolSpec contentSpec) ->
            doMakeMaybe toolBuilder.maybeMaker contentSpec
                |> ToolSpec
    , array =
        \(ToolSpec itemSpec) ->
            doMakeArray toolBuilder.arrayMaker itemSpec
                |> ToolSpec
    , dict =
        \(ToolSpec keySpec) (ToolSpec valueSpec) ->
            doMakeDict toolBuilder.dictMaker keySpec valueSpec
                |> ToolSpec
    , set =
        \(ToolSpec memberSpec) ->
            doMakeSet toolBuilder.setMaker memberSpec
                |> ToolSpec
    , tuple =
        \(ToolSpec firstSpec) (ToolSpec secondSpec) ->
            doMakeTuple toolBuilder.tupleMaker firstSpec secondSpec
                |> ToolSpec
    , triple =
        \(ToolSpec firstSpec) (ToolSpec secondSpec) (ToolSpec thirdSpec) ->
            doMakeTriple toolBuilder.tripleMaker firstSpec secondSpec thirdSpec
                |> ToolSpec
    , result =
        \(ToolSpec errorSpec) (ToolSpec valueSpec) ->
            doMakeResult toolBuilder.resultMaker errorSpec valueSpec
                |> ToolSpec

    -- records
    , record =
        \recordConstructor ->
            doMakeRecord toolBuilder.recordMaker recordConstructor records
    , field =
        \fieldName getField (ToolSpec fieldSpec) recordBuilder ->
            doMakeFields toolBuilder.fieldMaker fieldName getField fieldSpec recordBuilder fields
    , endRecord =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder endRecords
                |> ToolSpec

    -- custom types
    , customType =
        \customDestructors ->
            doMakeCustom toolBuilder.customMaker customDestructors destructorFieldGetters customs
    , variant0 =
        \tagName tagConstructor customBuilder ->
            doMakeTag0 toolBuilder.variant0Maker tagName tagConstructor customBuilder variant0s
    , variant1 =
        \tagName tagConstructor (ToolSpec arg1Spec) customBuilder ->
            doMakeTag1 toolBuilder.variant1Maker tagName tagConstructor arg1Spec customBuilder variant1s
    , variant2 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) customBuilder ->
            doMakeTag2 toolBuilder.variant2Maker tagName tagConstructor arg1Spec arg2Spec customBuilder variant2s
    , variant3 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) customBuilder ->
            doMakeTag3 toolBuilder.variant3Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder variant3s
    , variant4 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) customBuilder ->
            doMakeTag4 toolBuilder.variant4Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder variant4s
    , variant5 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) (ToolSpec arg5Spec) customBuilder ->
            doMakeTag5 toolBuilder.variant5Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder variant5s
    , endCustomType =
        \customBuilder ->
            doEndCustom toolBuilder.customEnder customBuilder endCustoms
                |> ToolSpec

    -- turn a spec into a usable multiTool
    , build =
        \(ToolSpec toolSpec) ->
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.toolConstructor toolSpec
    , tweak =
        let
            tweakers =
                doMakeTweakers toolBuilder.tweakerMaker toolBuilder.applyDelta (toolBuilder.befores {}) toolBuilder.afters
        in
        doConstructTweak toolBuilder.constructTweak toolBuilder.tweakConstructor tweakers
    }


{-| A tool specification - the basic building block for creating tools for the types in your application.
-}
type ToolSpec toolSpec
    = ToolSpec toolSpec


doMakeTweakers : ((a -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeTweakers tweakerMaker_ applyDelta_ befores afters =
    tweakerMaker_ (\_ {} {} -> {}) applyDelta_ befores afters


tweakerMaker next applyDelta_ ( before, restBefores ) ( after, restAfters ) =
    ( \mapper (ToolSpec toolSpec) ->
        let
            delta =
                before ( Just mapper, after )
        in
        applyDelta_ (\{} {} -> {}) delta toolSpec
            |> ToolSpec
    , next applyDelta_ restBefores restAfters
    )


applyDelta : (b -> a -> c) -> ( Maybe (d -> d), b ) -> ( d, a ) -> ( d, c )
applyDelta next ( delta, restDeltas ) ( toolSpec, restToolSpecs ) =
    ( case delta of
        Just mapper ->
            mapper toolSpec

        Nothing ->
            toolSpec
    , next restDeltas restToolSpecs
    )


doConstructTweak : ((a -> {} -> a) -> c -> d -> e) -> c -> d -> e
doConstructTweak constructTweak_ tweakConstructor tweakers =
    constructTweak_ (\tc {} -> tc) tweakConstructor tweakers


constructTweak : (a -> b -> c) -> (d -> a) -> ( d, b ) -> c
constructTweak next tweakConstructor ( tweaker, restTweakers ) =
    next (tweakConstructor tweaker) restTweakers


doMakeList : (({} -> {}) -> b -> c) -> b -> c
doMakeList listMaker_ listChildren_ =
    listMaker_ (\{} -> {}) listChildren_


listMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
listMaker list_ next ( listChild, restListChildren ) =
    ( list_ listChild
    , next restListChildren
    )


doMakeMaybe : (({} -> {}) -> b -> c) -> b -> c
doMakeMaybe maybeMaker_ maybeContents_ =
    maybeMaker_ (\{} -> {}) maybeContents_


maybeMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
maybeMaker maybe_ next ( maybeContent, restMaybeContents ) =
    ( maybe_ maybeContent
    , next restMaybeContents
    )


doMakeArray : (({} -> {}) -> b -> c) -> b -> c
doMakeArray maker_ contents_ =
    maker_ (\{} -> {}) contents_


arrayMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
arrayMaker array_ next ( content, restContents ) =
    ( array_ content
    , next restContents
    )


doMakeDict : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeDict dictMaker_ keys_ values_ =
    dictMaker_ (\{} {} -> {}) keys_ values_


dictMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
dictMaker dict_ next ( key_, restKeys ) ( value_, restValues ) =
    ( dict_ key_ value_
    , next restKeys restValues
    )


doMakeSet : (({} -> {}) -> b -> c) -> b -> c
doMakeSet setMaker_ contents_ =
    setMaker_ (\{} -> {}) contents_


setMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
setMaker set_ next ( content, restContents ) =
    ( set_ content
    , next restContents
    )


doMakeTuple : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeTuple tupleMaker_ a b =
    tupleMaker_ (\{} {} -> {}) a b


tupleMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
tupleMaker tuple_ next ( a, restAs ) ( b, restBs ) =
    ( tuple_ a b
    , next restAs restBs
    )


doMakeTriple : (({} -> {} -> {} -> {}) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeTriple tripleMaker_ a b c =
    tripleMaker_ (\{} {} {} -> {}) a b c


tripleMaker : (a -> b -> c -> d) -> (e -> f -> g -> h) -> ( a, e ) -> ( b, f ) -> ( c, g ) -> ( d, h )
tripleMaker triple_ next ( a, restAs ) ( b, restBs ) ( c, restCs ) =
    ( triple_ a b c
    , next restAs restBs restCs
    )


doMakeResult : (({} -> {} -> {}) -> c -> d -> e) -> c -> d -> e
doMakeResult resultMaker_ errors values =
    resultMaker_ (\{} {} -> {}) errors values


resultMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
resultMaker result_ next ( error, restErrors ) ( value, restValues ) =
    ( result_ error value
    , next restErrors restValues
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
doMakeTag0 variant0Maker_ tagName tagConstructor customBuilder variant0s =
    variant0Maker_ (\_ _ {} {} -> {}) tagName tagConstructor customBuilder variant0s


variant0Maker : (b -> c -> a -> d -> e) -> b -> c -> ( f, a ) -> ( b -> c -> f -> g, d ) -> ( g, e )
variant0Maker next tagName tagConstructor ( customBuilder, restCustomBuilders ) ( variant0, restTag0s ) =
    ( variant0 tagName tagConstructor customBuilder
    , next tagName tagConstructor restCustomBuilders restTag0s
    )


doMakeTag1 : ((a -> b -> {} -> {} -> {} -> {}) -> f -> g -> h -> i -> j -> k) -> f -> g -> h -> i -> j -> k
doMakeTag1 variant1Maker_ tagName tagConstructor child1 customBuilder variant1s =
    variant1Maker_ (\_ _ {} {} {} -> {}) tagName tagConstructor child1 customBuilder variant1s


variant1Maker : (b -> c -> a -> d -> e -> f) -> b -> c -> ( g, a ) -> ( h, d ) -> ( b -> c -> g -> h -> i, e ) -> ( i, f )
variant1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( variant1, restTag1s ) =
    ( variant1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doMakeTag2 : ((a -> b -> {} -> {} -> {} -> {} -> {}) -> g -> h -> i -> j -> k -> l -> m) -> g -> h -> i -> j -> k -> l -> m
doMakeTag2 variant2Maker_ tagName tagConstructor arg1Spec arg2Spec customBuilder variant2s =
    variant2Maker_ (\_ _ {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec customBuilder variant2s


variant2Maker : (b -> c -> a -> d -> e -> f -> g) -> b -> c -> ( h, a ) -> ( i, d ) -> ( j, e ) -> ( b -> c -> h -> i -> j -> k, f ) -> ( k, g )
variant2Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( customBuilder, restCustomBuilders ) ( variant2, restTag2s ) =
    ( variant2 tagName tagConstructor arg1Spec arg2Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restCustomBuilders restTag2s
    )


doMakeTag3 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {}) -> h -> i -> j -> k -> l -> m -> n -> o) -> h -> i -> j -> k -> l -> m -> n -> o
doMakeTag3 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder tags


variant3Maker : (b -> c -> a -> d -> e -> f -> g -> h) -> b -> c -> ( i, a ) -> ( j, d ) -> ( k, e ) -> ( l, f ) -> ( b -> c -> i -> j -> k -> l -> m, g ) -> ( m, h )
variant3Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restCustomBuilders restTags
    )


doMakeTag4 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {} -> {}) -> i -> j -> k -> l -> m -> n -> o -> p -> q) -> i -> j -> k -> l -> m -> n -> o -> p -> q
doMakeTag4 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder tags


variant4Maker : (b -> c -> a -> d -> e -> f -> g -> h -> i) -> b -> c -> ( j, a ) -> ( k, d ) -> ( l, e ) -> ( m, f ) -> ( n, g ) -> ( b -> c -> j -> k -> l -> m -> n -> o, h ) -> ( o, i )
variant4Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restC4s restCustomBuilders restTags
    )


doMakeTag5 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {} -> {} -> {}) -> j -> k -> l -> m -> n -> o -> p -> q -> r -> s) -> j -> k -> l -> m -> n -> o -> p -> q -> r -> s
doMakeTag5 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder tags


variant5Maker : (b -> c -> a -> d -> e -> f -> g -> h -> i -> j) -> b -> c -> ( k, a ) -> ( l, d ) -> ( m, e ) -> ( n, f ) -> ( o, g ) -> ( p, h ) -> ( b -> c -> k -> l -> m -> n -> o -> p -> q, i ) -> ( q, j )
variant5Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( arg5Spec, restC5s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restC4s restC5s restCustomBuilders restTags
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
