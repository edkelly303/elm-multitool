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
    toolConstructor
    -> tweakConstructor
    ->
        Builder
            { after : ()
            , afters : ()
            , applyMapper : a27 -> a27
            , arrayMaker : a26 -> a26
            , before : a25 -> a25
            , bool : a24 -> a24
            , char : a23 -> a23
            , toolMaker : a22 -> a22
            , customEnder : a21 -> a21
            , customMaker : a20 -> a20
            , dictMaker : a19 -> a19
            , fieldMaker : a18 -> a18
            , float : a17 -> a17
            , int : a16 -> a16
            , listMaker : a15 -> a15
            , maybeMaker : a14 -> a14
            , recordEnder : a13 -> a13
            , recordMaker : a12 -> a12
            , resultMaker : a11 -> a11
            , setMaker : a10 -> a10
            , string : a9 -> a9
            , toolConstructor : toolConstructor
            , tripleMaker : a8 -> a8
            , tupleMaker : a7 -> a7
            , tweakConstructor : tweakConstructor
            , tweakMaker : a6 -> a6
            , variant0Maker : a5 -> a5
            , variant1Maker : a4 -> a4
            , variant2Maker : a3 -> a3
            , variant3Maker : a2 -> a2
            , variant4Maker : a1 -> a1
            , variant5Maker : a -> a
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
        , recordMaker = identity
        , fieldMaker = identity
        , recordEnder = identity

        -- custom type combinators
        , customMaker = identity
        , variant0Maker = identity
        , variant1Maker = identity
        , variant2Maker = identity
        , variant3Maker = identity
        , variant4Maker = identity
        , variant5Maker = identity
        , customEnder = identity

        -- constructing the multitool
        , toolConstructor = toolConstructor
        , toolMaker = identity

        -- constructing tweakers
        , before = identity
        , after = ()
        , afters = ()
        , tweakMaker = identity
        , applyMapper = identity
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
    (c27 -> b20)
    ->
        { array : a27 -> b12
        , bool : a43
        , char : a42
        , customType : b20 -> a40
        , dict : a21 -> b9 -> c25
        , endCustomType : a41 -> b19
        , endRecord : a11 -> b5
        , field : c24 -> d13 -> a19 -> b8 -> e4
        , float : a39
        , int : a38
        , list : a15 -> b7
        , maybe : a13 -> b6
        , record : c18 -> a9
        , result : a7 -> b3 -> c17
        , set : a5 -> b2
        , string : a37
        , triple : a2 -> b1 -> c14 -> d7
        , tuple : a -> b -> c13
        , variant0 : c11 -> d5 -> a36 -> b18
        , variant1 : c9 -> d4 -> a35 -> b17 -> e10
        , variant2 : c7 -> d3 -> a34 -> b16 -> e9 -> f10
        , variant3 : c5 -> d2 -> a33 -> b15 -> e8 -> f9 -> g6
        , variant4 : c3 -> d1 -> a32 -> b14 -> e7 -> f8 -> g5 -> h6
        , variant5 : c1 -> d -> a31 -> b13 -> e6 -> f7 -> g4 -> h5 -> i3
        }
    ->
        Builder
            { after : r
            , afters : s
            , applyMapper : a29 -> restMappers -> restToolSpecs -> restToolSpecs
            , arrayMaker : a28 -> c33 -> d17
            , before : ( Maybe mapper, after ) -> mappers
            , bool : ( a43, a26 ) -> c32
            , char : ( a42, a25 ) -> c31
            , toolMaker : a24 -> a23 -> b11 -> c30
            , customEnder : (( a41, c29 ) -> ( b19, d15 )) -> c28
            , customMaker : (c27 -> ( a40, b10 )) -> c26
            , dictMaker : a22 -> d14 -> e5 -> f6
            , fieldMaker : a20 -> c24 -> d13 -> f5 -> g3 -> h4
            , float : ( a39, a18 ) -> c23
            , int : ( a38, a17 ) -> c22
            , listMaker : a16 -> c21 -> d12
            , maybeMaker : a14 -> c20 -> d11
            , recordEnder : a12 -> c19 -> d10
            , recordMaker : a10 -> c18 -> b4
            , resultMaker : a8 -> d9 -> e3 -> f4
            , setMaker : a6 -> c16 -> d8
            , string : ( a37, a4 ) -> c15
            , toolConstructor : t
            , tripleMaker : a3 -> e2 -> f3 -> g2 -> h3
            , tupleMaker : a1 -> d6 -> e1 -> f2
            , tweakConstructor : u
            , tweakMaker :
                (((mapper -> ToolSpec toolSpec -> ToolSpec toolSpec) -> ctor)
                 -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec)
                 -> ( after, restAfters )
                 -> tweak
                )
                -> c12
            , variant0Maker : (c11 -> d5 -> ( a36, e ) -> ( b18, f1 )) -> c10
            , variant1Maker :
                (c9 -> d4 -> ( a35, f ) -> ( b17, g1 ) -> ( e10, h2 )) -> c8
            , variant2Maker :
                (c7
                 -> d3
                 -> ( a34, g )
                 -> ( b16, h1 )
                 -> ( e9, i2 )
                 -> ( f10, j3 )
                )
                -> c6
            , variant3Maker :
                (c5
                 -> d2
                 -> ( a33, h )
                 -> ( b15, i1 )
                 -> ( e8, j2 )
                 -> ( f9, k2 )
                 -> ( g6, l2 )
                )
                -> c4
            , variant4Maker :
                (c3
                 -> d1
                 -> ( a32, i )
                 -> ( b14, j1 )
                 -> ( e7, k1 )
                 -> ( f8, l1 )
                 -> ( g5, m1 )
                 -> ( h6, n1 )
                )
                -> c2
            , variant5Maker :
                (c1
                 -> d
                 -> ( a31, j )
                 -> ( b13, k )
                 -> ( e6, l )
                 -> ( f7, m )
                 -> ( g4, n )
                 -> ( h5, o )
                 -> ( i3, p )
                )
                -> c
            }
    ->
        Builder
            { after : ( Maybe a30, r )
            , afters : ( r, s )
            , applyMapper :
                a29
                -> ( Maybe (toolSpec1 -> toolSpec1), restMappers )
                -> ( toolSpec1, restToolSpecs )
                -> ( toolSpec1, restToolSpecs )
            , arrayMaker : a28 -> ( a27, c33 ) -> ( b12, d17 )
            , before : after -> mappers
            , bool : a26 -> c32
            , char : a25 -> c31
            , toolMaker : a24 -> (d16 -> a23) -> ( d16, b11 ) -> c30
            , customEnder : (c29 -> d15) -> c28
            , customMaker : (c27 -> b10) -> c26
            , dictMaker : a22 -> ( a21, d14 ) -> ( b9, e5 ) -> ( c25, f6 )
            , fieldMaker :
                a20 -> c24 -> d13 -> ( a19, f5 ) -> ( b8, g3 ) -> ( e4, h4 )
            , float : a18 -> c23
            , int : a17 -> c22
            , listMaker : a16 -> ( a15, c21 ) -> ( b7, d12 )
            , maybeMaker : a14 -> ( a13, c20 ) -> ( b6, d11 )
            , recordEnder : a12 -> ( a11, c19 ) -> ( b5, d10 )
            , recordMaker : a10 -> c18 -> ( a9, b4 )
            , resultMaker : a8 -> ( a7, d9 ) -> ( b3, e3 ) -> ( c17, f4 )
            , setMaker : a6 -> ( a5, c16 ) -> ( b2, d8 )
            , string : a4 -> c15
            , toolConstructor : t
            , tripleMaker :
                a3 -> ( a2, e2 ) -> ( b1, f3 ) -> ( c14, g2 ) -> ( d7, h3 )
            , tupleMaker : a1 -> ( a, d6 ) -> ( b, e1 ) -> ( c13, f2 )
            , tweakConstructor : u
            , tweakMaker :
                (ctor
                 -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec)
                 -> restAfters
                 -> tweak
                )
                -> c12
            , variant0Maker : (c11 -> d5 -> e -> f1) -> c10
            , variant1Maker : (c9 -> d4 -> f -> g1 -> h2) -> c8
            , variant2Maker : (c7 -> d3 -> g -> h1 -> i2 -> j3) -> c6
            , variant3Maker : (c5 -> d2 -> h -> i1 -> j2 -> k2 -> l2) -> c4
            , variant4Maker : (c3 -> d1 -> i -> j1 -> k1 -> l1 -> m1 -> n1) -> c2
            , variant5Maker : (c1 -> d -> j -> k -> l -> m -> n -> o -> p) -> c
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
        , recordMaker = builder.recordMaker >> recordMaker tool.record
        , fieldMaker = builder.fieldMaker >> fieldMaker tool.field
        , recordEnder = builder.recordEnder >> recordEnder tool.endRecord

        -- custom type combinators
        , customMaker = builder.customMaker << customMaker (tool.customType << destructorFieldGetter)
        , variant0Maker = builder.variant0Maker << variant0Maker tool.variant0
        , variant1Maker = builder.variant1Maker << variant1Maker tool.variant1
        , variant2Maker = builder.variant2Maker << variant2Maker tool.variant2
        , variant3Maker = builder.variant3Maker << variant3Maker tool.variant3
        , variant4Maker = builder.variant4Maker << variant4Maker tool.variant4
        , variant5Maker = builder.variant5Maker << variant5Maker tool.variant5
        , customEnder = builder.customEnder << customEnder tool.endCustomType

        -- constructing the multitool
        , toolConstructor = builder.toolConstructor
        , toolMaker = builder.toolMaker >> toolMaker

        -- constructing tweakers
        , before = builder.before << Tuple.pair Nothing
        , after = ( Nothing, builder.after )
        , afters = ( builder.after, builder.afters )
        , tweakMaker = builder.tweakMaker << tweakMaker builder.before
        , applyMapper = builder.applyMapper >> applyMapper
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
            match some none variant =
                case variant of
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
        { after : after
        , afters : afters
        , applyMapper : applyMapper
        , arrayMaker : (() -> ()) -> b7 -> a9
        , before : before
        , bool : () -> toolSpec4
        , char : () -> toolSpec3
        , toolMaker : (a19 -> () -> a19) -> c12 -> d11 -> a19
        , customEnder : (() -> ()) -> b5 -> a7
        , customMaker : (a18 -> ()) -> b6 -> c11
        , dictMaker : (() -> () -> ()) -> c10 -> d10 -> a8
        , fieldMaker :
            (a17 -> b14 -> () -> () -> ()) -> c9 -> d9 -> e7 -> f7 -> g5
        , float : () -> toolSpec2
        , int : () -> toolSpec1
        , listMaker : (() -> ()) -> b3 -> a5
        , maybeMaker : (() -> ()) -> b2 -> a4
        , recordEnder : (() -> ()) -> b4 -> a6
        , recordMaker : (a16 -> ()) -> b1 -> c8
        , resultMaker : (() -> () -> ()) -> c7 -> d8 -> a3
        , setMaker : (() -> ()) -> b -> a2
        , string : () -> toolSpec
        , toolConstructor : c12
        , tripleMaker : (() -> () -> () -> ()) -> d7 -> e6 -> f6 -> a1
        , tupleMaker : (() -> () -> ()) -> c6 -> d6 -> a
        , tweakConstructor : ctor
        , tweakMaker :
            (tweak -> applyMapper -> () -> tweak)
            -> ctor
            -> applyMapper
            -> afters
            -> tweak
        , variant0Maker : (a15 -> b13 -> () -> ()) -> c5 -> d5 -> e5 -> f5
        , variant1Maker :
            (a14 -> b12 -> () -> () -> ()) -> c4 -> d4 -> e4 -> f4 -> g4
        , variant2Maker :
            (a13 -> b11 -> () -> () -> () -> ())
            -> c3
            -> d3
            -> e3
            -> f3
            -> g3
            -> h3
        , variant3Maker :
            (a12 -> b10 -> () -> () -> () -> () -> ())
            -> c2
            -> d2
            -> e2
            -> f2
            -> g2
            -> h2
            -> i2
        , variant4Maker :
            (a11 -> b9 -> () -> () -> () -> () -> () -> ())
            -> c1
            -> d1
            -> e1
            -> f1
            -> g1
            -> h1
            -> i1
            -> j1
        , variant5Maker :
            (a10 -> b8 -> () -> () -> () -> () -> () -> () -> ())
            -> c
            -> d
            -> e
            -> f
            -> g
            -> h
            -> i
            -> j
            -> k
        }
    ->
        { array : ToolSpec b7 -> ToolSpec a9
        , bool : ToolSpec toolSpec4
        , build : ToolSpec d11 -> a19
        , char : ToolSpec toolSpec3
        , customType : b6 -> c11
        , dict : ToolSpec c10 -> ToolSpec d10 -> ToolSpec a8
        , endCustomType : b5 -> ToolSpec a7
        , endRecord : b4 -> ToolSpec a6
        , field : c9 -> d9 -> ToolSpec e7 -> f7 -> g5
        , float : ToolSpec toolSpec2
        , int : ToolSpec toolSpec1
        , list : ToolSpec b3 -> ToolSpec a5
        , maybe : ToolSpec b2 -> ToolSpec a4
        , record : b1 -> c8
        , result : ToolSpec c7 -> ToolSpec d8 -> ToolSpec a3
        , set : ToolSpec b -> ToolSpec a2
        , string : ToolSpec toolSpec
        , triple : ToolSpec d7 -> ToolSpec e6 -> ToolSpec f6 -> ToolSpec a1
        , tuple : ToolSpec c6 -> ToolSpec d6 -> ToolSpec a
        , tweak : tweak
        , variant0 : c5 -> d5 -> e5 -> f5
        , variant1 : c4 -> d4 -> ToolSpec e4 -> f4 -> g4
        , variant2 : c3 -> d3 -> ToolSpec e3 -> ToolSpec f3 -> g3 -> h3
        , variant3 :
            c2 -> d2 -> ToolSpec e2 -> ToolSpec f2 -> ToolSpec g2 -> h2 -> i2
        , variant4 :
            c1
            -> d1
            -> ToolSpec e1
            -> ToolSpec f1
            -> ToolSpec g1
            -> ToolSpec h1
            -> i1
            -> j1
        , variant5 :
            c
            -> d
            -> ToolSpec e
            -> ToolSpec f
            -> ToolSpec g
            -> ToolSpec h
            -> ToolSpec i
            -> j
            -> k
        }
end (Builder toolBuilder) =
    let
        -- primitives
        strings =
            toolBuilder.string ()

        ints =
            toolBuilder.int ()

        bools =
            toolBuilder.bool ()

        floats =
            toolBuilder.float ()

        chars =
            toolBuilder.char ()
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
            doMakeRecord toolBuilder.recordMaker recordConstructor
    , field =
        \fieldName getField (ToolSpec fieldSpec) recordBuilder ->
            doMakeFields toolBuilder.fieldMaker fieldName getField fieldSpec recordBuilder
    , endRecord =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder
                |> ToolSpec

    -- custom types
    , customType =
        \customDestructors ->
            doMakeCustom toolBuilder.customMaker customDestructors
    , variant0 =
        \variantName variantConstructor customBuilder ->
            doMakeVariant0 toolBuilder.variant0Maker variantName variantConstructor customBuilder
    , variant1 =
        \variantName variantConstructor (ToolSpec arg1Spec) customBuilder ->
            doMakeVariant1 toolBuilder.variant1Maker variantName variantConstructor arg1Spec customBuilder
    , variant2 =
        \variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) customBuilder ->
            doMakeVariant2 toolBuilder.variant2Maker variantName variantConstructor arg1Spec arg2Spec customBuilder
    , variant3 =
        \variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) customBuilder ->
            doMakeVariant3 toolBuilder.variant3Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , variant4 =
        \variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) customBuilder ->
            doMakeVariant4 toolBuilder.variant4Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , variant5 =
        \variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) (ToolSpec arg5Spec) customBuilder ->
            doMakeVariant5 toolBuilder.variant5Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder
    , endCustomType =
        \customBuilder ->
            doEndCustom toolBuilder.customEnder customBuilder
                |> ToolSpec

    -- turn a spec into a usable multiTool
    , build =
        \(ToolSpec toolSpec) ->
            doMakeTool toolBuilder.toolMaker toolBuilder.toolConstructor toolSpec
    , tweak =
        doMakeTweak toolBuilder.tweakMaker toolBuilder.tweakConstructor toolBuilder.applyMapper toolBuilder.afters
    }


{-| A tool specification - the basic building block for creating tools for the types in your application.
-}
type ToolSpec toolSpec
    = ToolSpec toolSpec


doMakeTool : ((tool -> () -> tool) -> toolConstructor -> builder -> tool) -> toolConstructor -> builder -> tool
doMakeTool toolMaker_ ctor builder =
    toolMaker_ (\output () -> output) ctor builder


toolMaker : (toolConstructor -> restBuilders -> tool) -> (builder -> toolConstructor) -> ( builder, restBuilders ) -> tool
toolMaker next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders


doMakeTweak :
    ((tweak -> applyMapper -> () -> tweak) -> tweakConstructor -> applyMapper -> afters -> tweak)
    -> tweakConstructor
    -> applyMapper
    -> afters
    -> tweak
doMakeTweak tweakMaker_ ctor applyMapper_ afters =
    tweakMaker_ (\tweak _ () -> tweak) ctor applyMapper_ afters


tweakMaker :
    (( Maybe mapper, after ) -> mappers)
    -> (tweakConstructor -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec) -> restAfters -> tweak)
    -> ((mapper -> ToolSpec toolSpec -> ToolSpec toolSpec) -> tweakConstructor)
    -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec)
    -> ( after, restAfters )
    -> tweak
tweakMaker before next ctor applyMapper_ ( after, restAfters ) =
    let
        tweaker =
            \mapper (ToolSpec toolSpec) ->
                let
                    mappers =
                        before ( Just mapper, after )
                in
                applyMapper_ (\() () -> ()) mappers toolSpec
                    |> ToolSpec
    in
    next (ctor tweaker) applyMapper_ restAfters


applyMapper :
    (restMappers -> restToolSpecs -> restToolSpecs)
    -> ( Maybe (toolSpec -> toolSpec), restMappers )
    -> ( toolSpec, restToolSpecs )
    -> ( toolSpec, restToolSpecs )
applyMapper next ( delta, restDeltas ) ( toolSpec, restToolSpecs ) =
    ( case delta of
        Just mapper ->
            mapper toolSpec

        Nothing ->
            toolSpec
    , next restDeltas restToolSpecs
    )


doMakeList : ((() -> ()) -> b -> c) -> b -> c
doMakeList listMaker_ listChildren_ =
    listMaker_ (\() -> ()) listChildren_


listMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
listMaker list_ next ( listChild, restListChildren ) =
    ( list_ listChild
    , next restListChildren
    )


doMakeMaybe : ((() -> ()) -> b -> c) -> b -> c
doMakeMaybe maybeMaker_ maybeContents_ =
    maybeMaker_ (\() -> ()) maybeContents_


maybeMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
maybeMaker maybe_ next ( maybeContent, restMaybeContents ) =
    ( maybe_ maybeContent
    , next restMaybeContents
    )


doMakeArray : ((() -> ()) -> b -> c) -> b -> c
doMakeArray maker_ contents_ =
    maker_ (\() -> ()) contents_


arrayMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
arrayMaker array_ next ( content, restContents ) =
    ( array_ content
    , next restContents
    )


doMakeDict : ((() -> () -> ()) -> c -> d -> e) -> c -> d -> e
doMakeDict dictMaker_ keys_ values_ =
    dictMaker_ (\() () -> ()) keys_ values_


dictMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
dictMaker dict_ next ( key_, restKeys ) ( value_, restValues ) =
    ( dict_ key_ value_
    , next restKeys restValues
    )


doMakeSet : ((() -> ()) -> b -> c) -> b -> c
doMakeSet setMaker_ contents_ =
    setMaker_ (\() -> ()) contents_


setMaker : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
setMaker set_ next ( content, restContents ) =
    ( set_ content
    , next restContents
    )


doMakeTuple : ((() -> () -> ()) -> c -> d -> e) -> c -> d -> e
doMakeTuple tupleMaker_ a b =
    tupleMaker_ (\() () -> ()) a b


tupleMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
tupleMaker tuple_ next ( a, restAs ) ( b, restBs ) =
    ( tuple_ a b
    , next restAs restBs
    )


doMakeTriple : ((() -> () -> () -> ()) -> d -> e -> f -> g) -> d -> e -> f -> g
doMakeTriple tripleMaker_ a b c =
    tripleMaker_ (\() () () -> ()) a b c


tripleMaker : (a -> b -> c -> d) -> (e -> f -> g -> h) -> ( a, e ) -> ( b, f ) -> ( c, g ) -> ( d, h )
tripleMaker triple_ next ( a, restAs ) ( b, restBs ) ( c, restCs ) =
    ( triple_ a b c
    , next restAs restBs restCs
    )


doMakeResult : ((() -> () -> ()) -> c -> d -> e) -> c -> d -> e
doMakeResult resultMaker_ errors values =
    resultMaker_ (\() () -> ()) errors values


resultMaker : (a -> b -> c) -> (d -> e -> f) -> ( a, d ) -> ( b, e ) -> ( c, f )
resultMaker result_ next ( error, restErrors ) ( value, restValues ) =
    ( result_ error value
    , next restErrors restValues
    )


doMakeRecord : ((a -> ()) -> b -> c) -> b -> c
doMakeRecord recordMaker_ recordConstructor =
    recordMaker_ (\_ -> ()) recordConstructor


recordMaker : (c -> a) -> (c -> b) -> c -> ( a, b )
recordMaker record_ next recordConstructor =
    ( record_ recordConstructor
    , next recordConstructor
    )


doMakeFields : ((a -> b -> () -> () -> ()) -> c -> d -> e -> f -> g) -> c -> d -> e -> f -> g
doMakeFields fieldMaker_ fieldName getField child recordBuilders =
    fieldMaker_ (\_ _ () () -> ()) fieldName getField child recordBuilders


fieldMaker : (c -> d -> a -> b -> e) -> (c -> d -> f -> g -> h) -> c -> d -> ( a, f ) -> ( b, g ) -> ( e, h )
fieldMaker field_ next fieldName getField ( child, restChilds ) ( builder, restBuilders ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders
    )


doEndRecord : ((() -> ()) -> b -> a) -> b -> a
doEndRecord recordEnder_ builder =
    recordEnder_ (\() -> ()) builder


recordEnder : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
recordEnder endRecord_ next ( builder, restBuilders ) =
    ( endRecord_ builder
    , next restBuilders
    )


doMakeCustom : ((a -> ()) -> b -> c) -> b -> c
doMakeCustom customMaker_ customDestructors =
    customMaker_ (\_ -> ()) customDestructors


customMaker : (c -> a) -> (c -> b) -> c -> ( a, b )
customMaker customType_ next customDestructors =
    ( customType_ customDestructors
    , next customDestructors
    )


doMakeVariant0 : ((a -> b -> () -> ()) -> c -> d -> e -> f) -> c -> d -> e -> f
doMakeVariant0 variant0Maker_ variantName variantConstructor customBuilder =
    variant0Maker_ (\_ _ () -> ()) variantName variantConstructor customBuilder


variant0Maker : (c -> d -> a -> b) -> (c -> d -> e -> f) -> c -> d -> ( a, e ) -> ( b, f )
variant0Maker variant0_ next variantName variantConstructor ( customBuilder, restCustomBuilders ) =
    ( variant0_ variantName variantConstructor customBuilder
    , next variantName variantConstructor restCustomBuilders
    )


doMakeVariant1 : ((a -> b -> () -> () -> ()) -> c -> d -> e -> f -> g) -> c -> d -> e -> f -> g
doMakeVariant1 variant1Maker_ variantName variantConstructor child1 customBuilder =
    variant1Maker_ (\_ _ () () -> ()) variantName variantConstructor child1 customBuilder


variant1Maker : (c -> d -> a -> b -> e) -> (c -> d -> f -> g -> h) -> c -> d -> ( a, f ) -> ( b, g ) -> ( e, h )
variant1Maker variant1_ next variantName variantConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) =
    ( variant1_ variantName variantConstructor child1 customBuilder
    , next variantName variantConstructor restChild1s restCustomBuilders
    )


doMakeVariant2 : ((a -> b -> () -> () -> () -> ()) -> c -> d -> e -> f -> g -> h) -> c -> d -> e -> f -> g -> h
doMakeVariant2 variant2Maker_ variantName variantConstructor arg1Spec arg2Spec customBuilder =
    variant2Maker_ (\_ _ () () () -> ()) variantName variantConstructor arg1Spec arg2Spec customBuilder


variant2Maker : (c -> d -> a -> b -> e -> f) -> (c -> d -> g -> h -> i -> j) -> c -> d -> ( a, g ) -> ( b, h ) -> ( e, i ) -> ( f, j )
variant2Maker variant2_ next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( customBuilder, restCustomBuilders ) =
    ( variant2_ variantName variantConstructor arg1Spec arg2Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restCustomBuilders
    )


doMakeVariant3 : ((a -> b -> () -> () -> () -> () -> ()) -> c -> d -> e -> f -> g -> h -> i) -> c -> d -> e -> f -> g -> h -> i
doMakeVariant3 variantMaker_ variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder =
    variantMaker_ (\_ _ () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder


variant3Maker : (c -> d -> a -> b -> e -> f -> g) -> (c -> d -> h -> i -> j -> k -> l) -> c -> d -> ( a, h ) -> ( b, i ) -> ( e, j ) -> ( f, k ) -> ( g, l )
variant3Maker variant3_ next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( customBuilder, restCustomBuilders ) =
    ( variant3_ variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restCustomBuilders
    )


doMakeVariant4 : ((a -> b -> () -> () -> () -> () -> () -> ()) -> c -> d -> e -> f -> g -> h -> i -> j) -> c -> d -> e -> f -> g -> h -> i -> j
doMakeVariant4 variantMaker_ variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder =
    variantMaker_ (\_ _ () () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder


variant4Maker : (c -> d -> a -> b -> e -> f -> g -> h) -> (c -> d -> i -> j -> k -> l -> m -> n) -> c -> d -> ( a, i ) -> ( b, j ) -> ( e, k ) -> ( f, l ) -> ( g, m ) -> ( h, n )
variant4Maker variant next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( customBuilder, restCustomBuilders ) =
    ( variant variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restC4s restCustomBuilders
    )


doMakeVariant5 : ((a -> b -> () -> () -> () -> () -> () -> () -> ()) -> c -> d -> e -> f -> g -> h -> i -> j -> k) -> c -> d -> e -> f -> g -> h -> i -> j -> k
doMakeVariant5 variantMaker_ variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder =
    variantMaker_ (\_ _ () () () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder


variant5Maker : (c -> d -> a -> b -> e -> f -> g -> h -> i) -> (c -> d -> j -> k -> l -> m -> n -> o -> p) -> c -> d -> ( a, j ) -> ( b, k ) -> ( e, l ) -> ( f, m ) -> ( g, n ) -> ( h, o ) -> ( i, p )
variant5Maker variant next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( arg5Spec, restC5s ) ( customBuilder, restCustomBuilders ) =
    ( variant variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restC4s restC5s restCustomBuilders
    )


doEndCustom : ((() -> ()) -> b -> a) -> b -> a
doEndCustom customEnder_ customBuilder =
    customEnder_ (\() -> ()) customBuilder


customEnder : (a -> b) -> (c -> d) -> ( a, c ) -> ( b, d )
customEnder endCustom_ next ( customBuilder, restCustomBuilders ) =
    ( endCustom_ customBuilder
    , next restCustomBuilders
    )
