module MultiTool exposing
    ( add
    , define
    , end
    )


define :
    constructor
    ->
        { array : a36 -> a36
        , arrayMaker : a35 -> a35
        , bool : a34 -> a34
        , char : a33 -> a33
        , constructMultiTool : a32 -> a32
        , constructor : constructor
        , custom : a31 -> a31
        , customEnder : a30 -> a30
        , customMaker : a29 -> a29
        , destructorFieldGetter : a28 -> a28
        , dict : a27 -> a27
        , dictMaker : a26 -> a26
        , endCustom : a25 -> a25
        , endRecord : a24 -> a24
        , field : a23 -> a23
        , fieldMaker : a22 -> a22
        , float : a21 -> a21
        , int : a20 -> a20
        , list : a19 -> a19
        , listMaker : a18 -> a18
        , maybe : a17 -> a17
        , maybeMaker : a16 -> a16
        , record : a15 -> a15
        , recordEnder : a14 -> a14
        , recordMaker : a13 -> a13
        , result : a12 -> a12
        , resultMaker : a11 -> a11
        , set : a10 -> a10
        , setMaker : a9 -> a9
        , string : a8 -> a8
        , tag0 : a7 -> a7
        , tag0Maker : a6 -> a6
        , tag1 : a5 -> a5
        , tag1Maker : a4 -> a4
        , triple : a3 -> a3
        , tripleMaker : a2 -> a2
        , tuple : a1 -> a1
        , tupleMaker : a -> a
        }
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


add :
    destructorFieldGetter
    ->
        { array : a57
        , bool : a56
        , char : a55
        , custom : a54
        , dict : a52
        , endCustom : a51
        , endRecord : a50
        , field : a49
        , float : a48
        , int : a47
        , list : a46
        , maybe : a45
        , record : a44
        , result : a43
        , set : a42
        , string : a41
        , tag0 : a40
        , tag1 : a39
        , triple : a38
        , tuple : a37
        }
    ->
        { array : ( a57, a36 ) -> c20
        , arrayMaker : a35 -> d -> e -> f
        , bool : ( a56, a34 ) -> c19
        , char : ( a55, a33 ) -> c18
        , constructMultiTool : a32 -> g -> h -> i
        , constructor : j
        , custom : ( a54, a31 ) -> c17
        , customEnder : a30 -> k -> l -> m
        , customMaker : a29 -> n -> o -> p -> q
        , destructorFieldGetter : ( destructorFieldGetter, a28 ) -> c16
        , dict : ( a52, a27 ) -> c15
        , dictMaker : a26 -> r -> s -> t -> u
        , endCustom : ( a51, a25 ) -> c14
        , endRecord : ( a50, a24 ) -> c13
        , field : ( a49, a23 ) -> c12
        , fieldMaker : a22 -> v -> w -> x -> y -> z -> b1
        , float : ( a48, a21 ) -> c11
        , int : ( a47, a20 ) -> c10
        , list : ( a46, a19 ) -> c9
        , listMaker : a18 -> d1 -> e1 -> f1
        , maybe : ( a45, a17 ) -> c8
        , maybeMaker : a16 -> g1 -> h1 -> i1
        , record : ( a44, a15 ) -> c7
        , recordEnder : a14 -> j1 -> k1 -> l1
        , recordMaker : a13 -> m1 -> n1 -> o1
        , result : ( a43, a12 ) -> c6
        , resultMaker : a11 -> p1 -> q1 -> r1 -> s1
        , set : ( a42, a10 ) -> c5
        , setMaker : a9 -> t1 -> u1 -> v1
        , string : ( a41, a8 ) -> c4
        , tag0 : ( a40, a7 ) -> c3
        , tag0Maker : a6 -> w1 -> x1 -> y1 -> z1 -> b2
        , tag1 : ( a39, a5 ) -> c2
        , tag1Maker : a4 -> d2 -> e2 -> f2 -> g2 -> h2 -> i2
        , triple : ( a38, a3 ) -> c1
        , tripleMaker : a2 -> j2 -> k2 -> l2 -> m2 -> n2
        , tuple : ( a37, a1 ) -> c
        , tupleMaker : a -> o2 -> p2 -> q2 -> r2
        }
    ->
        { array : a36 -> c20
        , arrayMaker : a35 -> ( t2, d ) -> ( t2 -> u2, e ) -> ( u2, f )
        , bool : a34 -> c19
        , char : a33 -> c18
        , constructMultiTool : a32 -> (v2 -> g) -> ( v2, h ) -> i
        , constructor : j
        , custom : a31 -> c17
        , customEnder : a30 -> ( w2, k ) -> ( w2 -> x2, l ) -> ( x2, m )
        , customMaker : a29 -> n -> ( n -> y2, o ) -> ( y2 -> z2, p ) -> ( z2, q )
        , destructorFieldGetter : a28 -> c16
        , dict : a27 -> c15
        , dictMaker :
            a26 -> ( b3, r ) -> ( d3, s ) -> ( b3 -> d3 -> e3, t ) -> ( e3, u )
        , endCustom : a25 -> c14
        , endRecord : a24 -> c13
        , field : a23 -> c12
        , fieldMaker :
            a22
            -> v
            -> w
            -> ( f3, x )
            -> ( g3, y )
            -> ( v -> w -> f3 -> g3 -> h3, z )
            -> ( h3, b1 )
        , float : a21 -> c11
        , int : a20 -> c10
        , list : a19 -> c9
        , listMaker : a18 -> ( i3, d1 ) -> ( i3 -> j3, e1 ) -> ( j3, f1 )
        , maybe : a17 -> c8
        , maybeMaker : a16 -> ( k3, g1 ) -> ( k3 -> l3, h1 ) -> ( l3, i1 )
        , record : a15 -> c7
        , recordEnder : a14 -> ( m3, j1 ) -> ( m3 -> n3, k1 ) -> ( n3, l1 )
        , recordMaker : a13 -> m1 -> ( m1 -> o3, n1 ) -> ( o3, o1 )
        , result : a12 -> c6
        , resultMaker :
            a11 -> ( p3, p1 ) -> ( q3, q1 ) -> ( p3 -> q3 -> r3, r1 ) -> ( r3, s1 )
        , set : a10 -> c5
        , setMaker : a9 -> ( s3, t1 ) -> ( s3 -> t3, u1 ) -> ( t3, v1 )
        , string : a8 -> c4
        , tag0 : a7 -> c3
        , tag0Maker :
            a6
            -> w1
            -> x1
            -> ( u3, y1 )
            -> ( w1 -> x1 -> u3 -> v3, z1 )
            -> ( v3, b2 )
        , tag1 : a5 -> c2
        , tag1Maker :
            a4
            -> d2
            -> e2
            -> ( w3, f2 )
            -> ( x3, g2 )
            -> ( d2 -> e2 -> w3 -> x3 -> y3, h2 )
            -> ( y3, i2 )
        , triple : a3 -> c1
        , tripleMaker :
            a2
            -> ( z3, j2 )
            -> ( b4, k2 )
            -> ( d4, l2 )
            -> ( z3 -> b4 -> d4 -> e4, m2 )
            -> ( e4, n2 )
        , tuple : a1 -> c
        , tupleMaker :
            a -> ( f4, o2 ) -> ( g4, p2 ) -> ( f4 -> g4 -> h4, q2 ) -> ( h4, r2 )
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



end :
    { array : {} -> a
    , arrayMaker : ({} -> {} -> {}) -> b -> a -> c
    , bool : {} -> d
    , char : {} -> e
    , constructMultiTool : (f -> {} -> f) -> g -> h -> i
    , constructor : g
    , custom : {} -> j
    , customEnder : ({} -> {} -> {}) -> k -> l -> m
    , customMaker : (n -> {} -> {} -> {}) -> o -> p -> j -> q
    , destructorFieldGetter : {} -> p
    , dict : {} -> r
    , dictMaker : ({} -> {} -> {} -> {}) -> s -> t -> r -> u
    , endCustom : {} -> l
    , endRecord : {} -> v
    , field : {} -> w
    , fieldMaker :
        (x -> y -> {} -> {} -> {} -> {}) -> z -> a1 -> b1 -> c1 -> w -> d1
    , float : {} -> e1
    , int : {} -> f1
    , list : {} -> g1
    , listMaker : ({} -> {} -> {}) -> h1 -> g1 -> i1
    , maybe : {} -> j1
    , maybeMaker : ({} -> {} -> {}) -> k1 -> j1 -> l1
    , record : {} -> m1
    , recordEnder : ({} -> {} -> {}) -> n1 -> v -> o1
    , recordMaker : (p1 -> {} -> {}) -> q1 -> m1 -> r1
    , result : {} -> s1
    , resultMaker : ({} -> {} -> {} -> {}) -> t1 -> u1 -> s1 -> v1
    , set : {} -> w1
    , setMaker : ({} -> {} -> {}) -> x1 -> w1 -> y1
    , string : {} -> z1
    , tag0 : {} -> a2
    , tag0Maker : (b2 -> c2 -> {} -> {} -> {}) -> d2 -> e2 -> f2 -> a2 -> g2
    , tag1 : {} -> h2
    , tag1Maker :
        (i2 -> j2 -> k2 -> {} -> {} -> {})
        -> l2
        -> m2
        -> n2
        -> o2
        -> h2
        -> p2
    , triple : {} -> q2
    , tripleMaker :
        ({} -> {} -> {} -> {} -> {}) -> r2 -> s2 -> t2 -> q2 -> u2
    , tuple : {} -> v2
    , tupleMaker : ({} -> {} -> {} -> {}) -> w2 -> x2 -> v2 -> y2
    }
    ->
        { array : b -> c
        , bool : d
        , build : h -> i
        , char : e
        , custom : o -> q
        , dict : s -> t -> u
        , endCustom : k -> m
        , endRecord : n1 -> o1
        , field : z -> a1 -> b1 -> c1 -> d1
        , float : e1
        , int : f1
        , list : h1 -> i1
        , maybe : k1 -> l1
        , record : q1 -> r1
        , result : t1 -> u1 -> v1
        , set : x1 -> y1
        , string : z1
        , tag0 : d2 -> e2 -> f2 -> g2
        , tag1 : l2 -> m2 -> n2 -> o2 -> p2
        , triple : r2 -> s2 -> t2 -> u2
        , tuple : w2 -> x2 -> y2
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
            doConstructMultiTool toolBuilder.constructMultiTool toolBuilder.constructor toolDefinition
    }


doMakeList listMaker_ listChildren_ lists_ =
    listMaker_ (\{} {} -> {}) listChildren_ lists_


listMaker next ( listChild, restListChildren ) ( list_, restLists ) =
    ( list_ listChild
    , next restListChildren restLists
    )


doMakeMaybe maybeMaker_ maybeContents_ maybes_ =
    maybeMaker_ (\{} {} -> {}) maybeContents_ maybes_


maybeMaker next ( maybeContent, restMaybeContents ) ( maybe_, restMaybes ) =
    ( maybe_ maybeContent
    , next restMaybeContents restMaybes
    )


doMakeArray maker_ contents_ containers_ =
    maker_ (\{} {} -> {}) contents_ containers_


arrayMaker next ( content, restContents ) ( array_, restArrays ) =
    ( array_ content
    , next restContents restArrays
    )


doMakeDict dictMaker_ keys_ values_ dicts_ =
    dictMaker_ (\{} {} {} -> {}) keys_ values_ dicts_


dictMaker next ( key_, restKeys ) ( value_, restValues ) ( dict_, restDicts ) =
    ( dict_ key_ value_
    , next restKeys restValues restDicts
    )


doMakeSet setMaker_ contents_ sets =
    setMaker_ (\{} {} -> {}) contents_ sets


setMaker next ( content, restContents ) ( set_, restSets ) =
    ( set_ content
    , next restContents restSets
    )


doMakeTuple tupleMaker_ a b tuples =
    tupleMaker_ (\{} {} {} -> {}) a b tuples


tupleMaker next ( a, restAs ) ( b, restBs ) ( tuple_, restTuples ) =
    ( tuple_ a b
    , next restAs restBs restTuples
    )


doMakeTriple tripleMaker_ a b c triples =
    tripleMaker_ (\{} {} {} {} -> {}) a b c triples


tripleMaker next ( a, restAs ) ( b, restBs ) ( c, restCs ) ( triple, restTriples ) =
    ( triple a b c
    , next restAs restBs restCs restTriples
    )


doMakeResult resultMaker_ errors values results =
    resultMaker_ (\{} {} {} -> {}) errors values results


resultMaker next ( error, restErrors ) ( value, restValues ) ( result, restResults ) =
    ( result error value
    , next restErrors restValues restResults
    )


doMakeRecord recordMaker_ recordConstructor records =
    recordMaker_ (\_ {} -> {}) recordConstructor records


recordMaker next recordConstructor ( record_, records ) =
    ( record_ recordConstructor
    , next recordConstructor records
    )


doMakeFields fieldMaker_ fieldName getField child recordBuilders fields =
    fieldMaker_ (\_ _ {} {} {} -> {}) fieldName getField child recordBuilders fields


fieldMaker next fieldName getField ( child, restChilds ) ( builder, restBuilders ) ( field_, restFields ) =
    ( field_ fieldName getField child builder
    , next fieldName getField restChilds restBuilders restFields
    )


doEndRecord recordEnder_ builder endRecords =
    recordEnder_ (\{} {} -> {}) builder endRecords


recordEnder next ( builder, restBuilders ) ( endRecord_, restEndRecords ) =
    ( endRecord_ builder
    , next restBuilders restEndRecords
    )


doMakeCustom customMaker_ customDestructors destructorFieldGetters customs =
    customMaker_ (\_ {} {} -> {}) customDestructors destructorFieldGetters customs


customMaker next customDestructors ( destructorFieldGetter, restDestructorFieldGetters ) ( custom, restCustoms ) =
    ( custom (destructorFieldGetter customDestructors)
    , next customDestructors restDestructorFieldGetters restCustoms
    )


doMakeTag0 tag0Maker_ tagName tagConstructor customBuilder tag0s =
    tag0Maker_ (\_ _ {} {} -> {}) tagName tagConstructor customBuilder tag0s


tag0Maker next tagName tagConstructor ( customBuilder, restCustomBuilders ) ( tag0, restTag0s ) =
    ( tag0 tagName tagConstructor customBuilder
    , next tagName tagConstructor restCustomBuilders restTag0s
    )


doMakeTag1 tag1Maker_ tagName tagConstructor child1 customBuilder tag1s =
    tag1Maker_ (\_ _ _ {} {} -> {}) tagName tagConstructor child1 customBuilder tag1s


tag1Maker next tagName tagConstructor ( child1, restChild1s ) ( customBuilder, restCustomBuilders ) ( tag1, restTag1s ) =
    ( tag1 tagName tagConstructor child1 customBuilder
    , next tagName tagConstructor restChild1s restCustomBuilders restTag1s
    )


doEndCustom customEnder_ customBuilder endCustoms =
    customEnder_ (\{} {} -> {}) customBuilder endCustoms


customEnder next ( customBuilder, restCustomBuilders ) ( endCustom, restEndCustoms ) =
    ( endCustom customBuilder
    , next restCustomBuilders restEndCustoms
    )


doConstructMultiTool constructMultiTool_ ctor builder =
    constructMultiTool_ (\output {} -> output) ctor builder


constructMultiTool next ctor ( builder, restBuilders ) =
    next (ctor builder) restBuilders
