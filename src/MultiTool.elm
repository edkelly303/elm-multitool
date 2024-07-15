module MultiTool exposing
    ( define, Builder
    , add
    , end, ToolSpec
    )

{-| **Fun fact**: The type annotations for the functions in this package are
pretty horrifying.

**Hot tip**: Ignore them! There's no need to put any of these functions, or the
tools they produce, in your application's `Msg` or `Model` type. So you don't
need to know or care about what their type signatures are. Just read the docs
and look at the examples. It'll be fine.\*

\* Unless you make any kind of minor typo in your code, in which case the Elm
compiler may respond with a Lovecraftian error message 😱.

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

This function takes two identical arguments. Both arguments should be a function
that constructs a record with a field for each of the tools you intend to
include in your MultiTool.

For example, if you want to combine a `ToString` tool and a `ToComparable` tool,
you could do something like this:

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

**Note**: The order of the type parameters in the `Tools` type alias is
important. It needs to match the order in which you add the tool interfaces with
`MultiTool.add`.

In this example, we see that `toString` comes first and `toComparable` comes
second in _both_ the `Tools` type alias and the interfaces added to `tools`.

-}
define :
    toolConstructor
    -> tweakConstructor
    ->
        Builder
            { after : ()
            , afters : ()
            , applyTweakFn : applyTweakFn -> applyTweakFn
            , arrayMaker : arrayMaker -> arrayMaker
            , before : before -> before
            , bool : bool -> bool
            , char : char -> char
            , toolMaker : toolMaker -> toolMaker
            , customEnder : customEnder -> customEnder
            , customMaker : customMaker -> customMaker
            , dictMaker : dictMaker -> dictMaker
            , fieldMaker : fieldMaker -> fieldMaker
            , float : float -> float
            , int : int -> int
            , listMaker : listMaker -> listMaker
            , maybeMaker : maybeMaker -> maybeMaker
            , recordEnder : recordEnder -> recordEnder
            , recordMaker : recordMaker -> recordMaker
            , resultMaker : resultMaker -> resultMaker
            , setMaker : setMaker -> setMaker
            , string : string -> string
            , toolConstructor : toolConstructor
            , tripleMaker : tripleMaker -> tripleMaker
            , tupleMaker : tupleMaker -> tupleMaker
            , tweakConstructor : tweakConstructor
            , tweakMaker : tweakMaker -> tweakMaker
            , variant0Maker : variant0Maker -> variant0Maker
            , variant1Maker : variant1Maker -> variant1Maker
            , variant2Maker : variant2Maker -> variant2Maker
            , variant3Maker : variant3Maker -> variant3Maker
            , variant4Maker : variant4Maker -> variant4Maker
            , variant5Maker : variant5Maker -> variant5Maker
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
        , applyTweakFn = identity
        , tweakConstructor = tweakConstructor
        }


{-|


### `add`

Add a tool to your MultiTool.

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
        , customType = Codec.custom
        , variant0 = Codec.variant0
        , variant1 = Codec.variant1
        , variant2 = Codec.variant2
        , variant3 = Codec.variant3
        , variant4 = Codec.variant4
        , variant5 = Codec.variant5
        , endCustomType = Codec.buildCustom
        }

(You'll notice that this interface type mostly looks straightforward, except for
the `dict` field. The problem here is that we need a `Dict` implementation that
can take any `comparable` as a key, but `elm-codec`'s built-in `dict` function
only accepts `String`s as keys. Fortunately, we can build the function we need
using `elm-codec`'s lower-level primitives.)

The third and final argument is the `MultiTool.Builder` that you've already
created using `define`. The API here is designed for piping with the `|>`
operator, so you'll usually want to apply this final argument like this:

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add .codec codecInterface

-}
add :
    (customDestructor -> c)
    ->
        { array : thisA7 -> thisB7
        , bool : a5
        , char : a4
        , customType : c -> customBuilder7
        , dict : thisA6 -> thisB6 -> thisC4
        , endCustomType : customBuilder8 -> customTypeSpec
        , endRecord : recordBuilder1 -> recordSpec
        , field :
            String -> getField -> fieldTool -> recordBuilder3 -> recordBuilder2
        , float : a3
        , int : a2
        , list : thisA5 -> thisB5
        , maybe : thisA4 -> thisB4
        , record : recordConstructor -> recordBuilder
        , result : thisA3 -> thisB3 -> thisC3
        , set : thisA2 -> thisB2
        , string : a1
        , triple : thisA1 -> thisB1 -> thisC2 -> thisD
        , tuple : thisA -> thisB -> thisC1
        , variant0 :
            String -> variantConstructor5 -> customBuilder6 -> customBuilder2_5
        , variant1 :
            String
            -> variantConstructor4
            -> arg1Tool4
            -> customBuilder5
            -> customBuilder2_4
        , variant2 :
            String
            -> variantConstructor3
            -> arg1Tool3
            -> arg2Tool3
            -> customBuilder4
            -> customBuilder2_3
        , variant3 :
            String
            -> variantConstructor2
            -> arg1Tool2
            -> arg2Tool2
            -> arg3Tool2
            -> customBuilder3
            -> customBuilder2_2
        , variant4 :
            String
            -> variantConstructor1
            -> arg1Tool1
            -> arg2Tool1
            -> arg3Tool1
            -> arg4Tool1
            -> customBuilder1
            -> customBuilder2_1
        , variant5 :
            String
            -> variantConstructor
            -> arg1Tool
            -> arg2Tool
            -> arg3Tool
            -> arg4Tool
            -> arg5Tool
            -> customBuilder
            -> customBuilder2
        }
    ->
        Builder
            { after : e
            , afters : f
            , applyTweakFn : g -> restA8 -> restB8 -> restC4
            , arrayMaker : (( thisA7, restA7 ) -> ( thisB7, restB7 )) -> h
            , before : ( Maybe mapper, after ) -> tweakFns
            , bool : ( a5, b4 ) -> i
            , char : ( a4, b3 ) -> j
            , customEnder :
                (( customBuilder8, restCustomBuilders8 )
                 -> ( customTypeSpec, restCustomTypeSpecs )
                )
                -> k
            , customMaker :
                (customDestructor -> ( customBuilder7, restCustomBuilders7 ))
                -> l
            , dictMaker :
                (( thisA6, restA6 ) -> ( thisB6, restB6 ) -> ( thisC4, restC3 ))
                -> m
            , fieldMaker :
                (String
                 -> getField
                 -> ( fieldTool, restFieldTools )
                 -> ( recordBuilder3, restRecordBuilders2 )
                 -> ( recordBuilder2, restRecordBuilder2s )
                )
                -> n
            , float : ( a3, b2 ) -> o
            , int : ( a2, b1 ) -> p
            , listMaker : (( thisA5, restA5 ) -> ( thisB5, restB5 )) -> q
            , maybeMaker : (( thisA4, restA4 ) -> ( thisB4, restB4 )) -> r
            , recordEnder :
                (( recordBuilder1, restRecordBuilders1 )
                 -> ( recordSpec, restRecordSpecs )
                )
                -> s
            , recordMaker :
                (recordConstructor -> ( recordBuilder, restRecordBuilders ))
                -> t
            , resultMaker :
                (( thisA3, restA3 ) -> ( thisB3, restB3 ) -> ( thisC3, restC2 ))
                -> u
            , setMaker : (( thisA2, restA2 ) -> ( thisB2, restB2 )) -> v
            , string : ( a1, b ) -> w
            , toolConstructor : x
            , toolMaker : y -> multiToolConstructor -> restTools -> multiTool
            , tripleMaker :
                (( thisA1, restA1 )
                 -> ( thisB1, restB1 )
                 -> ( thisC2, restC1 )
                 -> ( thisD, restD )
                )
                -> z
            , tupleMaker :
                (( thisA, restA ) -> ( thisB, restB ) -> ( thisC1, restC ))
                -> c1
            , tweakConstructor : d1
            , tweakMaker :
                (((mapper -> ToolSpec tool -> ToolSpec tool) -> tweakConstructor)
                 -> ((() -> () -> ()) -> tweakFns -> tool -> tool)
                 -> ( after, restAfters )
                 -> tweak
                )
                -> e1
            , variant0Maker :
                (String
                 -> variantConstructor5
                 -> ( customBuilder6, restCustomBuilders6 )
                 -> ( customBuilder2_5, restCustomBuilders2_5 )
                )
                -> f1
            , variant1Maker :
                (String
                 -> variantConstructor4
                 -> ( arg1Tool4, restArg1Tools4 )
                 -> ( customBuilder5, restCustomBuilders5 )
                 -> ( customBuilder2_4, restCustomBuilders2_4 )
                )
                -> g1
            , variant2Maker :
                (String
                 -> variantConstructor3
                 -> ( arg1Tool3, restArg1Tools3 )
                 -> ( arg2Tool3, restArg2Tools3 )
                 -> ( customBuilder4, restCustomBuilders4 )
                 -> ( customBuilder2_3, restCustomBuilders2_3 )
                )
                -> h1
            , variant3Maker :
                (String
                 -> variantConstructor2
                 -> ( arg1Tool2, restArg1Tools2 )
                 -> ( arg2Tool2, restArg2Tools2 )
                 -> ( arg3Tool2, restArg3Tools2 )
                 -> ( customBuilder3, restCustomBuilders3 )
                 -> ( customBuilder2_2, restCustomBuilders2_2 )
                )
                -> i1
            , variant4Maker :
                (String
                 -> variantConstructor1
                 -> ( arg1Tool1, restArg1Tools1 )
                 -> ( arg2Tool1, restArg2Tools1 )
                 -> ( arg3Tool1, restArg3Tools1 )
                 -> ( arg4Tool1, restArg4Tools1 )
                 -> ( customBuilder1, restCustomBuilders1 )
                 -> ( customBuilder2_1, restCustomBuilders2_1 )
                )
                -> j1
            , variant5Maker :
                (String
                 -> variantConstructor
                 -> ( arg1Tool, restArg1Tools )
                 -> ( arg2Tool, restArg2Tools )
                 -> ( arg3Tool, restArg3Tools )
                 -> ( arg4Tool, restArg4Tools )
                 -> ( arg5Tool, restArg5Tools )
                 -> ( customBuilder, restCustomBuilders )
                 -> ( customBuilder2, restCustomBuilders2 )
                )
                -> k1
            }
    ->
        Builder
            { after : ( Maybe a, e )
            , afters : ( e, f )
            , applyTweakFn :
                g
                -> ( Maybe (thisC -> thisC), restA8 )
                -> ( thisC, restB8 )
                -> ( thisC, restC4 )
            , arrayMaker : (restA7 -> restB7) -> h
            , before : after -> tweakFns
            , bool : b4 -> i
            , char : b3 -> j
            , customEnder : (restCustomBuilders8 -> restCustomTypeSpecs) -> k
            , customMaker : (customDestructor -> restCustomBuilders7) -> l
            , dictMaker : (restA6 -> restB6 -> restC3) -> m
            , fieldMaker :
                (String
                 -> getField
                 -> restFieldTools
                 -> restRecordBuilders2
                 -> restRecordBuilder2s
                )
                -> n
            , float : b2 -> o
            , int : b1 -> p
            , listMaker : (restA5 -> restB5) -> q
            , maybeMaker : (restA4 -> restB4) -> r
            , recordEnder : (restRecordBuilders1 -> restRecordSpecs) -> s
            , recordMaker : (recordConstructor -> restRecordBuilders) -> t
            , resultMaker : (restA3 -> restB3 -> restC2) -> u
            , setMaker : (restA2 -> restB2) -> v
            , string : b -> w
            , toolConstructor : x
            , toolMaker :
                y
                -> (tool1 -> multiToolConstructor)
                -> ( tool1, restTools )
                -> multiTool
            , tripleMaker : (restA1 -> restB1 -> restC1 -> restD) -> z
            , tupleMaker : (restA -> restB -> restC) -> c1
            , tweakConstructor : d1
            , tweakMaker :
                (tweakConstructor
                 -> ((() -> () -> ()) -> tweakFns -> tool -> tool)
                 -> restAfters
                 -> tweak
                )
                -> e1
            , variant0Maker :
                (String
                 -> variantConstructor5
                 -> restCustomBuilders6
                 -> restCustomBuilders2_5
                )
                -> f1
            , variant1Maker :
                (String
                 -> variantConstructor4
                 -> restArg1Tools4
                 -> restCustomBuilders5
                 -> restCustomBuilders2_4
                )
                -> g1
            , variant2Maker :
                (String
                 -> variantConstructor3
                 -> restArg1Tools3
                 -> restArg2Tools3
                 -> restCustomBuilders4
                 -> restCustomBuilders2_3
                )
                -> h1
            , variant3Maker :
                (String
                 -> variantConstructor2
                 -> restArg1Tools2
                 -> restArg2Tools2
                 -> restArg3Tools2
                 -> restCustomBuilders3
                 -> restCustomBuilders2_2
                )
                -> i1
            , variant4Maker :
                (String
                 -> variantConstructor1
                 -> restArg1Tools1
                 -> restArg2Tools1
                 -> restArg3Tools1
                 -> restArg4Tools1
                 -> restCustomBuilders1
                 -> restCustomBuilders2_1
                )
                -> j1
            , variant5Maker :
                (String
                 -> variantConstructor
                 -> restArg1Tools
                 -> restArg2Tools
                 -> restArg3Tools
                 -> restArg4Tools
                 -> restArg5Tools
                 -> restCustomBuilders
                 -> restCustomBuilders2
                )
                -> k1
            }
add getMatcher tool (Builder builder) =
    Builder
        { -- primitives
          string = \next -> builder.string (Tuple.pair tool.string next)
        , int = \next -> builder.int (Tuple.pair tool.int next)
        , bool = \next -> builder.bool (Tuple.pair tool.bool next)
        , float = \next -> builder.float (Tuple.pair tool.float next)
        , char = \next -> builder.char (Tuple.pair tool.char next)

        -- built-in combinators
        , listMaker = \next -> builder.listMaker (mapper tool.list next)
        , maybeMaker = \next -> builder.maybeMaker (mapper tool.maybe next)
        , arrayMaker = \next -> builder.arrayMaker (mapper tool.array next)
        , setMaker = \next -> builder.setMaker (mapper tool.set next)
        , dictMaker = \next -> builder.dictMaker (mapper2 tool.dict next)
        , resultMaker = \next -> builder.resultMaker (mapper2 tool.result next)
        , tupleMaker = \next -> builder.tupleMaker (mapper2 tool.tuple next)
        , tripleMaker = \next -> builder.tripleMaker (mapper3 tool.triple next)

        -- record combinators
        , recordMaker = \next -> builder.recordMaker (recordMaker tool.record next)
        , fieldMaker = \next -> builder.fieldMaker (fieldMaker tool.field next)
        , recordEnder = \next -> builder.recordEnder (recordEnder tool.endRecord next)

        -- custom type combinators
        , customMaker = \next -> builder.customMaker (customMaker (\matchers -> tool.customType (getMatcher matchers)) next)
        , variant0Maker = \next -> builder.variant0Maker (variant0Maker tool.variant0 next)
        , variant1Maker = \next -> builder.variant1Maker (variant1Maker tool.variant1 next)
        , variant2Maker = \next -> builder.variant2Maker (variant2Maker tool.variant2 next)
        , variant3Maker = \next -> builder.variant3Maker (variant3Maker tool.variant3 next)
        , variant4Maker = \next -> builder.variant4Maker (variant4Maker tool.variant4 next)
        , variant5Maker = \next -> builder.variant5Maker (variant5Maker tool.variant5 next)
        , customEnder = \next -> builder.customEnder (customEnder tool.endCustomType next)

        -- constructing the multitool
        , toolConstructor = builder.toolConstructor
        , toolMaker = \next -> toolMaker (builder.toolMaker next)

        -- constructing tweakers
        , before = \next -> builder.before ( Nothing, next )
        , after = ( Nothing, builder.after )
        , afters = ( builder.after, builder.afters )
        , tweakMaker = \next -> builder.tweakMaker (tweakMaker builder.before next)
        , applyTweakFn = \next -> mapper2 applyTweakFn (builder.applyTweakFn next)
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

This function converts a `MultiTool.Builder` into a record that contains all the
functions you'll need to create tool specifications (`ToolSpec`s) for the types
in your application. If you define a MultiTool like `tools` in the example
above, it'll give you access to the following `ToolSpecs` and helper functions:


## `ToolSpec`s for primitive types

We've got `tools.bool`, `tools.string`, `tools.int`, `tools.float`, and
`tools.char`.

For example:

    boolTool =
        tools.build tools.bool

    trueFact =
        boolTool.toString True == "True"


## `ToolSpec`s for common combinators

We've got `tools.maybe`, `tools.result`, `tools.list`, `tools.array`,
`tools.dict`, `tools.set`, `tools.tuple`, _and_ `tools.triple`.

For example:

    listBoolSpec =
        tools.list tools.bool

    tupleIntStringSpec =
        tools.tuple tools.int tools.string


## `ToolSpec`s for combinators for custom types

To define `ToolSpec`s for your own custom types, use `tools.customType`,
`tools.variant0`, `tools.variant1`, `tools.variant2`, `tools.variant3`,
`tools.variant4`, `tools.variant5`, and `tools.endCustomType`.

For example, if we really hated Elm's `Maybe` type and wanted it to be called
`Option` instead:

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

**Note**: You _must_ define the `match` function either in a `let-in` block
within your tool specification, or as a top-level function in one of your
modules. If you try and parameterise your tool specification to take a `match`
function as one of its arguments, it won't work - you'll get a compiler error.

The explanation for this is a bit beyond me, but I think it goes: "something
something `forall`, something something let-polymorphism."


## `ToolSpec`s for combinators for records

For records (and indeed any kind of "product" type), check out `tools.record`,
`tools.field`, and `tools.endRecord`.

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

`tools.tweak` allows you to alter (or replace) the tools contained within a
`ToolSpec`.

For example, if you're using `edkelly303/elm-any-type-forms`, you could
customise the `tools.string` and `tools.int` `ToolSpec`s like this:

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
        , applyTweakFn : applyTweakFn
        , arrayMaker : (() -> ()) -> ( thisA7, restA7 ) -> ( thisB7, restB7 )
        , before : before
        , bool : () -> toolSpec4
        , char : () -> toolSpec3
        , customEnder : (() -> ()) -> customBuilder7 -> customTypeSpec
        , customMaker :
            (customDestructor -> ())
            -> customDestructor
            -> ( customBuilder8, restCustomBuilders7 )
        , dictMaker :
            (() -> () -> ())
            -> ( thisA6, restA6 )
            -> ( thisB6, restB6 )
            -> ( thisC3, restC3 )
        , fieldMaker :
            (String -> getField -> () -> () -> ())
            -> String
            -> getField
            -> fieldSpec
            -> ( recordBuilder1, restRecordBuilders1 )
            -> ( recordBuilder2, restRecordBuilder2s )
        , float : () -> toolSpec2
        , int : () -> toolSpec1
        , listMaker : (() -> ()) -> ( thisA5, restA5 ) -> ( thisB5, restB5 )
        , maybeMaker : (() -> ()) -> ( thisA4, restA4 ) -> ( thisB4, restB4 )
        , recordEnder :
            (() -> ())
            -> ( recordBuilder3, restRecordBuilders2 )
            -> ( recordSpec, restRecordSpecs )
        , recordMaker :
            (recordConstructor -> ())
            -> recordConstructor
            -> ( recordBuilder, restRecordBuilders )
        , resultMaker :
            (() -> () -> ())
            -> ( thisA3, restA3 )
            -> ( thisB3, restB3 )
            -> ( thisC2, restC2 )
        , setMaker : (() -> ()) -> ( thisA2, restA2 ) -> ( thisB2, restB2 )
        , string : () -> toolSpec
        , toolConstructor : toolConstructor
        , toolMaker :
            (multiTool -> () -> multiTool)
            -> toolConstructor
            -> ( tool, restTools )
            -> multiTool
        , tripleMaker :
            (() -> () -> () -> ())
            -> ( thisA1, restA1 )
            -> ( thisB1, restB1 )
            -> ( thisC1, restC1 )
            -> ( thisD, restD )
        , tupleMaker :
            (() -> () -> ())
            -> ( thisA, restA )
            -> ( thisB, restB )
            -> ( thisC, restC )
        , tweakConstructor : tweakConstructor
        , tweakMaker :
            (tweak -> applyTweakFn -> () -> tweak)
            -> tweakConstructor
            -> applyTweakFn
            -> afters
            -> tweak
        , variant0Maker :
            (String -> variantConstructor5 -> () -> ())
            -> String
            -> variantConstructor5
            -> ( customBuilder6, restCustomBuilders6 )
            -> ( customBuilder2_5, restCustomBuilders2_5 )
        , variant1Maker :
            (String -> variantConstructor4 -> () -> () -> ())
            -> String
            -> variantConstructor4
            -> ( arg1Tool4, restArg1Tools4 )
            -> ( customBuilder5, restCustomBuilders5 )
            -> ( customBuilder2_4, restCustomBuilders2_4 )
        , variant2Maker :
            (String -> variantConstructor3 -> () -> () -> () -> ())
            -> String
            -> variantConstructor3
            -> ( arg1Tool3, restArg1Tools3 )
            -> ( arg2Tool3, restArg2Tools3 )
            -> ( customBuilder4, restCustomBuilders4 )
            -> ( customBuilder2_3, restCustomBuilders2_3 )
        , variant3Maker :
            (String -> variantConstructor2 -> () -> () -> () -> () -> ())
            -> String
            -> variantConstructor2
            -> ( arg1Tool2, restArg1Tools2 )
            -> ( arg2Tool2, restArg2Tools2 )
            -> ( arg3Tool2, restArg3Tools2 )
            -> ( customBuilder3, restCustomBuilders3 )
            -> ( customBuilder2_2, restCustomBuilders2_2 )
        , variant4Maker :
            (String -> variantConstructor1 -> () -> () -> () -> () -> () -> ())
            -> String
            -> variantConstructor1
            -> ( arg1Tool1, restArg1Tools1 )
            -> ( arg2Tool1, restArg2Tools1 )
            -> ( arg3Tool1, restArg3Tools1 )
            -> ( arg4Tool1, restArg4Tools1 )
            -> ( customBuilder1, restCustomBuilders1 )
            -> ( customBuilder2_1, restCustomBuilders2_1 )
        , variant5Maker :
            (String
             -> variantConstructor
             -> ()
             -> ()
             -> ()
             -> ()
             -> ()
             -> ()
             -> ()
            )
            -> String
            -> variantConstructor
            -> ( arg1Tool, restArg1Tools )
            -> ( arg2Tool, restArg2Tools )
            -> ( arg3Tool, restArg3Tools )
            -> ( arg4Tool, restArg4Tools )
            -> ( arg5Tool, restArg5Tools )
            -> ( customBuilder, restCustomBuilders )
            -> ( customBuilder2, restCustomBuilders2 )
        }
    ->
        { array : ToolSpec ( thisA7, restA7 ) -> ToolSpec ( thisB7, restB7 )
        , bool : ToolSpec toolSpec4
        , build : ToolSpec ( tool, restTools ) -> multiTool
        , char : ToolSpec toolSpec3
        , customType : customDestructor -> ( customBuilder8, restCustomBuilders7 )
        , dict :
            ToolSpec ( thisA6, restA6 )
            -> ToolSpec ( thisB6, restB6 )
            -> ToolSpec ( thisC3, restC3 )
        , endCustomType : customBuilder7 -> ToolSpec customTypeSpec
        , endRecord :
            ( recordBuilder3, restRecordBuilders2 )
            -> ToolSpec ( recordSpec, restRecordSpecs )
        , field :
            String
            -> getField
            -> ToolSpec fieldSpec
            -> ( recordBuilder1, restRecordBuilders1 )
            -> ( recordBuilder2, restRecordBuilder2s )
        , float : ToolSpec toolSpec2
        , int : ToolSpec toolSpec1
        , list : ToolSpec ( thisA5, restA5 ) -> ToolSpec ( thisB5, restB5 )
        , maybe : ToolSpec ( thisA4, restA4 ) -> ToolSpec ( thisB4, restB4 )
        , record : recordConstructor -> ( recordBuilder, restRecordBuilders )
        , result :
            ToolSpec ( thisA3, restA3 )
            -> ToolSpec ( thisB3, restB3 )
            -> ToolSpec ( thisC2, restC2 )
        , set : ToolSpec ( thisA2, restA2 ) -> ToolSpec ( thisB2, restB2 )
        , string : ToolSpec toolSpec
        , triple :
            ToolSpec ( thisA1, restA1 )
            -> ToolSpec ( thisB1, restB1 )
            -> ToolSpec ( thisC1, restC1 )
            -> ToolSpec ( thisD, restD )
        , tuple :
            ToolSpec ( thisA, restA )
            -> ToolSpec ( thisB, restB )
            -> ToolSpec ( thisC, restC )
        , tweak : tweak
        , variant0 :
            String
            -> variantConstructor5
            -> ( customBuilder6, restCustomBuilders6 )
            -> ( customBuilder2_5, restCustomBuilders2_5 )
        , variant1 :
            String
            -> variantConstructor4
            -> ToolSpec ( arg1Tool4, restArg1Tools4 )
            -> ( customBuilder5, restCustomBuilders5 )
            -> ( customBuilder2_4, restCustomBuilders2_4 )
        , variant2 :
            String
            -> variantConstructor3
            -> ToolSpec ( arg1Tool3, restArg1Tools3 )
            -> ToolSpec ( arg2Tool3, restArg2Tools3 )
            -> ( customBuilder4, restCustomBuilders4 )
            -> ( customBuilder2_3, restCustomBuilders2_3 )
        , variant3 :
            String
            -> variantConstructor2
            -> ToolSpec ( arg1Tool2, restArg1Tools2 )
            -> ToolSpec ( arg2Tool2, restArg2Tools2 )
            -> ToolSpec ( arg3Tool2, restArg3Tools2 )
            -> ( customBuilder3, restCustomBuilders3 )
            -> ( customBuilder2_2, restCustomBuilders2_2 )
        , variant4 :
            String
            -> variantConstructor1
            -> ToolSpec ( arg1Tool1, restArg1Tools1 )
            -> ToolSpec ( arg2Tool1, restArg2Tools1 )
            -> ToolSpec ( arg3Tool1, restArg3Tools1 )
            -> ToolSpec ( arg4Tool1, restArg4Tools1 )
            -> ( customBuilder1, restCustomBuilders1 )
            -> ( customBuilder2_1, restCustomBuilders2_1 )
        , variant5 :
            String
            -> variantConstructor
            -> ToolSpec ( arg1Tool, restArg1Tools )
            -> ToolSpec ( arg2Tool, restArg2Tools )
            -> ToolSpec ( arg3Tool, restArg3Tools )
            -> ToolSpec ( arg4Tool, restArg4Tools )
            -> ToolSpec ( arg5Tool, restArg5Tools )
            -> ( customBuilder, restCustomBuilders )
            -> ( customBuilder2, restCustomBuilders2 )
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
        \itemSpec ->
            map toolBuilder.listMaker itemSpec
    , array =
        \itemSpec ->
            map toolBuilder.arrayMaker itemSpec
    , set =
        \memberSpec ->
            map toolBuilder.setMaker memberSpec
    , dict =
        \keySpec valueSpec ->
            map2 toolBuilder.dictMaker keySpec valueSpec
    , maybe =
        \contentSpec ->
            map toolBuilder.maybeMaker contentSpec
    , result =
        \errorSpec valueSpec ->
            map2 toolBuilder.resultMaker errorSpec valueSpec
    , tuple =
        \firstSpec secondSpec ->
            map2 toolBuilder.tupleMaker firstSpec secondSpec
    , triple =
        \firstSpec secondSpec thirdSpec ->
            map3 toolBuilder.tripleMaker firstSpec secondSpec thirdSpec

    -- records
    , record =
        \recordConstructor ->
            doMakeRecord toolBuilder.recordMaker recordConstructor
    , field =
        \fieldName getField fieldSpec recordBuilder ->
            doMakeField toolBuilder.fieldMaker fieldName getField fieldSpec recordBuilder
    , endRecord =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder

    -- custom types
    , customType =
        \matchers ->
            doMakeCustom toolBuilder.customMaker matchers
    , variant0 =
        \variantName variantConstructor customBuilder ->
            doMakeVariant0 toolBuilder.variant0Maker variantName variantConstructor customBuilder
    , variant1 =
        \variantName variantConstructor arg1Spec customBuilder ->
            doMakeVariant1 toolBuilder.variant1Maker variantName variantConstructor arg1Spec customBuilder
    , variant2 =
        \variantName variantConstructor arg1Spec arg2Spec customBuilder ->
            doMakeVariant2 toolBuilder.variant2Maker variantName variantConstructor arg1Spec arg2Spec customBuilder
    , variant3 =
        \variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder ->
            doMakeVariant3 toolBuilder.variant3Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , variant4 =
        \variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder ->
            doMakeVariant4 toolBuilder.variant4Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , variant5 =
        \variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder ->
            doMakeVariant5 toolBuilder.variant5Maker variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder
    , endCustomType =
        \customBuilder ->
            doEndCustom toolBuilder.customEnder customBuilder

    -- turn a spec into a usable multiTool
    , build =
        doMakeTool toolBuilder.toolMaker toolBuilder.toolConstructor
    , tweak =
        doMakeTweak toolBuilder.tweakMaker toolBuilder.tweakConstructor toolBuilder.applyTweakFn toolBuilder.afters
    }


{-| A tool specification - the basic building block for creating tools for the
types in your application.
-}
type ToolSpec toolSpec
    = ToolSpec toolSpec


doMakeTool : ((multiTool -> () -> multiTool) -> toolConstructor -> ( tool, restTools ) -> multiTool) -> toolConstructor -> ToolSpec ( tool, restTools ) -> multiTool
doMakeTool toolMaker_ toolConstructor (ToolSpec ( tool, restTools )) =
    toolMaker_ (\output () -> output) toolConstructor ( tool, restTools )


toolMaker : (multiToolConstructor -> restTools -> multiTool) -> (tool -> multiToolConstructor) -> ( tool, restTools ) -> multiTool
toolMaker constructRestTools constructTool ( tool, restTools ) =
    constructRestTools (constructTool tool) restTools


doMakeTweak :
    ((tweak -> applyTweakFn -> () -> tweak) -> tweakConstructor -> applyTweakFn -> afters -> tweak)
    -> tweakConstructor
    -> applyTweakFn
    -> afters
    -> tweak
doMakeTweak tweakMaker_ tweakConstructor applyTweakFn_ afters =
    tweakMaker_ (\tweak _ () -> tweak) tweakConstructor applyTweakFn_ afters


tweakMaker :
    (( Maybe mapper, after ) -> tweakFns)
    -> (tweakConstructor -> ((() -> () -> ()) -> tweakFns -> tool -> tool) -> restAfters -> tweak)
    -> ((mapper -> ToolSpec tool -> ToolSpec tool) -> tweakConstructor)
    -> ((() -> () -> ()) -> tweakFns -> tool -> tool)
    -> ( after, restAfters )
    -> tweak
tweakMaker before next tweakConstructor applyTweakFn_ ( after, restAfters ) =
    let
        tweaker =
            \tweakFn (ToolSpec toolSpec) ->
                let
                    tweakFns =
                        before ( Just tweakFn, after )
                in
                applyTweakFn_ (\() () -> ()) tweakFns toolSpec
                    |> ToolSpec
    in
    next (tweakConstructor tweaker) applyTweakFn_ restAfters


applyTweakFn : Maybe (tool -> tool) -> tool -> tool
applyTweakFn maybeFn tool =
    case maybeFn of
        Just fn ->
            fn tool

        Nothing ->
            tool


map :
    ((() -> ()) -> ( thisA, restA ) -> ( thisB, restB ))
    -> ToolSpec ( thisA, restA )
    -> ToolSpec ( thisB, restB )
map mapper_ (ToolSpec ( this, rest )) =
    mapper_ (\() -> ()) ( this, rest )
        |> ToolSpec


mapper :
    (thisA -> thisB)
    -> (restA -> restB)
    -> ( thisA, restA )
    -> ( thisB, restB )
mapper mapThis mapRest ( this, rest ) =
    ( mapThis this
    , mapRest rest
    )


map2 :
    ((() -> () -> ())
     -> ( thisA, restA )
     -> ( thisB, restB )
     -> ( thisC, restC )
    )
    -> ToolSpec ( thisA, restA )
    -> ToolSpec ( thisB, restB )
    -> ToolSpec ( thisC, restC )
map2 mapper2_ (ToolSpec errors) (ToolSpec values) =
    mapper2_ (\() () -> ()) errors values
        |> ToolSpec


mapper2 :
    (thisA -> thisB -> thisC)
    -> (restA -> restB -> restC)
    -> ( thisA, restA )
    -> ( thisB, restB )
    -> ( thisC, restC )
mapper2 map2This map2Rest ( thisA, restA ) ( thisB, restB ) =
    ( map2This thisA thisB
    , map2Rest restA restB
    )


map3 :
    ((() -> () -> () -> ())
     -> ( thisA, restA )
     -> ( thisB, restB )
     -> ( thisC, restC )
     -> ( thisD, restD )
    )
    -> ToolSpec ( thisA, restA )
    -> ToolSpec ( thisB, restB )
    -> ToolSpec ( thisC, restC )
    -> ToolSpec ( thisD, restD )
map3 mapper3_ (ToolSpec a) (ToolSpec b) (ToolSpec c) =
    mapper3_ (\() () () -> ()) a b c
        |> ToolSpec


mapper3 :
    (thisA -> thisB -> thisC -> thisD)
    -> (restA -> restB -> restC -> restD)
    -> ( thisA, restA )
    -> ( thisB, restB )
    -> ( thisC, restC )
    -> ( thisD, restD )
mapper3 map3This map3Rest ( thisA, restAs ) ( thisB, restBs ) ( thisC, restCs ) =
    ( map3This thisA thisB thisC
    , map3Rest restAs restBs restCs
    )


doMakeRecord :
    ((recordConstructor -> ())
     -> recordConstructor
     -> ( recordBuilder, restRecordBuilders )
    )
    -> recordConstructor
    -> ( recordBuilder, restRecordBuilders )
doMakeRecord recordMaker_ recordConstructor =
    recordMaker_ (\_ -> ()) recordConstructor


recordMaker :
    (recordConstructor -> recordBuilder)
    -> (recordConstructor -> restRecordBuilders)
    -> recordConstructor
    -> ( recordBuilder, restRecordBuilders )
recordMaker record_ next recordConstructor =
    ( record_ recordConstructor
    , next recordConstructor
    )


doMakeField :
    ((String -> getField -> () -> () -> ())
     -> String
     -> getField
     -> fieldSpec
     -> ( recordBuilder, restRecordBuilders )
     -> ( recordBuilder2, restRecordBuilder2s )
    )
    -> String
    -> getField
    -> ToolSpec fieldSpec
    -> ( recordBuilder, restRecordBuilders )
    -> ( recordBuilder2, restRecordBuilder2s )
doMakeField fieldMaker_ fieldName getField (ToolSpec fieldSpec) recordBuilders =
    fieldMaker_ (\_ _ () () -> ()) fieldName getField fieldSpec recordBuilders


fieldMaker :
    (String -> getField -> fieldTool -> recordBuilder -> recordBuilder2)
    -> (String -> getField -> restFieldTools -> restRecordBuilders -> restRecordBuilder2s)
    -> String
    -> getField
    -> ( fieldTool, restFieldTools )
    -> ( recordBuilder, restRecordBuilders )
    -> ( recordBuilder2, restRecordBuilder2s )
fieldMaker field_ next fieldName getField ( fieldTool, restFieldTools ) ( builder, restBuilders ) =
    ( field_ fieldName getField fieldTool builder
    , next fieldName getField restFieldTools restBuilders
    )


doEndRecord :
    ((() -> ())
     -> ( recordBuilder, restRecordBuilders )
     -> ( recordSpec, restRecordSpecs )
    )
    -> ( recordBuilder, restRecordBuilders )
    -> ToolSpec ( recordSpec, restRecordSpecs )
doEndRecord recordEnder_ builder =
    recordEnder_ (\() -> ()) builder
        |> ToolSpec


recordEnder :
    (recordBuilder -> recordSpec)
    -> (restRecordBuilders -> restRecordSpecs)
    -> ( recordBuilder, restRecordBuilders )
    -> ( recordSpec, restRecordSpecs )
recordEnder endRecord_ next ( builder, restBuilders ) =
    ( endRecord_ builder
    , next restBuilders
    )


doMakeCustom :
    ((customDestructor -> ())
     -> customDestructor
     -> ( customBuilder, restCustomBuilders )
    )
    -> customDestructor
    -> ( customBuilder, restCustomBuilders )
doMakeCustom customMaker_ customDestructors =
    customMaker_ (\_ -> ()) customDestructors


customMaker :
    (customDestructor -> customBuilder)
    -> (customDestructor -> restCustomBuilders)
    -> customDestructor
    -> ( customBuilder, restCustomBuilders )
customMaker customType_ next customDestructors =
    ( customType_ customDestructors
    , next customDestructors
    )


doMakeVariant0 :
    ((String -> variantConstructor -> () -> ())
     -> String
     -> variantConstructor
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant0 variant0Maker_ variantName variantConstructor customBuilder =
    variant0Maker_ (\_ _ () -> ()) variantName variantConstructor customBuilder


variant0Maker :
    (String -> variantConstructor -> customBuilder -> customBuilder2)
    -> (String -> variantConstructor -> restCustomBuilders -> restCustomBuilders2)
    -> String
    -> variantConstructor
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant0Maker variant0_ next variantName variantConstructor ( customBuilder, restCustomBuilders ) =
    ( variant0_ variantName variantConstructor customBuilder
    , next variantName variantConstructor restCustomBuilders
    )


doMakeVariant1 :
    ((String -> variantConstructor -> () -> () -> ())
     -> String
     -> variantConstructor
     -> ( arg1Tool, restArg1Tools )
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ToolSpec ( arg1Tool, restArg1Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant1 variant1Maker_ variantName variantConstructor (ToolSpec arg1Spec) customBuilder =
    variant1Maker_ (\_ _ () () -> ()) variantName variantConstructor arg1Spec customBuilder


variant1Maker :
    (String -> variantConstructor -> arg1Tool -> customBuilder -> customBuilder2)
    -> (String -> variantConstructor -> restArg1Tools -> restCustomBuilders -> restCustomBuilders2)
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant1Maker variant1_ next variantName variantConstructor ( arg1Tool, restArg1Tools ) ( customBuilder, restCustomBuilders ) =
    ( variant1_ variantName variantConstructor arg1Tool customBuilder
    , next variantName variantConstructor restArg1Tools restCustomBuilders
    )


doMakeVariant2 :
    ((String -> variantConstructor -> () -> () -> () -> ())
     -> String
     -> variantConstructor
     -> ( arg1Tool, restArg1Tools )
     -> ( arg2Tool, restArg2Tools )
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ToolSpec ( arg1Tool, restArg1Tools )
    -> ToolSpec ( arg2Tool, restArg2Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant2 variant2Maker_ variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) customBuilder =
    variant2Maker_ (\_ _ () () () -> ()) variantName variantConstructor arg1Spec arg2Spec customBuilder


variant2Maker :
    (String
     -> variantConstructor
     -> arg1Tool
     -> arg2Tool
     -> customBuilder
     -> customBuilder2
    )
    ->
        (String
         -> variantConstructor
         -> restArg1Tools
         -> restArg2Tools
         -> restCustomBuilders
         -> restCustomBuilders2
        )
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( arg2Tool, restArg2Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant2Maker variant2_ next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( customBuilder, restCustomBuilders ) =
    ( variant2_ variantName variantConstructor arg1Spec arg2Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restCustomBuilders
    )


doMakeVariant3 :
    ((String -> variantConstructor -> () -> () -> () -> () -> ())
     -> String
     -> variantConstructor
     -> ( arg1Tool, restArg1Tools )
     -> ( arg2Tool, restArg2Tools )
     -> ( arg3Tool, restArg3Tools )
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ToolSpec ( arg1Tool, restArg1Tools )
    -> ToolSpec ( arg2Tool, restArg2Tools )
    -> ToolSpec ( arg3Tool, restArg3Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant3 variantMaker_ variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) customBuilder =
    variantMaker_ (\_ _ () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder


variant3Maker :
    (String
     -> variantConstructor
     -> arg1Tool
     -> arg2Tool
     -> arg3Tool
     -> customBuilder
     -> customBuilder2
    )
    ->
        (String
         -> variantConstructor
         -> restArg1Tools
         -> restArg2Tools
         -> restArg3Tools
         -> restCustomBuilders
         -> restCustomBuilders2
        )
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( arg2Tool, restArg2Tools )
    -> ( arg3Tool, restArg3Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant3Maker variant3_ next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( customBuilder, restCustomBuilders ) =
    ( variant3_ variantName variantConstructor arg1Spec arg2Spec arg3Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restCustomBuilders
    )


doMakeVariant4 :
    ((String -> variantConstructor -> () -> () -> () -> () -> () -> ())
     -> String
     -> variantConstructor
     -> ( arg1Tool, restArg1Tools )
     -> ( arg2Tool, restArg2Tools )
     -> ( arg3Tool, restArg3Tools )
     -> ( arg4Tool, restArg4Tools )
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ToolSpec ( arg1Tool, restArg1Tools )
    -> ToolSpec ( arg2Tool, restArg2Tools )
    -> ToolSpec ( arg3Tool, restArg3Tools )
    -> ToolSpec ( arg4Tool, restArg4Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant4 variantMaker_ variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) customBuilder =
    variantMaker_ (\_ _ () () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder


variant4Maker :
    (String
     -> variantConstructor
     -> arg1Tool
     -> arg2Tool
     -> arg3Tool
     -> arg4Tool
     -> customBuilder
     -> customBuilder2
    )
    ->
        (String
         -> variantConstructor
         -> restArg1Tools
         -> restArg2Tools
         -> restArg3Tools
         -> restArg4Tools
         -> restCustomBuilders
         -> restCustomBuilders2
        )
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( arg2Tool, restArg2Tools )
    -> ( arg3Tool, restArg3Tools )
    -> ( arg4Tool, restArg4Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant4Maker variant next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( customBuilder, restCustomBuilders ) =
    ( variant variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restC4s restCustomBuilders
    )


doMakeVariant5 :
    ((String -> variantConstructor -> () -> () -> () -> () -> () -> () -> ())
     -> String
     -> variantConstructor
     -> ( arg1Tool, restArg1Tools )
     -> ( arg2Tool, restArg2Tools )
     -> ( arg3Tool, restArg3Tools )
     -> ( arg4Tool, restArg4Tools )
     -> ( arg5Tool, restArg5Tools )
     -> ( customBuilder, restCustomBuilders )
     -> ( customBuilder2, restCustomBuilders2 )
    )
    -> String
    -> variantConstructor
    -> ToolSpec ( arg1Tool, restArg1Tools )
    -> ToolSpec ( arg2Tool, restArg2Tools )
    -> ToolSpec ( arg3Tool, restArg3Tools )
    -> ToolSpec ( arg4Tool, restArg4Tools )
    -> ToolSpec ( arg5Tool, restArg5Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
doMakeVariant5 variantMaker_ variantName variantConstructor (ToolSpec arg1Spec) (ToolSpec arg2Spec) (ToolSpec arg3Spec) (ToolSpec arg4Spec) (ToolSpec arg5Spec) customBuilder =
    variantMaker_ (\_ _ () () () () () () -> ()) variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder


variant5Maker :
    (String
     -> variantConstructor
     -> arg1Tool
     -> arg2Tool
     -> arg3Tool
     -> arg4Tool
     -> arg5Tool
     -> customBuilder
     -> customBuilder2
    )
    ->
        (String
         -> variantConstructor
         -> restArg1Tools
         -> restArg2Tools
         -> restArg3Tools
         -> restArg4Tools
         -> restArg5Tools
         -> restCustomBuilders
         -> restCustomBuilders2
        )
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( arg2Tool, restArg2Tools )
    -> ( arg3Tool, restArg3Tools )
    -> ( arg4Tool, restArg4Tools )
    -> ( arg5Tool, restArg5Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant5Maker variant next variantName variantConstructor ( arg1Spec, restC1s ) ( arg2Spec, restC2s ) ( arg3Spec, restC3s ) ( arg4Spec, restC4s ) ( arg5Spec, restC5s ) ( customBuilder, restCustomBuilders ) =
    ( variant variantName variantConstructor arg1Spec arg2Spec arg3Spec arg4Spec arg5Spec customBuilder
    , next variantName variantConstructor restC1s restC2s restC3s restC4s restC5s restCustomBuilders
    )


doEndCustom : ((() -> ()) -> customBuilder -> customTypeSpec) -> customBuilder -> ToolSpec customTypeSpec
doEndCustom customEnder_ customBuilder =
    customEnder_ (\() -> ()) customBuilder
        |> ToolSpec


customEnder :
    (customBuilder -> customTypeSpec)
    -> (restCustomBuilders -> restCustomTypeSpecs)
    -> ( customBuilder, restCustomBuilders )
    -> ( customTypeSpec, restCustomTypeSpecs )
customEnder endCustom_ next ( customBuilder, restCustomBuilders ) =
    ( endCustom_ customBuilder
    , next restCustomBuilders
    )
