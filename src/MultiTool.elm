module MultiTool exposing
    ( add
    , define
    , end
    )


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
