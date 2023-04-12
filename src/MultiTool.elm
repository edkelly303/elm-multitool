module MultiTool exposing
    ( End(..)
    , add
    , define
    , end
    )


define constructor =
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

    -- xxx
    , constructor = constructor
    , destructorFieldGetter = identity
    , constructMultiTool = identity
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

    -- xxx
    , constructor = builder.constructor
    , destructorFieldGetter = builder.destructorFieldGetter << Tuple.pair destructorFieldGetter
    , constructMultiTool = builder.constructMultiTool >> constructMultiTool
    }


type End
    = End


end toolBuilder =
    let
        -- primitives
        strings =
            toolBuilder.string End

        ints =
            toolBuilder.int End

        bools =
            toolBuilder.bool End

        floats =
            toolBuilder.float End

        chars =
            toolBuilder.char End

        -- built-in combinators
        lists =
            toolBuilder.list End

        maybes =
            toolBuilder.maybe End

        arrays =
            toolBuilder.array End

        dicts =
            toolBuilder.dict End

        sets =
            toolBuilder.set End

        tuples =
            toolBuilder.tuple End

        triples =
            toolBuilder.triple End

        results =
            toolBuilder.result End

        -- record combinators
        records =
            toolBuilder.record End

        fields =
            toolBuilder.field End

        endRecords =
            toolBuilder.endRecord End

        -- custom type combinators
        customs =
            toolBuilder.custom End

        tag0s =
            toolBuilder.tag0 End

        tag1s =
            toolBuilder.tag1 End

        endCustoms =
            toolBuilder.endCustom End

        destructorFieldGetters =
            toolBuilder.destructorFieldGetter End
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
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.constructor toolDefinition
    }


doMakeList listMaker_ listChildren_ lists_ =
    listMaker_ (\End End -> End) listChildren_ lists_


listMaker next ( listChild, restListChildren ) ( list_, restLists ) =
    ( list_ listChild
    , next restListChildren restLists
    )


doMakeMaybe maybeMaker_ maybeContents_ maybes_ =
    maybeMaker_ (\End End -> End) maybeContents_ maybes_


maybeMaker next ( maybeContent, restMaybeContents ) ( maybe_, restMaybes ) =
    ( maybe_ maybeContent
    , next restMaybeContents restMaybes
    )


doMakeArray maker_ contents_ containers_ =
    maker_ (\End End -> End) contents_ containers_


arrayMaker next ( content, restContents ) ( array_, restArrays ) =
    ( array_ content
    , next restContents restArrays
    )


doMakeDict dictMaker_ keys_ values_ dicts_ =
    dictMaker_ (\End End End -> End) keys_ values_ dicts_


dictMaker next ( key_, restKeys ) ( value_, restValues ) ( dict_, restDicts ) =
    ( dict_ key_ value_
    , next restKeys restValues restDicts
    )


doMakeSet setMaker_ contents_ sets =
    setMaker_ (\End End -> End) contents_ sets


setMaker next ( content, restContents ) ( set_, restSets ) =
    ( set_ content
    , next restContents restSets
    )


doMakeTuple tupleMaker_ a b tuples =
    tupleMaker_ (\End End End -> End) a b tuples


tupleMaker next ( a, restAs ) ( b, restBs ) ( tuple_, restTuples ) =
    ( tuple_ a b
    , next restAs restBs restTuples
    )


doMakeTriple tripleMaker_ a b c triples =
    tripleMaker_ (\End End End End -> End) a b c triples


tripleMaker next ( a, restAs ) ( b, restBs ) ( c, restCs ) ( triple, restTriples ) =
    ( triple a b c
    , next restAs restBs restCs restTriples
    )


doMakeResult resultMaker_ errors values results =
    resultMaker_ (\End End End -> End) errors values results


resultMaker next ( error, restErrors ) ( value, restValues ) ( result, restResults ) =
    ( result error value
    , next restErrors restValues restResults
    )


doMakeRecord recordMaker_ recordConstructor records =
    recordMaker_ (\_ End -> End) recordConstructor records


recordMaker next recordConstructor ( record_, records ) =
    ( record_ recordConstructor
    , next recordConstructor records
    )


doMakeFields fieldMaker_ fieldName getField child recordBuilders fields =
    fieldMaker_ (\_ _ End End End -> End) fieldName getField child recordBuilders fields


fieldMaker next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )


doEndRecord recordEnder_ builder endRecords =
    recordEnder_ (\End End -> End) builder endRecords


recordEnder next ( builder, restBuilders ) ( endRecord_, restEndRecords ) =
    ( endRecord_ builder
    , next restBuilders restEndRecords
    )


doMakeCustom customMaker_ customDestructors destructorFieldGetters customs =
    customMaker_ (\_ End End -> End) customDestructors destructorFieldGetters customs


customMaker next customDestructors ( destructorFieldGetter, restDestructorFieldGetters ) ( custom, restCustoms ) =
    ( custom (destructorFieldGetter customDestructors)
    , next customDestructors restDestructorFieldGetters restCustoms
    )


doMakeTag0 tag0Maker_ tagName tagConstructor customBuilder tag0s =
    tag0Maker_ (\_ _ End End -> End) tagName tagConstructor customBuilder tag0s


tag0Maker next tagName tagConstructor ( customBuilder, restCustomBuilders ) ( tag0, restTag0s ) =
    ( tag0 tagName tagConstructor customBuilder
    , next tagName tagConstructor restCustomBuilders restTag0s
    )


doMakeTag1 tag1Maker_ tagName tagConstructor child1 customBuilder tag1s =
    tag1Maker_ (\_ _ _ End End -> End) tagName tagConstructor child1 customBuilder tag1s


tag1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( tag1, restTag1s ) =
    ( tag1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doEndCustom customEnder_ customBuilder endCustoms =
    customEnder_ (\End End -> End) customBuilder endCustoms


customEnder next ( customBuilder, restCustomBuilders ) ( endCustom, restEndCustoms ) =
    ( endCustom customBuilder
    , next restCustomBuilders restEndCustoms
    )


doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output End -> output) ctor builder


constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
