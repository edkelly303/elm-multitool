module MultiTool exposing
    ( define
    , add
    , end
    )

{-| **Fun fact**: The type annotations for the functions in this package are pretty horrifying.

**Hot tip**: Ignore them! There's no need to put any of these functions, or the tools they produce, in your
application's `Msg` or `Model` type. So you don't need to know or care about what their type signatures are. Just read
the docs and look at the examples. It'll be fine.\*

\* Unless you make any kind of minor typo in your code, in which case the Elm compiler may respond with a Lovecraftian
error message 😱.


## `define`

@docs define


## `add`

@docs add


## `end`

@docs end

-}


{-|


### Begin a definition for a MultiTool.

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

**Note**: The order of the type parameters in the `Tools` definition is important. It needs to match the order in which
you add the tool interfaces with `MultiTool.add`.

In this example, we see that `toString` comes first and `toComparable` comes second in _both_ the `Tools` type alias and
the `tools` definition.

-}
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


### Add a tool to your MultiTool.

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

(You'll notice that this interface definition mostly looks straighforward, except for the `dict` field. The problem here
is that we need a `Dict` implementation that can take any `comparable` as a key, but `elm-codec`'s built-in `dict`
function only accepts `String`s as keys. Fortunately, we can build the function we need using `elm-codec`'s lower-level
primitives.)

The third and final argument is the data structure that you've already created using `define`. The API here is designed
for piping with the `|>` operator, so you'll usually want to apply this final argument like this:

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add .codec codecInterface

-}
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


### Complete the definition of a MultiTool.

    tools =
        MultiTool.define Tools Tools
            |> MultiTool.add
                .toString
                ToString.interface
            |> MultiTool.add
                .toComparable
                ToComparable.interface
            |> MultiTool.end

This function produces a MultiTool - a record that contains all the functions you'll need to create tool definitions for
the types in your application. If you define a MultiTool like `tools` in the example above, it'll give you access to the
following functions:


## Tool definitions for primitive types

We've got `tools.bool`, `tools.string`, `tools.int`, `tools.float`, and `tools.char`.

For example:

    boolTool =
        tools.build tools.bool

    trueFact =
        boolTool.toString True == "True"


## Tool definitions for common combinators

We've got `tools.maybe`, `tools.result`, `tools.list`, `tools.array`, `tools.dict`, `tools.set`, `tools.tuple`, _and_
`tools.triple`.

For example:

    listBoolDefinition =
        tools.list tools.bool

    tupleIntStringDefinition =
        tools.tuple tools.int tools.string


## Tool definitions for combinators for custom types

To define tools for your own custom types, use `tools.custom`, `tools.tag0`, `tools.tag1`, `tools.tag2`, `tools.tag3`,
`tools.tag4`, `tools.tag5`, and `tools.endCustom`.

For example, if we really hated Elm's `Maybe` type and wanted it to be called `Option` instead:

    type Option value
        = Some value
        | None

    optionDefinition valueDefinition =
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
            |> tools.tag1 "Some" Some valueDefinition
            |> tools.tag0 "None" None
            |> tools.endCustom

**Note**: You _must_ define the `match` function either in a `let-in` block within your tool definition, or as a
top-level function in one of your modules. If you try and parameterise your tool definition to take a `match` function
as one of its arguments, it won't work - you'll get a compiler error.

The explanation for this is a bit beyond me, but I think it goes: "something something `forall`, something something
let-polymorphism."


## Tool definitions for combinators for records

For records (and indeed any kind of "product" type), check out `tools.record`, `tools.field`, and `tools.endRecord`.

For example:

    type alias User =
        { name : String, age : Int }

    userToolDefinition =
        tools.record User
            |> tools.field "name" .name tools.string
            |> tools.field "age" .age tools.int
            |> tools.endRecord


## Converting a tool definition into a usable tool

`tools.build` turns a tool definition into a usable tool.

For example:

    userTool =
        tools.build userToolDefinition

    user =
        { name = "Ed", age = 41 }

    trueFact =
        userTool.toString user
            == "{ name = \"Ed\", age = 41 }"


### Customising a tool definition

`tools.tweak` allows you to alter or replace the default tool definitions specified in the tool's interface.

For example, if you've defined a MultiTool that includes an interface for using `edkelly303/elm-any-type-forms`, you
could customise the default `string` control like this:

    import Control

    myStringControl =
        tools.string
            |> tools.tweak.control (Control.debounce 1000)
            |> tools.tweak.control
                (Control.failIf
                    String.isEmpty
                    "Field can't be blank"
                )

-}
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
    , tag2 =
        \tagName tagConstructor c1 c2 customBuilder ->
            doMakeTag2 toolBuilder.tag2Maker tagName tagConstructor c1 c2 customBuilder tag2s
    , tag3 =
        \tagName tagConstructor c1 c2 c3 customBuilder ->
            doMakeTag3 toolBuilder.tag3Maker tagName tagConstructor c1 c2 c3 customBuilder tag3s
    , tag4 =
        \tagName tagConstructor c1 c2 c3 c4 customBuilder ->
            doMakeTag4 toolBuilder.tag4Maker tagName tagConstructor c1 c2 c3 c4 customBuilder tag4s
    , tag5 =
        \tagName tagConstructor c1 c2 c3 c4 c5 customBuilder ->
            doMakeTag5 toolBuilder.tag5Maker tagName tagConstructor c1 c2 c3 c4 c5 customBuilder tag5s
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



doMakeTag1 tag1Maker_ tagName tagConstructor child1 customBuilder tag1s =
    tag1Maker_ (\_ _ {} {} {} -> {}) tagName tagConstructor child1 customBuilder tag1s



tag1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( tag1, restTag1s ) =
    ( tag1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doMakeTag2 tag2Maker_ tagName tagConstructor c1 c2 customBuilder tag2s =
    tag2Maker_ (\_ _ {} {} {} {} -> {}) tagName tagConstructor c1 c2 customBuilder tag2s


tag2Maker next tagName tagConstructor ( c1, restC1s ) ( c2, restC2s ) ( customBuilder, restCustomBuilders ) ( tag2, restTag2s ) =
    ( tag2 tagName tagConstructor c1 c2 customBuilder
    , next tagName tagConstructor restC1s restC2s restCustomBuilders restTag2s
    )

doMakeTag3 tagMaker_ tagName tagConstructor c1 c2 c3 customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} -> {}) tagName tagConstructor c1 c2 c3 customBuilder tags


tag3Maker next tagName tagConstructor ( c1, restC1s ) ( c2, restC2s ) ( c3, restC3s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor c1 c2 c3 customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restCustomBuilders restTags
    )

doMakeTag4 tagMaker_ tagName tagConstructor c1 c2 c3 c4 customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} -> {}) tagName tagConstructor c1 c2 c3 c4 customBuilder tags


tag4Maker next tagName tagConstructor ( c1, restC1s ) ( c2, restC2s ) ( c3, restC3s ) ( c4, restC4s ) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor c1 c2 c3 c4 customBuilder
    , next tagName tagConstructor restC1s restC2s restC3s restC4s restCustomBuilders restTags
    )

doMakeTag5 tagMaker_ tagName tagConstructor c1 c2 c3 c4 c5 customBuilder tags =
    tagMaker_ (\_ _ {} {} {} {} {} {} {} -> {}) tagName tagConstructor c1 c2 c3 c4 c5 customBuilder tags


tag5Maker next tagName tagConstructor ( c1, restC1s ) ( c2, restC2s ) ( c3, restC3s ) ( c4, restC4s ) (c5, restC5s) ( customBuilder, restCustomBuilders ) ( tag, restTags ) =
    ( tag tagName tagConstructor c1 c2 c3 c4 c5 customBuilder
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
