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


doMakeRecord recordMaker_ recordConstructor =
    recordMaker_ (\_ -> {}) recordConstructor


recordMaker record_ next recordConstructor =
    ( record_ recordConstructor
    , next recordConstructor
    )


doMakeFields fieldMaker_ fieldName getField child recordBuilders =
    fieldMaker_ (\_ _ {} {} -> {}) fieldName getField child recordBuilders


fieldMaker field_ next fieldName getField ( child, restChilds ) ( builder, restBuilders ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders
    )


doEndRecord recordEnder_ builder =
    recordEnder_ (\{} -> {}) builder


recordEnder endRecord_ next ( builder, restBuilders ) =
    ( endRecord_ builder
    , next restBuilders
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
