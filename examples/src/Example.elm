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


characters : List Character
characters =
    [ { name = "Dhalsim"
      , age = 71
      , profession = Yogi
      }
    , { name = "Vega"
      , age = 56
      , profession = Bullfighter
      }
    , { name = "Ryu"
      , age = 59
      , profession = KarateBlackBelt 10
      }
    , { name = "Guile"
      , age = 63
      , profession = USAFColonel
      }
    ]


type alias Character =
    { name : String
    , age : Int
    , profession : Profession
    }


characterTools =
    tools.build characterToolDefinition


characterToolDefinition =
    tools.record Character
        |> tools.field "name" .name nameToolDefinition
        |> tools.field "age" .age ageToolDefinition
        |> tools.field "profession" .profession professionToolDefinition
        |> tools.endRecord


nameToolDefinition =
    tools.tweak.control
        (Control.failIf String.isEmpty "Name can't be blank")
        tools.string


ageToolDefinition =
    tools.tweak.control
        (Control.failIf (\age -> age < 0) "Age can't be a negative number")
        tools.int


type Profession
    = Yogi
    | Bullfighter
    | KarateBlackBelt Int
    | USAFColonel


professionToolDefinition =
    let
        match yogi bullfighter karateBlackBelt usafColonel tag =
            case tag of
                Yogi ->
                    yogi

                Bullfighter ->
                    bullfighter

                KarateBlackBelt dan ->
                    karateBlackBelt dan

                USAFColonel ->
                    usafColonel
    in
    tools.custom
        { codec = match
        , control = match
        , fuzz = match
        , random = match
        , toString = match
        , toComparable = match
        }
        |> tools.tag0 "Yogi" Yogi
        |> tools.tag0 "Bullfighter" Bullfighter
        |> tools.tag1 "KarateBlackBelt" KarateBlackBelt tools.int
        |> tools.tag0 "USAFColonel" USAFColonel
        |> tools.endCustom


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


form =
    Control.toForm "Create a character" FormUpdated FormSubmitted characterTools.control


init () =
    ( { form = form.init
      , characters = characters
      , random = ( [], Random.initialSeed 0 )
      }
    , Task.perform (\_ -> Tick) (Process.sleep 1000)
    )


update msg model =
    case msg of
        Tick ->
            let
                random =
                    Random.step (Random.list 4 characterTools.random) (Tuple.second model.random)
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
                Ok character ->
                    ( { model
                        | characters = character :: model.characters
                        , form = form.init
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | form = newForm }
                    , Cmd.none
                    )


view model =
    let
        json =
            Codec.encodeToString 4
                (Codec.list characterTools.codec)
                model.characters
    in
    Html.pre []
        [ Html.h1 [] [ Html.text "elm-multitool demo" ]
        , Html.h2 [] [ Html.text "Tools.Control: create a character" ]
        , Html.div [ Html.Attributes.style "width" "500px" ] [ form.view model.form ]
        , Html.h2 [] [ Html.text "Tools.ToString: stringify characters" ]
        , viewCharacters model.characters
        , Html.h2 [] [ Html.text "Tools.ToComparable: sort characters" ]
        , viewCharacters (List.sortBy characterTools.toComparable model.characters)
        , Html.h2 [] [ Html.text "Tools.Fuzz: generate character fuzzers" ]
        , viewCharacters (Fuzz.examples 4 characterTools.fuzz)
        , Html.h2 [] [ Html.text "Tools.Random: generate random characters" ]
        , viewCharacters (model.random |> Tuple.first)
        , Html.h2 [] [ Html.text "Tools.Codec: encode characters as JSON" ]
        , Html.text json
        ]


viewCharacters characterList =
    characterList
        |> List.map characterTools.toString
        |> String.join "\n"
        |> Html.text


type alias Model =
    { random : ( List Character, Random.Seed )
    , form :
        Control.State
            ( Control.State String
            , ( Control.State String
              , ( Control.State
                    ( Control.State ()
                    , ( Control.State ()
                      , ( Control.State
                            ( Control.State String, Control.End )
                        , ( Control.State (), Control.End )
                        )
                      )
                    )
                , Control.End
                )
              )
            )
    , characters : List Character
    }


type Msg
    = Tick
    | FormUpdated
        (Control.Delta
            ( Control.Delta String
            , ( Control.Delta String
              , ( Control.Delta
                    ( Control.Delta ()
                    , ( Control.Delta ()
                      , ( Control.Delta ( Control.Delta String, Control.End )
                        , ( Control.Delta (), Control.End )
                        )
                      )
                    )
                , Control.End
                )
              )
            )
        )
    | FormSubmitted
