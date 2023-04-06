module MultiTool exposing (..)

import Browser
import Codec
import Control
import Html
import Html.Attributes


codecInterface =
    { record = Codec.object
    , field = Codec.field
    , end = Codec.buildObject
    , string = Codec.string
    , int = Codec.int
    , bool = Codec.bool
    }


controlInterface =
    { record = Control.record
    , field = Control.field
    , end = Control.end
    , string = Control.string
    , int = Control.int
    , bool = Control.bool "yes" "no"
    }


multiTool =
    defineTool
        (\toString codec control toComparable ->
            { toString = toString
            , codec = codec
            , control = control
            , toComparable = toComparable
            }
        )
        |> add toStringInterface
        |> add codecInterface
        |> add controlInterface
        |> add toComparableInterface
        |> endTool


users : List User
users =
    [ { name = "Pete", age = 35, hobbies = { surfs = True, skis = False } }
    , { name = "Ed", age = 41, hobbies = { surfs = False, skis = True } }
    , { name = "David", age = 48, hobbies = { surfs = True, skis = False } }
    ]


type alias User =
    { name : String
    , age : Int
    , hobbies : Hobbies
    }


user =
    multiTool.record User
        |> multiTool.field "name" .name multiTool.string
        |> multiTool.field "age" .age multiTool.int
        |> multiTool.field "hobbies" .hobbies hobbies
        |> multiTool.end


type alias Hobbies =
    { skis : Bool
    , surfs : Bool
    }


hobbies =
    multiTool.record Hobbies
        |> multiTool.field "surfs" .surfs multiTool.bool
        |> multiTool.field "skis" .skis multiTool.bool
        |> multiTool.end


type alias Model =
    { form : Control.State ( Control.State String, ( Control.State String, ( Control.State ( Control.State Bool, ( Control.State Bool, Control.End ) ), Control.End ) ) )
    , users : List User
    }


type Msg
    = FormUpdated (Control.Delta ( Control.Delta String, ( Control.Delta String, ( Control.Delta ( Control.Delta Bool, ( Control.Delta Bool, Control.End ) ), Control.End ) ) ))
    | FormSubmitted


main : Program () Model Msg
main =
    let
        { toComparable, toString, control, codec } =
            multiTool.build user

        form =
            Control.toForm "User Form" FormUpdated FormSubmitted control
    in
    Browser.element
        { init = \_ -> ( { form = form.init, users = users }, Cmd.none )
        , update =
            \msg model ->
                case msg of
                    FormUpdated delta ->
                        let
                            ( newForm, cmd ) =
                                form.update delta model.form
                        in
                        ( { model | form = newForm }, cmd )

                    FormSubmitted ->
                        let
                            ( newForm, result ) =
                                form.submit model.form
                        in
                        case result of
                            Ok u ->
                                ( { model | users = u :: model.users, form = newForm }, Cmd.none )

                            Err _ ->
                                ( { model | form = newForm }, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view =
            \model ->
                let
                    toHtml records =
                        records
                            |> List.map toString
                            |> String.join "\n"
                            |> Html.text

                    json =
                        Codec.encodeToString 4
                            (Codec.list codec)
                            model.users
                in
                Html.pre []
                    [ Html.h1 [] [ Html.text "elm-multitool demo" ]
                    , Html.h2 [] [ Html.text "control: create a user" ]
                    , Html.div [ Html.Attributes.style "width" "400px" ] [ form.view model.form ]
                    , Html.h2 [] [ Html.text "toString: stringify users" ]
                    , toHtml model.users
                    , Html.h2 [] [ Html.text "toComparable: sort users" ]
                    , toHtml (List.sortBy toComparable model.users)
                    , Html.h2 [] [ Html.text "codec: encode users as JSON" ]
                    , Html.text json
                    ]
        }



-- MULTITOOL BUILDER


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



-- COMPARE


toComparableInterface =
    { record = compRecord
    , field = compField
    , end = compEnd
    , string = compString
    , int = compInt
    , bool = compBool
    }


compRecord : ctor -> rest -> recordData -> rest
compRecord ctor =
    \rest _ -> rest


compField : String -> (recordData -> field) -> (field -> comparable) -> (( comparable, rest ) -> recordData -> builder) -> rest -> recordData -> builder
compField fieldName getField toComparable builder =
    \rest recordData ->
        let
            this =
                recordData
                    |> getField
                    |> toComparable
        in
        builder ( this, rest ) recordData


compEnd : (Int -> rest -> output) -> (rest -> output)
compEnd builder =
    \rest -> builder 0 rest


compString : String -> String
compString =
    String.toLower


compInt : Int -> Int
compInt =
    identity


compBool : Bool -> Int
compBool b =
    if b then
        1

    else
        0



-- TOSTRING


toStringInterface =
    { record = strRecord
    , field = strField
    , end = strEnd
    , string = strString
    , int = strInt
    , bool = strBool
    }


strRecord : ctor -> recordData -> List String
strRecord ctor =
    \recordData -> []


strField : String -> (recordData -> field) -> (field -> String) -> (recordData -> List String) -> recordData -> List String
strField fieldName getField toString builder =
    \recordData ->
        (fieldName ++ " = " ++ toString (getField recordData)) :: builder recordData


strEnd : (recordData -> List String) -> recordData -> String
strEnd builder =
    \recordData -> "{ " ++ String.join ", " (builder recordData |> List.reverse) ++ " }"


strString : String -> String
strString =
    identity


strInt : Int -> String
strInt =
    String.fromInt


strBool : Bool -> String
strBool b =
    if b then
        "True"

    else
        "False"
