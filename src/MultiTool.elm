module MultiTool exposing (add, define, end)

import Html.Events exposing (custom)


define constructor =
    { constructor = constructor

    --data
    , record = identity
    , field = identity
    , endRecord = identity
    , custom = identity
    , tag0 = identity
    , tag1 = identity
    , endCustom = identity
    , string = identity
    , int = identity
    , bool = identity

    -- functions
    , recordMaker = identity
    , fieldMaker = identity
    , recordEnder = identity
    , customMaker = identity
    , tag0Maker = identity
    , tag1Maker = identity
    , customEnder = identity
    , constructMultiTool = identity
    }


add tool builder =
    { constructor = builder.constructor
    , record = builder.record << Tuple.pair tool.record
    , field = builder.field << Tuple.pair tool.field
    , endRecord = builder.endRecord << Tuple.pair tool.endRecord
    , custom = builder.custom << Tuple.pair tool.custom
    , tag0 = builder.tag0 << Tuple.pair tool.tag0
    , tag1 = builder.tag1 << Tuple.pair tool.tag1
    , endCustom = builder.endCustom << Tuple.pair tool.endCustom
    , string = builder.string << Tuple.pair tool.string
    , int = builder.int << Tuple.pair tool.int
    , bool = builder.bool << Tuple.pair tool.bool
    , recordMaker = builder.recordMaker >> recordMaker
    , fieldMaker = builder.fieldMaker >> fieldMaker
    , recordEnder = builder.recordEnder >> recordEnder
    , customMaker = builder.customMaker >> customMaker
    , tag0Maker = builder.tag0Maker >> tag0Maker
    , tag1Maker = builder.tag1Maker >> tag1Maker
    , customEnder = builder.customEnder >> customEnder
    , constructMultiTool = builder.constructMultiTool >> constructMultiTool
    }


type End
    = End


end toolBuilder =
    let
        records =
            toolBuilder.record End

        fields =
            toolBuilder.field End

        endRecords =
            toolBuilder.endRecord End

        customs =
            toolBuilder.custom End

        tag0s =
            toolBuilder.tag0 End

        tag1s =
            toolBuilder.tag1 End

        endCustoms =
            toolBuilder.endCustom End

        strings =
            toolBuilder.string End

        ints =
            toolBuilder.int End

        bools =
            toolBuilder.bool End
    in
    -- multiTool defs for records
    { record =
        \recordConstructor ->
            doMakeRecord toolBuilder.recordMaker recordConstructor records
    , field =
        \fieldName getField child recordBuilder ->
            doMakeFields toolBuilder.fieldMaker fieldName getField child recordBuilder fields
    , endRecord =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder endRecords

    -- multiTool defs for custom types
    , custom = \customDestructor -> doMakeCustom toolBuilder.customMaker customDestructor customs
    , tag0 = \tagName tagConstructor -> doMakeTag0 toolBuilder.tag0Maker tagName tagConstructor tag0s
    , tag1 = \tagName tagConstructor child1 -> doMakeTag1 toolBuilder.tag0Maker tagName tagConstructor child1 tag1s
    , endCustom = \customBuilder -> doEndCustom toolBuilder.customEnder customBuilder endCustoms

    -- multiTool defs for primitive types
    , string = strings
    , int = ints
    , bool = bools

    -- turn a multiTool definition into a usable multiTool
    , build =
        \typeBuilder ->
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.constructor typeBuilder
    }


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
    customMaker_ (\_ End -> End) customDestructor customs


customMaker next customDestructor ( custom, restCustoms ) =
    ( custom customDestructor
    , next customDestructor restCustoms
    )


doMakeTag0 tag0Maker_ tagName tagConstructor tag0s =
    ()


tag0Maker next tagName tagConstructor ( tag0, restTag0s ) =
    ()


doMakeTag1 tag1Maker_ tagName tagConstructor child1 tag1s =
    ()


tag1Maker next tagName tagConstructor child1 ( tag1, restTag1s ) =
    ()


doEndCustom customEnder_ builder endCustoms =
    ()


customEnder next builder ( endCustom, restEndCustoms ) =
    ()


doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output End -> output) ctor builder


constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
