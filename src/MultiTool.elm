module MultiTool exposing
    ( End(..)
    , add
    , define
    , end
    , matcher1
    , matcher2
    , matcher3
    , matcher4
    , matcher5
    )


matcher1 : a -> ( a, End )
matcher1 d1 =
    ( d1, End )


matcher2 : a -> b -> ( a, ( b, End ) )
matcher2 d1 d2 =
    ( d1, ( d2, End ) )


matcher3 : a -> b -> c -> ( a, ( b, ( c, End ) ) )
matcher3 d1 d2 d3 =
    ( d1, ( d2, ( d3, End ) ) )


matcher4 : a -> b -> c -> d -> ( a, ( b, ( c, ( d, End ) ) ) )
matcher4 d1 d2 d3 d4 =
    ( d1, ( d2, ( d3, ( d4, End ) ) ) )


matcher5 : a -> b -> c -> d -> e -> ( a, ( b, ( c, ( d, ( e, End ) ) ) ) )
matcher5 d1 d2 d3 d4 d5 =
    ( d1, ( d2, ( d3, ( d4, ( d5, End ) ) ) ) )


define constructor =
    { constructor = constructor

    -- primitives
    , string = identity
    , int = identity
    , bool = identity
    , float = identity
    , char = identity

    -- built-in combinators
    , list = identity
    , listMaker = identity

    -- , maybe = identity
    -- , array = identity
    -- , dict = identity
    -- , set = identity
    -- , tuple = identity
    -- , triple = identity
    -- , result = identity
    --
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
    , constructMultiTool = identity
    }


add tool builder =
    { constructor = builder.constructor

    -- primitives
    , string = builder.string << Tuple.pair tool.string
    , int = builder.int << Tuple.pair tool.int
    , bool = builder.bool << Tuple.pair tool.bool
    , float = builder.float << Tuple.pair tool.float
    , char = builder.char << Tuple.pair tool.char

    -- built-in combinators
    , list = builder.list << Tuple.pair tool.list
    , listMaker = builder.listMaker >> listMaker

    -- , maybe = builder.maybe << Tuple.pair tool.maybe
    -- , array = builder.array << Tuple.pair tool.array
    -- , dict = builder.dict << Tuple.pair tool.dict
    -- , set = builder.set << Tuple.pair tool.set
    -- , tuple = builder.tuple << Tuple.pair tool.tuple
    -- , triple = builder.triple << Tuple.pair tool.triple
    -- , result = builder.result << Tuple.pair tool.result
    --
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
        \customDestructor ->
            doMakeCustom toolBuilder.customMaker customDestructor customs
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


doMakeRecord recordMaker_ recordConstructor records =
    recordMaker_ (\_ End -> End) recordConstructor records


recordMaker next recordConstructor ( record_, records ) =
    ( record_ recordConstructor, next recordConstructor records )


doMakeFields fieldMaker_ fieldName getField child recordBuilders fields =
    fieldMaker_ (\_ _ End End End -> End) fieldName getField child recordBuilders fields


fieldMaker next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )


doEndRecord recordEnder_ builder endRecords =
    recordEnder_ (\End End -> End) builder endRecords


recordEnder next ( builder, restBuilders ) ( endRecord_, restEndRecords ) =
    ( endRecord_ builder, next restBuilders restEndRecords )


doMakeCustom customMaker_ customDestructor customs =
    customMaker_ (\End End -> End) customDestructor customs


customMaker next ( customDestructor, restCustomDestructors ) ( custom, restCustoms ) =
    ( custom customDestructor
    , next restCustomDestructors restCustoms
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
    ( endCustom customBuilder, next restCustomBuilders restEndCustoms )


doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output End -> output) ctor builder


constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
