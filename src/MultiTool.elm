module MultiTool exposing (add, define, end)


define constructor =
    { constructor = constructor
    , record = identity
    , field = identity
    , end = identity
    , string = identity
    , int = identity
    , bool = identity
    , recordMaker = identity
    , fieldMaker = identity
    , recordEnder = identity
    , constructMultiTool = identity
    }


add tool builder =
    { constructor = builder.constructor
    , record = builder.record << Tuple.pair tool.record
    , field = builder.field << Tuple.pair tool.field
    , end = builder.end << Tuple.pair tool.end
    , string = builder.string << Tuple.pair tool.string
    , int = builder.int << Tuple.pair tool.int
    , bool = builder.bool << Tuple.pair tool.bool
    , recordMaker = builder.recordMaker >> recordMaker
    , fieldMaker = builder.fieldMaker >> fieldMaker
    , recordEnder = builder.recordEnder >> recordEnder
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

        ends =
            toolBuilder.end End

        strings =
            toolBuilder.string End

        ints =
            toolBuilder.int End

        bools =
            toolBuilder.bool End
    in
    { record =
        \recordConstructor ->
            doMakeRecord toolBuilder.recordMaker recordConstructor records
    , field =
        \fieldName getField child recordBuilder ->
            doMakeFields toolBuilder.fieldMaker fieldName getField child recordBuilder fields
    , end =
        \recordBuilder ->
            doEndRecord toolBuilder.recordEnder recordBuilder ends
    , build =
        \typeBuilder ->
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.constructor typeBuilder
    , string = strings
    , int = ints
    , bool = bools
    }


doMakeRecord recordMaker_ recordConstructor records =
    recordMaker_ (\_ End -> End) recordConstructor records


recordMaker next recordConstructor ( record_, records ) =
    ( record_ recordConstructor, next recordConstructor records )


doEndRecord recordEnder_ builder ends =
    recordEnder_ (\End End -> End) builder ends


recordEnder next ( builder, restBuilders ) ( end_, restEnds ) =
    ( end_ builder, next restBuilders restEnds )


doMakeFields mapper fieldName getField child bldr fields =
    mapper (\_ _ End End End -> End) fieldName getField child bldr fields


fieldMaker next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )


doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output End -> output) ctor builder


constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
