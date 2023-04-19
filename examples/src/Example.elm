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
import Set exposing (Set)

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


farmers : List Farmer
farmers =
    [ { name = "Boggis"
      , age = 59
      , animals = [ Chickens 5000, Dogs (Set.fromList [ "Bill", "Growler" ]) ]
      }
    , { name = "Bunce"
      , age = 63
      , animals = [ Ducks 1500 ]
      }
    , { name = "Bean"
      , age = 45
      , animals = [ Turkeys 500, Dogs (Set.fromList [ "Rex" ]) ]
      }
    ]


type alias Farmer =
    { name : String
    , age : Int
    , animals : List Animals
    }


farmerTools =
    tools.build farmerSpec


farmerSpec =
    tools.record Farmer
        |> tools.field "name" .name nameSpec
        |> tools.field "age" .age ageSpec
        |> tools.field "animals" .animals (tools.list animalsSpec)
        |> tools.endRecord


nameSpec =
    tools.tweak.control
        (Control.failIf String.isEmpty "Name can't be blank")
        tools.string


ageSpec =
    tools.tweak.control
        (Control.failIf (\age -> age < 0) "Age can't be a negative number")
        tools.int


type Animals
    = Chickens Int
    | Ducks Int
    | Turkeys Int
    | Dogs (Set String)


animalsSpec =
    let
        match chickens ducks turkeys dogs tag =
            case tag of
                Chickens int ->
                    chickens int

                Ducks int ->
                    ducks int

                Turkeys int ->
                    turkeys int

                Dogs names ->
                    dogs names
    in
    tools.custom
        { codec = match
        , control = match
        , fuzz = match
        , random = match
        , toString = match
        , toComparable = match
        }
        |> tools.tag1 "Chickens" Chickens tools.int
        |> tools.tag1 "Ducks" Ducks tools.int
        |> tools.tag1 "Turkeys" Turkeys tools.int
        |> tools.tag1 "Dogs" Dogs (tools.set tools.string)
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
    Control.toForm "Create a farmer" FormUpdated FormSubmitted farmerTools.control


init () =
    ( { form = form.init
      , farmers = farmers
      , random = ( [], Random.initialSeed 0 )
      }
    , Task.perform (\_ -> Tick) (Process.sleep 1000)
    )


update msg model =
    case msg of
        Tick ->
            let
                random =
                    Random.step (Random.list 4 farmerTools.random) (Tuple.second model.random)
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
                Ok farmer ->
                    ( { model
                        | farmers = farmer :: model.farmers
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
            Codec.encodeToString 0
                (Codec.list farmerTools.codec)
                model.farmers
    in
    Html.pre []
        [ Html.h1 [] [ Html.text "elm-multitool demo" ]
        , Html.h2 [] [ Html.text "Tools.Control: forms" ]
        , Html.div [ Html.Attributes.style "width" "500px" ] [ form.view model.form ]
        , Html.h2 [] [ Html.text "Tools.ToString: stringification" ]
        , viewCharacters model.farmers
        , Html.h2 [] [ Html.text "Tools.ToComparable: sorting" ]
        , viewCharacters (List.sortBy farmerTools.toComparable model.farmers)
        , Html.h2 [] [ Html.text "Tools.Codec: JSON encoding" ]
        , Html.text json
        , Html.h2 [] [ Html.text "Tools.Random: random generators" ]
        , viewCharacters (model.random |> Tuple.first)
        , Html.h2 [] [ Html.text "Tools.Fuzz: fuzzers for testing" ]
        , viewCharacters (Fuzz.examples 1 farmerTools.fuzz)
        ]


viewCharacters characterList =
    characterList
        |> List.map farmerTools.toString
        |> String.join "\n"
        |> Html.text


type alias Model =
    { random : ( List Farmer, Random.Seed )
    , form :
        Control.State
                  ( Control.State String
                  , ( Control.State String
                    , ( Control.State
                            (
                            List
                                (
                                Control.State
                                    ( Control.State
                                          ( Control.State String, Control.End )
                                    , ( Control.State
                                            ( Control.State String, Control.End
                                            )
                                      , ( Control.State
                                              ( Control.State String
                                              , Control.End
                                              )
                                        , ( Control.State
                                                ( Control.State
                                                      ( Control.State
                                                            (
                                                            List
                                                                (
                                                                Control.State
                                                                    String
                                                                )
                                                            )
                                                      , Control.End
                                                      )
                                                , Control.End
                                                )
                                          , Control.End
                                          )
                                        )
                                      )
                                    )
                                )
                            )
                      , Control.End
                      )
                    )
                  )
    , farmers : List Farmer
    }


type Msg
    = Tick
    | FormUpdated
        (Control.Delta
            ( Control.Delta String
        , ( Control.Delta String
          , ( Control.Delta
                  (
                  Control.ListDelta
                      ( Control.Delta ( Control.Delta String, Control.End )
                      , ( Control.Delta ( Control.Delta String, Control.End )
                        , ( Control.Delta ( Control.Delta String, Control.End )
                          , ( Control.Delta
                                  ( Control.Delta
                                        ( Control.Delta
                                              (Control.ListDelta String)
                                        , Control.End
                                        )
                                  , Control.End
                                  )
                            , Control.End
                            )
                          )
                        )
                      )
                  )
            , Control.End
            )
          )
        )
        )
    | FormSubmitted
