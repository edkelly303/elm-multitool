module Example exposing (main)

import Browser
import Codec
import Control
import Fuzz
import Html
import Html.Attributes
import MultiTool
import Process
import Random
import Task
import Tools.Codec
import Tools.Control
import Tools.Fuzz
import Tools.Random
import Tools.ToComparable
import Tools.ToString
import Tools.Exhaustive

type alias Tools codec control fuzz random toString toComparable exhaustive =
    { codec : codec
    , control : control
    , fuzz : fuzz
    , random : random
    , toString : toString
    , toComparable : toComparable
    , exhaustive : exhaustive
    }


tools =
    MultiTool.define Tools Tools
        |> MultiTool.add .codec Tools.Codec.interface
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.add .fuzz Tools.Fuzz.interface
        |> MultiTool.add .random Tools.Random.interface
        |> MultiTool.add .toString Tools.ToString.interface
        |> MultiTool.add .toComparable Tools.ToComparable.interface
        |> MultiTool.add .exhaustive Tools.Exhaustive.interface
        |> MultiTool.end


type Shape
    = Circle Int
    | Triangle Int Int Int
    | Rectangle Int Int


shapes =
    [ Circle 1
    , Rectangle 1 2
    , Triangle 4 5 6
    ]


shapeSpec =
    let
        match circle triangle rectangle tag =
            case tag of
                Circle radius ->
                    circle radius

                Triangle side1 side2 side3 ->
                    triangle side1 side2 side3

                Rectangle width height ->
                    rectangle width height
    in
    tools.customType
        { codec = match
        , control = match
        , fuzz = match
        , random = match
        , toString = match
        , toComparable = match
        , exhaustive = match
        }
        |> tools.variant1 "Circle"
            Circle
            (tools.tweak.control
                (\intControl ->
                    Control.failIf
                        (\n -> n < 1)
                        "Must be greater than zero"
                        intControl
                )
                tools.int
            )
        |> tools.variant3 "Triangle" Triangle tools.int tools.int tools.int
        |> tools.variant2 "Rectangle" Rectangle tools.int tools.int
        |> tools.endCustomType


shapeTools =
    tools.build shapeSpec


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \model -> form.subscriptions model.form
        , view = view
        }


form =
    Control.simpleForm
        { onUpdate = FormUpdated
        , onSubmit = FormSubmitted
        , control = shapeTools.control
        }


init () =
    let
        ( formState, formCmd ) =
            form.blank
    in
    ( { form = formState
      , shapes = shapes
      , random = ( [], Random.initialSeed 0 )
      , exhaustive = 0
      }
    , Cmd.batch
        [ Task.perform (\_ -> Tick) (Process.sleep 1000)
        , formCmd
        ]
    )

numberOfExamples = 
    4

update msg model =
    case msg of
        Tick ->
            let
                random =
                    Random.step (Random.list numberOfExamples shapeTools.random) (Tuple.second model.random)
                exhaustive = model.exhaustive + numberOfExamples 
            in
            ( { model | random = random
              , exhaustive = if exhaustive > shapeTools.exhaustive.count then 0 else exhaustive
              }
            , Task.perform (\_ -> Tick) (Process.sleep 2000)
            )

        FormUpdated delta ->
            let
                ( newForm, cmd ) =
                    form.update delta model.form
            in
            ( { model | form = newForm }
            , cmd
            )

        FormSubmitted ->
            let
                ( newForm, result ) =
                    form.submit model.form
            in
            case result of
                Ok shape ->
                    let
                        ( resetForm, cmd ) =
                            form.blank
                    in
                    ( { model
                        | shapes = shape :: model.shapes
                        , form = resetForm
                      }
                    , cmd
                    )

                Err _ ->
                    ( { model | form = newForm }
                    , Cmd.none
                    )


view model =
    let
        json =
            Codec.encodeToString 0
                (Codec.list shapeTools.codec)
                model.shapes
    in
    Html.pre []
        [ Html.h1 [] [ Html.text "elm-multitool demo" ]
        , heading "Tools.Control: forms"
        , Html.div [ Html.Attributes.style "width" "500px" ] [ form.view model.form ]
        , heading "Tools.ToString: stringification"
        , viewShapes model.shapes
        , heading "Tools.ToComparable: sorting"
        , viewShapes (List.sortBy shapeTools.toComparable model.shapes)
        , heading "Tools.Codec: JSON encoding"
        , Html.text json
        , heading "Tools.Random: random generators"
        , viewShapes (model.random |> Tuple.first)
        , heading "Tools.Exhaustive: exhaustive generators"
        , Html.p [] [Html.text (String.fromInt model.exhaustive ++ "-" ++ String.fromInt (model.exhaustive + 3) ++ " of " ++ String.fromInt shapeTools.exhaustive.count ++ " generated values:")]
        , viewShapes (List.range model.exhaustive (model.exhaustive + 3) |> List.filterMap shapeTools.exhaustive.nth)
        , heading "Tools.Fuzz: fuzzers for testing"
        , viewShapes (Fuzz.examples numberOfExamples shapeTools.fuzz)
        ]


heading txt =
    Html.h2 [] [ Html.text txt ]


viewShapes shapeList =
    shapeList
        |> List.map shapeTools.toString
        |> String.join "\n"
        |> Html.text


type Msg a
    = Tick
    | FormUpdated a
    | FormSubmitted
