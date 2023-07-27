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


type alias Tools codec control fuzz random toString toComparable =
    { codec : codec
    , control : control
    , fuzz : fuzz
    , random : random
    , toString : toString
    , toComparable : toComparable
    }


tools =
    MultiTool.define Tools Tools
        |> MultiTool.add .codec Tools.Codec.interface
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.add .fuzz Tools.Fuzz.interface
        |> MultiTool.add .random Tools.Random.interface
        |> MultiTool.add .toString Tools.ToString.interface
        |> MultiTool.add .toComparable Tools.ToComparable.interface
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
    tools.custom
        { codec = match
        , control = match
        , fuzz = match
        , random = match
        , toString = match
        , toComparable = match
        }
        |> tools.tag1 "Circle" Circle tools.int
        |> tools.tag3 "Triangle" Triangle tools.int tools.int tools.int
        |> tools.tag2 "Rectangle" Rectangle tools.int tools.int
        |> tools.endCustom


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
    Control.form
        { onUpdate = FormUpdated
        , onSubmit = FormSubmitted
        , control = shapeTools.control
        }


init () =
    let
        ( formState, formCmd ) =
            form.init
    in
    ( { form = formState
      , shapes = shapes
      , random = ( [], Random.initialSeed 0 )
      }
    , Cmd.batch
        [ Task.perform (\_ -> Tick) (Process.sleep 1000)
        , formCmd
        ]
    )


update msg model =
    case msg of
        Tick ->
            let
                random =
                    Random.step (Random.list 4 shapeTools.random) (Tuple.second model.random)
            in
            ( { model | random = random }
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
                            form.init
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
        , Html.h2 [] [ Html.text "Tools.Control: forms" ]
        , Html.div [ Html.Attributes.style "width" "500px" ] [ form.view model.form ]
        , Html.h2 [] [ Html.text "Tools.ToString: stringification" ]
        , viewCharacters model.shapes
        , Html.h2 [] [ Html.text "Tools.ToComparable: sorting" ]
        , viewCharacters (List.sortBy shapeTools.toComparable model.shapes)
        , Html.h2 [] [ Html.text "Tools.Codec: JSON encoding" ]
        , Html.text json
        , Html.h2 [] [ Html.text "Tools.Random: random generators" ]
        , viewCharacters (model.random |> Tuple.first)
        , Html.h2 [] [ Html.text "Tools.Fuzz: fuzzers for testing" ]
        , viewCharacters (Fuzz.examples 1 shapeTools.fuzz)
        ]


viewCharacters characterList =
    characterList
        |> List.map shapeTools.toString
        |> String.join "\n"
        |> Html.text


type alias Model a =
    { random : ( List Shape, Random.Seed )
    , form : a
    , shapes : List Shape
    }


type Msg a
    = Tick
    | FormUpdated a
    | FormSubmitted
