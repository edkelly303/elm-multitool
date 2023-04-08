module MultiTool exposing (..)


defineTool ctor =
    { ctor = ctor
    , record = identity
    , field = identity
    , end = identity
    , string = identity
    , int = identity
    , bool = identity
    , fieldMapper = identity
    , ender = identity
    , outputter = identity
    , ctorer = identity
    }


add tool builder =
    { ctor = builder.ctor
    , record = builder.record << Tuple.pair tool.record
    , field = builder.field << Tuple.pair tool.field
    , end = builder.end << Tuple.pair tool.end
    , string = builder.string << Tuple.pair tool.string
    , int = builder.int << Tuple.pair tool.int
    , bool = builder.bool << Tuple.pair tool.bool
    , fieldMapper = builder.fieldMapper >> fieldMapper
    , ender = builder.ender >> ender
    , outputter = builder.outputter >> outputter
    , ctorer = builder.ctorer >> ctorer
    }


type End
    = End


endTool builder =
    let
        records =
            builder.record End

        fields =
            builder.field End

        ends =
            builder.end End

        strings =
            builder.string End

        ints =
            builder.int End

        bools =
            builder.bool End
    in
    { record =
        \ctor ->
            recordCtorer builder.ctorer ctor records
    , field =
        \fieldName getField child bldr ->
            fieldMap3 builder.fieldMapper fieldName getField child bldr fields
    , end =
        \bldr ->
            end builder.ender bldr ends
    , build =
        \bldr ->
            makeOutput builder.outputter builder.ctor bldr
    , string = strings
    , int = ints
    , bool = bools
    }


recordCtorer ctorer_ ctor recs =
    ctorer_ (\_ End -> End) ctor recs


ctorer next ctor ( rec, recs ) =
    ( rec ctor, next ctor recs )


makeOutput outputter_ ctor builder =
    outputter_ (\output End -> output) ctor builder


outputter next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders


end ender_ builder ends =
    ender_ (\End End -> End) builder ends


ender next ( builder, restBuilders ) ( end_, restEnds ) =
    ( end_ builder, next restBuilders restEnds )


fieldMap3 mapper fieldName getField child bldr fields =
    mapper (\_ _ End End End -> End) fieldName getField child bldr fields


fieldMapper next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )
