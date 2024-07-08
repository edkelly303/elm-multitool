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
doMakeTool toolMaker_ toolConstructor builder =
    toolMaker_ (\output () -> output) toolConstructor builder


toolMaker : (toolConstructor -> restBuilders -> tool) -> (builder -> toolConstructor) -> ( builder, restBuilders ) -> tool
toolMaker next toolConstructor ( builder, restBuilders ) =
    next (toolConstructor builder) restBuilders


doMakeTweak :
    ((tweak -> applyMapper -> () -> tweak) -> tweakConstructor -> applyMapper -> afters -> tweak)
    -> tweakConstructor
    -> applyMapper
    -> afters
    -> tweak
doMakeTweak tweakMaker_ tweakConstructor applyMapper_ afters =
    tweakMaker_ (\tweak _ () -> tweak) tweakConstructor applyMapper_ afters


tweakMaker :
    (( Maybe mapper, after ) -> mappers)
    -> (tweakConstructor -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec) -> restAfters -> tweak)
    -> ((mapper -> ToolSpec toolSpec -> ToolSpec toolSpec) -> tweakConstructor)
    -> ((() -> () -> ()) -> mappers -> toolSpec -> toolSpec)
    -> ( after, restAfters )
    -> tweak
tweakMaker before next tweakConstructor applyMapper_ ( after, restAfters ) =
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
    next (tweakConstructor tweaker) applyMapper_ restAfters


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


doMakeRecord :
    ((recordConstructor -> ())
     -> recordConstructor
     -> recordBuilder
    )
    -> recordConstructor
    -> recordBuilder
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


doMakeFields :
    ((String -> getField -> () -> () -> ())
     -> String
     -> getField
     -> fieldSpec
     -> recordBuilder
     -> recordBuilder2
    )
    -> String
    -> getField
    -> fieldSpec
    -> recordBuilder
    -> recordBuilder2
doMakeFields fieldMaker_ fieldName getField fieldSpec recordBuilders =
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
    ((() -> ()) -> recordBuilder -> recordSpec)
    -> recordBuilder
    -> recordSpec
doEndRecord recordEnder_ builder =
    recordEnder_ (\() -> ()) builder


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
    ((customDestructor -> ()) -> customDestructor -> customBuilders)
    -> customDestructor
    -> customBuilders
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
    ((a -> b -> () -> ()) -> String -> variantConstructor -> customBuilder -> customBuilder2)
    -> String
    -> variantConstructor
    -> customBuilder
    -> customBuilder2
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
     -> arg1Spec
     -> customBuilder
     -> customBuilder2
    )
    -> String
    -> variantConstructor
    -> arg1Spec
    -> customBuilder
    -> customBuilder2
doMakeVariant1 variant1Maker_ variantName variantConstructor arg1Spec customBuilder =
    variant1Maker_ (\_ _ () () -> ()) variantName variantConstructor arg1Spec customBuilder


variant1Maker :
    (String -> variantConstructor -> arg1Tool -> customBuilder -> customBuilder2)
    -> (String -> variantConstructor -> restArg1Tools -> restCustomBuilders -> restCustomBuilders2)
    -> String
    -> variantConstructor
    -> ( arg1Tool, restArg1Tools )
    -> ( customBuilder, restCustomBuilders )
    -> ( customBuilder2, restCustomBuilders2 )
variant1Maker variant1_ next variantName variantConstructor ( arg1Spec, restArg1Specs ) ( customBuilder, restCustomBuilders ) =
    ( variant1_ variantName variantConstructor arg1Spec customBuilder
    , next variantName variantConstructor restArg1Specs restCustomBuilders
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


doEndCustom : ((() -> ()) -> customBuilder -> customTypeSpec) -> customBuilder -> customTypeSpec
doEndCustom customEnder_ customBuilder =
    customEnder_ (\() -> ()) customBuilder


customEnder :
    (customBuilder -> customTypeSpec)
    -> (restCustomBuilders -> restCustomTypeSpecs)
    -> ( customBuilder, restCustomBuilders )
    -> ( customTypeSpec, restCustomTypeSpecs )
customEnder endCustom_ next ( customBuilder, restCustomBuilders ) =
    ( endCustom_ customBuilder
    , next restCustomBuilders
    )
