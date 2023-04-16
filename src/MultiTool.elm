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

@docs start, Builder

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
    b
    -> c
    ->
        Builder
            { after : {}
            , afters : {}
            , applyDelta : a49 -> a49
            , array : a48 -> a48
            , arrayMaker : a47 -> a47
            , before : a46 -> a46
            , befores : a45 -> a45
            , bool : a44 -> a44
            , char : a43 -> a43
            , constructMultiTool : a42 -> a42
            , constructTweak : a41 -> a41
            , custom : a40 -> a40
            , customEnder : a39 -> a39
            , customMaker : a38 -> a38
            , destructorFieldGetter : a37 -> a37
            , dict : a36 -> a36
            , dictMaker : a35 -> a35
            , endCustom : a34 -> a34
            , endRecord : a33 -> a33
            , field : a32 -> a32
            , fieldMaker : a31 -> a31
            , float : a30 -> a30
            , int : a29 -> a29
            , list : a28 -> a28
            , listMaker : a27 -> a27
            , maybe : a26 -> a26
            , maybeMaker : a25 -> a25
            , record : a24 -> a24
            , recordEnder : a23 -> a23
            , recordMaker : a22 -> a22
            , result : a21 -> a21
            , resultMaker : a20 -> a20
            , set : a19 -> a19
            , setMaker : a18 -> a18
            , string : a17 -> a17
            , tag0 : a16 -> a16
            , tag0Maker : a15 -> a15
            , tag1 : a14 -> a14
            , tag1Maker : a13 -> a13
            , tag2 : a12 -> a12
            , tag2Maker : a11 -> a11
            , tag3 : a10 -> a10
            , tag3Maker : a9 -> a9
            , tag4 : a8 -> a8
            , tag4Maker : a7 -> a7
            , tag5 : a6 -> a6
            , tag5Maker : a5 -> a5
            , toolConstructor : b
            , triple : a4 -> a4
            , tripleMaker : a3 -> a3
            , tuple : a2 -> a2
            , tupleMaker : a1 -> a1
            , tweakConstructor : c
            , tweakerMaker : a -> a
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
        , tag2 = identity
        , tag2Maker = identity
        , tag3 = identity
        , tag3Maker = identity
        , tag4 = identity
        , tag4Maker = identity
        , tag5 = identity
        , tag5Maker = identity
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
        , custom = Codec.custom
        , tag0 = Codec.variant0
        , tag1 = Codec.variant1
        , tag2 = Codec.variant2
        , tag3 = Codec.variant3
        , tag4 = Codec.variant4
        , tag5 = Codec.variant5
        , endCustom = Codec.buildCustom
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
    a95
    ->
        { r
            | array : a100
            , bool : a98
            , char : a97
            , custom : a96
            , dict : a94
            , endCustom : a93
            , endRecord : a92
            , field : a91
            , float : a90
            , int : a89
            , list : a88
            , maybe : a87
            , record : a86
            , result : a85
            , set : a84
            , string : a83
            , tag0 : a82
            , tag1 : a81
            , tag2 : a80
            , tag3 : a79
            , tag4 : a78
            , tag5 : a77
            , triple : a76
            , tuple : a75
        }
    ->
        Builder
            { u1
                | after : s
                , afters : t
                , applyDelta : a73 -> b20 -> a72 -> c47
                , array : ( a100, a71 ) -> c46
                , arrayMaker : a70 -> b19 -> a69 -> c45
                , before : ( Maybe a99, a68 ) -> c44
                , befores : ( ( Maybe a99, a68 ) -> c44, a67 ) -> c43
                , bool : ( a98, a66 ) -> c42
                , char : ( a97, a65 ) -> c41
                , constructMultiTool : a64 -> a63 -> b18 -> c40
                , constructTweak : a62 -> u -> v -> w
                , custom : ( a96, a61 ) -> c39
                , customEnder : a60 -> b17 -> a59 -> c38
                , customMaker : a58 -> b16 -> a57 -> c37 -> d16
                , destructorFieldGetter : ( a95, a56 ) -> c36
                , dict : ( a94, a55 ) -> c35
                , dictMaker : a54 -> b15 -> a53 -> c34 -> d15
                , endCustom : ( a93, a52 ) -> c33
                , endRecord : ( a92, a51 ) -> c32
                , field : ( a91, a50 ) -> c31
                , fieldMaker : a49 -> b14 -> c30 -> a48 -> d14 -> e13 -> f9
                , float : ( a90, a47 ) -> c29
                , int : ( a89, a46 ) -> c28
                , list : ( a88, a45 ) -> c27
                , listMaker : a44 -> b13 -> a43 -> c26
                , maybe : ( a87, a42 ) -> c25
                , maybeMaker : a41 -> b12 -> a40 -> c24
                , record : ( a86, a39 ) -> c23
                , recordEnder : a38 -> b11 -> a37 -> c22
                , recordMaker : a36 -> b10 -> a35 -> c21
                , result : ( a85, a34 ) -> c20
                , resultMaker : a33 -> b9 -> a32 -> c19 -> d9
                , set : ( a84, a31 ) -> c18
                , setMaker : a30 -> b8 -> a29 -> c17
                , string : ( a83, a28 ) -> c16
                , tag0 : ( a82, a27 ) -> c15
                , tag0Maker : a26 -> b7 -> c14 -> a25 -> d7 -> e7
                , tag1 : ( a81, a24 ) -> c13
                , tag1Maker : a23 -> b6 -> c12 -> a22 -> d6 -> e6 -> f6
                , tag2 : ( a80, a21 ) -> c11
                , tag2Maker : a20 -> b5 -> c10 -> a19 -> d5 -> e5 -> f5 -> g5
                , tag3 : ( a79, a18 ) -> c9
                , tag3Maker : a17 -> b4 -> c8 -> a16 -> d4 -> e4 -> f4 -> g4 -> h3
                , tag4 : ( a78, a15 ) -> c7
                , tag4Maker :
                    a14 -> b3 -> c6 -> a13 -> d3 -> e3 -> f3 -> g3 -> h2 -> i2
                , tag5 : ( a77, a12 ) -> c5
                , tag5Maker :
                    a11 -> b2 -> c4 -> a10 -> d2 -> e2 -> f2 -> g2 -> h1 -> i1 -> j
                , toolConstructor : x
                , triple : ( a76, a9 ) -> c3
                , tripleMaker : a8 -> b1 -> a7 -> c2 -> d1 -> e1
                , tuple : ( a75, a6 ) -> c1
                , tupleMaker : a5 -> b -> a4 -> c -> d
                , tweakConstructor : y
                , tweakerMaker :
                    a3
                    -> (({} -> {} -> {}) -> q1 -> a1 -> a)
                    -> r1
                    -> s1
                    -> t1
            }
    ->
        Builder
            { after : ( Maybe a74, s )
            , afters : ( s, t )
            , applyDelta :
                a73 -> ( Maybe (d20 -> d20), b20 ) -> ( d20, a72 ) -> ( d20, c47 )
            , array : a71 -> c46
            , arrayMaker : a70 -> ( d19, b19 ) -> ( d19 -> e17, a69 ) -> ( e17, c45 )
            , before : a68 -> c44
            , befores : a67 -> c43
            , bool : a66 -> c42
            , char : a65 -> c41
            , constructMultiTool : a64 -> (d18 -> a63) -> ( d18, b18 ) -> c40
            , constructTweak : a62 -> (v1 -> u) -> ( v1, v ) -> w
            , custom : a61 -> c39
            , customEnder :
                a60 -> ( d17, b17 ) -> ( d17 -> e16, a59 ) -> ( e16, c38 )
            , customMaker :
                a58
                -> b16
                -> ( b16 -> e15, a57 )
                -> ( e15 -> f11, c37 )
                -> ( f11, d16 )
            , destructorFieldGetter : a56 -> c36
            , dict : a55 -> c35
            , dictMaker :
                a54
                -> ( e14, b15 )
                -> ( f10, a53 )
                -> ( e14 -> f10 -> g10, c34 )
                -> ( g10, d15 )
            , endCustom : a52 -> c33
            , endRecord : a51 -> c32
            , field : a50 -> c31
            , fieldMaker :
                a49
                -> b14
                -> c30
                -> ( g9, a48 )
                -> ( h6, d14 )
                -> ( b14 -> c30 -> g9 -> h6 -> i6, e13 )
                -> ( i6, f9 )
            , float : a47 -> c29
            , int : a46 -> c28
            , list : a45 -> c27
            , listMaker : a44 -> ( d13, b13 ) -> ( d13 -> e12, a43 ) -> ( e12, c26 )
            , maybe : a42 -> c25
            , maybeMaker : a41 -> ( d12, b12 ) -> ( d12 -> e11, a40 ) -> ( e11, c24 )
            , record : a39 -> c23
            , recordEnder :
                a38 -> ( d11, b11 ) -> ( d11 -> e10, a37 ) -> ( e10, c22 )
            , recordMaker : a36 -> b10 -> ( b10 -> d10, a35 ) -> ( d10, c21 )
            , result : a34 -> c20
            , resultMaker :
                a33
                -> ( e9, b9 )
                -> ( f8, a32 )
                -> ( e9 -> f8 -> g8, c19 )
                -> ( g8, d9 )
            , set : a31 -> c18
            , setMaker : a30 -> ( d8, b8 ) -> ( d8 -> e8, a29 ) -> ( e8, c17 )
            , string : a28 -> c16
            , tag0 : a27 -> c15
            , tag0Maker :
                a26
                -> b7
                -> c14
                -> ( f7, a25 )
                -> ( b7 -> c14 -> f7 -> g7, d7 )
                -> ( g7, e7 )
            , tag1 : a24 -> c13
            , tag1Maker :
                a23
                -> b6
                -> c12
                -> ( g6, a22 )
                -> ( h5, d6 )
                -> ( b6 -> c12 -> g6 -> h5 -> i5, e6 )
                -> ( i5, f6 )
            , tag2 : a21 -> c11
            , tag2Maker :
                a20
                -> b5
                -> c10
                -> ( h4, a19 )
                -> ( i4, d5 )
                -> ( j3, e5 )
                -> ( b5 -> c10 -> h4 -> i4 -> j3 -> k3, f5 )
                -> ( k3, g5 )
            , tag3 : a18 -> c9
            , tag3Maker :
                a17
                -> b4
                -> c8
                -> ( i3, a16 )
                -> ( j2, d4 )
                -> ( k2, e4 )
                -> ( l2, f4 )
                -> ( b4 -> c8 -> i3 -> j2 -> k2 -> l2 -> m2, g4 )
                -> ( m2, h3 )
            , tag4 : a15 -> c7
            , tag4Maker :
                a14
                -> b3
                -> c6
                -> ( j1, a13 )
                -> ( k1, d3 )
                -> ( l1, e3 )
                -> ( m1, f3 )
                -> ( n1, g3 )
                -> ( b3 -> c6 -> j1 -> k1 -> l1 -> m1 -> n1 -> o1, h2 )
                -> ( o1, i2 )
            , tag5 : a12 -> c5
            , tag5Maker :
                a11
                -> b2
                -> c4
                -> ( k, a10 )
                -> ( l, d2 )
                -> ( m, e2 )
                -> ( n, f2 )
                -> ( o, g2 )
                -> ( p, h1 )
                -> ( b2 -> c4 -> k -> l -> m -> n -> o -> p -> q, i1 )
                -> ( q, j )
            , toolConstructor : x
            , triple : a9 -> c3
            , tripleMaker :
                a8
                -> ( f1, b1 )
                -> ( g1, a7 )
                -> ( h, c2 )
                -> ( f1 -> g1 -> h -> i, d1 )
                -> ( i, e1 )
            , tuple : a6 -> c1
            , tupleMaker :
                a5 -> ( e, b ) -> ( f, a4 ) -> ( e -> f -> g, c ) -> ( g, d )
            , tweakConstructor : y
            , tweakerMaker :
                a3
                -> (({} -> {} -> {}) -> q1 -> a1 -> a)
                -> ( ( Maybe a2, w1 ) -> q1, r1 )
                -> ( w1, s1 )
                -> ( a2 -> ToolSpec a1 -> ToolSpec a, t1 )
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
        , tag2 = builder.tag2 << Tuple.pair tool.tag2
        , tag2Maker = builder.tag2Maker >> tag2Maker
        , tag3 = builder.tag3 << Tuple.pair tool.tag3
        , tag3Maker = builder.tag3Maker >> tag3Maker
        , tag4 = builder.tag4 << Tuple.pair tool.tag4
        , tag4Maker = builder.tag4Maker >> tag4Maker
        , tag5 = builder.tag5 << Tuple.pair tool.tag5
        , tag5Maker = builder.tag5Maker >> tag5Maker
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

To define `ToolSpec`s for your own custom types, use `tools.custom`, `tools.tag0`, `tools.tag1`, `tools.tag2`,
`tools.tag3`, `tools.tag4`, `tools.tag5`, and `tools.endCustom`.

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
        tools.custom
            { toString = match, toComparable = match }
            |> tools.tag1 "Some" Some valueSpec
            |> tools.tag0 "None" None
            |> tools.endCustom

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
        { v1
            | afters : t
            , applyDelta : u
            , array : {} -> d11
            , arrayMaker : ({} -> {} -> {}) -> c6 -> d11 -> a14
            , befores : {} -> v
            , bool : {} -> a13
            , char : {} -> a12
            , constructMultiTool : (a24 -> {} -> a24) -> c7 -> d4 -> e6
            , constructTweak : (w -> {} -> w) -> y -> z -> r1
            , custom : {} -> f7
            , customEnder : ({} -> {} -> {}) -> c5 -> d10 -> a10
            , customMaker : (a23 -> {} -> {} -> {}) -> d3 -> e7 -> f7 -> g5
            , destructorFieldGetter : {} -> e7
            , dict : {} -> f6
            , dictMaker : ({} -> {} -> {} -> {}) -> d2 -> e5 -> f6 -> a11
            , endCustom : {} -> d10
            , endRecord : {} -> d7
            , field : {} -> j5
            , fieldMaker :
                (a22 -> b6 -> {} -> {} -> {} -> {})
                -> f3
                -> g4
                -> h3
                -> i5
                -> j5
                -> k5
            , float : {} -> a8
            , int : {} -> a7
            , list : {} -> d9
            , listMaker : ({} -> {} -> {}) -> c3 -> d9 -> a6
            , maybe : {} -> d8
            , maybeMaker : ({} -> {} -> {}) -> c2 -> d8 -> a5
            , record : {} -> d6
            , recordEnder : ({} -> {} -> {}) -> c4 -> d7 -> a9
            , recordMaker : (a21 -> {} -> {}) -> c1 -> d6 -> e4
            , result : {} -> f5
            , resultMaker : ({} -> {} -> {} -> {}) -> d1 -> e3 -> f5 -> a4
            , set : {} -> d5
            , setMaker : ({} -> {} -> {}) -> c -> d5 -> a3
            , string : {} -> a2
            , tag0 : {} -> h5
            , tag0Maker :
                (a20 -> b5 -> {} -> {} -> {}) -> e2 -> f2 -> g3 -> h5 -> i4
            , tag1 : {} -> j4
            , tag1Maker :
                (a19 -> b4 -> {} -> {} -> {} -> {})
                -> f1
                -> g2
                -> h2
                -> i3
                -> j4
                -> k4
            , tag2 : {} -> l3
            , tag2Maker :
                (a18 -> b3 -> {} -> {} -> {} -> {} -> {})
                -> g1
                -> h1
                -> i2
                -> j3
                -> k3
                -> l3
                -> m3
            , tag3 : {} -> n2
            , tag3Maker :
                (a17 -> b2 -> {} -> {} -> {} -> {} -> {} -> {})
                -> h
                -> i1
                -> j2
                -> k2
                -> l2
                -> m2
                -> n2
                -> o2
            , tag4 : {} -> p1
            , tag4Maker :
                (a16 -> b1 -> {} -> {} -> {} -> {} -> {} -> {} -> {})
                -> i
                -> j1
                -> k1
                -> l1
                -> m1
                -> n1
                -> o1
                -> p1
                -> q1
            , tag5 : {} -> r
            , tag5Maker :
                (a15 -> b -> {} -> {} -> {} -> {} -> {} -> {} -> {} -> {})
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
            , toolConstructor : c7
            , triple : {} -> h4
            , tripleMaker : ({} -> {} -> {} -> {} -> {}) -> e1 -> f -> g -> h4 -> a1
            , tuple : {} -> f4
            , tupleMaker : ({} -> {} -> {} -> {}) -> d -> e -> f4 -> a
            , tweakConstructor : y
            , tweakerMaker : (s1 -> {} -> {} -> {}) -> u -> v -> t -> z
        }
    ->
        { array : c6 -> ToolSpec a14
        , bool : ToolSpec a13
        , build : ToolSpec d4 -> e6
        , char : ToolSpec a12
        , custom : d3 -> g5
        , dict : d2 -> e5 -> ToolSpec a11
        , endCustom : c5 -> ToolSpec a10
        , endRecord : c4 -> ToolSpec a9
        , field : f3 -> g4 -> ToolSpec h3 -> i5 -> k5
        , float : ToolSpec a8
        , int : ToolSpec a7
        , list : ToolSpec c3 -> ToolSpec a6
        , maybe : c2 -> ToolSpec a5
        , record : c1 -> e4
        , result : d1 -> e3 -> ToolSpec a4
        , set : c -> ToolSpec a3
        , string : ToolSpec a2
        , tag0 : e2 -> f2 -> g3 -> i4
        , tag1 : f1 -> g2 -> ToolSpec h2 -> i3 -> k4
        , tag2 : g1 -> h1 -> ToolSpec i2 -> ToolSpec j3 -> k3 -> m3
        , tag3 : h -> i1 -> ToolSpec j2 -> ToolSpec k2 -> ToolSpec l2 -> m2 -> o2
        , tag4 :
            i
            -> j1
            -> ToolSpec k1
            -> ToolSpec l1
            -> ToolSpec m1
            -> ToolSpec n1
            -> o1
            -> q1
        , tag5 :
            j
            -> k
            -> ToolSpec l
            -> ToolSpec m
            -> ToolSpec n
            -> ToolSpec o
            -> ToolSpec p
            -> q
            -> s
        , triple : e1 -> f -> g -> ToolSpec a1
        , tuple : d -> e -> ToolSpec a
        , tweak : r1
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

        tag2s =
            toolBuilder.tag2 {}

        tag3s =
            toolBuilder.tag3 {}

        tag4s =
            toolBuilder.tag4 {}

        tag5s =
            toolBuilder.tag5 {}

        endCustoms =
            toolBuilder.endCustom {}

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
            doMakeList toolBuilder.listMaker itemSpec lists
                |> ToolSpec
    , maybe =
        \contentSpec ->
            doMakeMaybe toolBuilder.maybeMaker contentSpec maybes
                |> ToolSpec
    , array =
        \itemSpec ->
            doMakeArray toolBuilder.arrayMaker itemSpec arrays
                |> ToolSpec
    , dict =
        \keySpec valueSpec ->
            doMakeDict toolBuilder.dictMaker keySpec valueSpec dicts
                |> ToolSpec
    , set =
        \memberSpec ->
            doMakeSet toolBuilder.setMaker memberSpec sets
                |> ToolSpec
    , tuple =
        \firstSpec secondSpec ->
            doMakeTuple toolBuilder.tupleMaker firstSpec secondSpec tuples
                |> ToolSpec
    , triple =
        \firstSpec secondSpec thirdSpec ->
            doMakeTriple toolBuilder.tripleMaker firstSpec secondSpec thirdSpec triples
                |> ToolSpec
    , result =
        \errorSpec valueSpec ->
            doMakeResult toolBuilder.resultMaker errorSpec valueSpec results
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
    , custom =
        \customDestructors ->
            doMakeCustom toolBuilder.customMaker customDestructors destructorFieldGetters customs
    , tag0 =
        \tagName tagConstructor customBuilder ->
            doMakeTag0 toolBuilder.tag0Maker tagName tagConstructor customBuilder tag0s
    , tag1 =
        \tagName tagConstructor (ToolSpec arg1Spec) customBuilder ->
            doMakeTag1 toolBuilder.tag1Maker tagName tagConstructor arg1Spec customBuilder tag1s
    , tag2 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) customBuilder ->
            doMakeTag2 toolBuilder.tag2Maker tagName tagConstructor arg1Spec arg2Spec customBuilder tag2s
    , tag3 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) customBuilder ->
            doMakeTag3 toolBuilder.tag3Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder tag3s
    , tag4 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) customBuilder ->
            doMakeTag4 toolBuilder.tag4Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder tag4s
    , tag5 =
        \tagName tagConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) (ToolSpec arg5Spec) customBuilder ->
            doMakeTag5 toolBuilder.tag5Maker tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder tag5s
    , endCustom =
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


doMakeTag1 : ((a -> b -> {} -> {} -> {} -> {}) -> f -> g -> h -> i -> j -> k) -> f -> g -> h -> i -> j -> k
doMakeTag1 tag1Maker_ tagName tagConstructor child1 customBuilder tag1s =
    tag1Maker_ (\_ _ {} {} {} -> {}) tagName tagConstructor child1 customBuilder tag1s


tag1Maker : (b -> c -> a -> d -> e -> f) -> b -> c -> ( g, a ) -> ( h, d ) -> ( b -> c -> g -> h -> i, e ) -> ( i, f )
tag1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( tag1, restTag1s ) =
    ( tag1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doMakeTag2 : ((a -> b -> {} -> {} -> {} -> {} -> {}) -> g -> h -> i -> j -> k -> l -> m) -> g -> h -> i -> j -> k -> l -> m
doMakeTag2 tag2Maker_ tagName tagConstructor arg1Spec arg2Spec customBuilder tag2s =
    tag2Maker_ (\_ _ {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec customBuilder tag2s


tag2Maker : (b -> c -> a -> d -> e -> f -> g) -> b -> c -> ( h, a ) -> ( i, d ) -> ( j, e ) -> ( b -> c -> h -> i -> j -> k, f ) -> ( k, g )
tag2Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( customBuilder, restCustomBuilders ) ( tag2, restTag2s ) =
    ( tag2 tagName tagConstructor arg1Spec arg2Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restCustomBuilders restTag2s
    )


doMakeTag3 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {}) -> h -> i -> j -> k -> l -> m -> n -> o) -> h -> i -> j -> k -> l -> m -> n -> o
doMakeTag3 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder tags


tag3Maker : (b -> c -> a -> d -> e -> f -> g -> h) -> b -> c -> ( i, a ) -> ( j, d ) -> ( k, e ) -> ( l, f ) -> ( b -> c -> i -> j -> k -> l -> m, g ) -> ( m, h )
tag3Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restCustomBuilders restTags
    )


doMakeTag4 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {} -> {}) -> i -> j -> k -> l -> m -> n -> o -> p -> q) -> i -> j -> k -> l -> m -> n -> o -> p -> q
doMakeTag4 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder tags


tag4Maker : (b -> c -> a -> d -> e -> f -> g -> h -> i) -> b -> c -> ( j, a ) -> ( k, d ) -> ( l, e ) -> ( m, f ) -> ( n, g ) -> ( b -> c -> j -> k -> l -> m -> n -> o, h ) -> ( o, i )
tag4Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restC4s restCustomBuilders restTags
    )


doMakeTag5 : ((a -> b -> {} -> {} -> {} -> {} -> {} -> {} -> {} -> {}) -> j -> k -> l -> m -> n -> o -> p -> q -> r -> s) -> j -> k -> l -> m -> n -> o -> p -> q -> r -> s
doMakeTag5 tagMaker_ tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} {} -> {}) tagName tagConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder tags


tag5Maker : (b -> c -> a -> d -> e -> f -> g -> h -> i -> j) -> b -> c -> ( k, a ) -> ( l, d ) -> ( m, e ) -> ( n, f ) -> ( o, g ) -> ( p, h ) -> ( b -> c -> k -> l -> m -> n -> o -> p -> q, i ) -> ( q, j )
tag5Maker next tagName tagConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( arg5Spec, restC5s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
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
