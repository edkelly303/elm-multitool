module All exposing (main)

import Array exposing (Array)
import Browser
import Codec
import Control
import Dict exposing (Dict)
import Fuzz
import Html
import Html.Attributes
import MultiTool
import Process
import Random
import Set exposing (Set)
import Task
import Tools.Codec
import Tools.Control
import Tools.Fuzz
import Tools.Random
import Tools.ToComparable
import Tools.ToString


type alias AppTools codec control fuzz random toString toComparable =
    { codec : codec
    , control : control
    , fuzz : fuzz
    , random : random
    , toString : toString
    , toComparable : toComparable
    }


appTools =
    MultiTool.define AppTools AppTools
        |> MultiTool.add .codec Tools.Codec.interface
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.add .fuzz Tools.Fuzz.interface
        |> MultiTool.add .random Tools.Random.interface
        |> MultiTool.add .toString Tools.ToString.interface
        |> MultiTool.add .toComparable Tools.ToComparable.interface
        |> MultiTool.end


users : List User
users =
    [ { name = "Pete"
      , age = 35
      , hobbies = { surfs = True, skis = False }
      , favouriteColours = [ Red ]
      , misc = blankMisc
      }
    , { name = "Ed"
      , age = 41
      , hobbies = { surfs = False, skis = True }
      , favouriteColours = [ Blue ]
      , misc = blankMisc
      }
    , { name = "David"
      , age = 48
      , hobbies = { surfs = True, skis = False }
      , favouriteColours = [ Green ]
      , misc = blankMisc
      }
    ]


type alias User =
    { name : String
    , age : Int
    , favouriteColours : List Colour
    , hobbies : Hobbies
    , misc : Misc
    }


userTools =
    appTools.build userToolsDefinition


userToolsDefinition =
    appTools.record User
        |> appTools.field "name" .name nameField
        |> appTools.field "age" .age appTools.int
        |> appTools.field "favouriteColours" .favouriteColours (appTools.list colourToolsDefinition)
        |> appTools.field "hobbies" .hobbies hobbiesToolsDefinition
        |> appTools.field "misc" .misc miscToolsDefinition
        |> appTools.endRecord


nameField =
    appTools.string
        |> appTools.tweak.control (Control.failIf String.isEmpty "Can't be blank")


type alias Hobbies =
    { skis : Bool
    , surfs : Bool
    }


hobbiesToolsDefinition =
    appTools.record Hobbies
        |> appTools.field "surfs" .surfs appTools.bool
        |> appTools.field "skis" .skis appTools.bool
        |> appTools.endRecord


type Colour
    = Red
    | Green
    | Blue


colourToolsDefinition =
    let
        match red green blue tag =
            case tag of
                Red ->
                    red

                Green ->
                    green

                Blue ->
                    blue
    in
    appTools.custom
        { codec = match
        , control = match
        , fuzz = match
        , random = match
        , toString = match
        , toComparable = match
        }
        |> appTools.tag0 "Red" Red
        |> appTools.tag0 "Green" Green
        |> appTools.tag0 "Blue" Blue
        |> appTools.endCustom


type alias Misc =
    { maybe : Maybe Int
    , array : Array Int
    , dict : Dict Int Int
    , set : Set Int
    , tuple : ( Int, Int )
    , triple : ( Int, Int, Int )
    , result : Result Int Int
    }


blankMisc =
    { maybe = Just 0
    , array = Array.fromList [ 0 ]
    , dict = Dict.fromList [ ( 0, 0 ) ]
    , set = Set.fromList [ 0 ]
    , tuple = ( 0, 0 )
    , triple = ( 0, 0, 0 )
    , result = Ok 0
    }


miscToolsDefinition =
    appTools.record Misc
        |> appTools.field "maybe" .maybe (appTools.maybe appTools.int)
        |> appTools.field "array" .array (appTools.array appTools.int)
        |> appTools.field "dict" .dict (appTools.dict appTools.int appTools.int)
        |> appTools.field "set" .set (appTools.set appTools.int)
        |> appTools.field "tuple" .tuple (appTools.tuple appTools.int appTools.int)
        |> appTools.field "triple" .triple (appTools.triple appTools.int appTools.int appTools.int)
        |> appTools.field "result" .result (appTools.result appTools.int appTools.int)
        |> appTools.endRecord


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


form =
    Control.toForm "Create a user" FormUpdated FormSubmitted userTools.control


init () =
    ( { form = form.init
      , users = users
      , random = ( [], Random.initialSeed 0 )
      }
    , Task.perform (\_ -> Tick) (Process.sleep 1000)
    )


update msg model =
    case msg of
        Tick ->
            let
                random =
                    Random.step (Random.list 3 userTools.random) (Tuple.second model.random)
            in
            ( { model | random = random }, Task.perform (\_ -> Tick) (Process.sleep 1000) )

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


view model =
    let
        json =
            Codec.encodeToString 4
                (Codec.list userTools.codec)
                model.users
    in
    Html.pre []
        [ Html.h1 [] [ Html.text "elm-multitool demo" ]
        , Html.h2 [] [ Html.text "control: create a user" ]
        , Html.div [ Html.Attributes.style "width" "400px" ] [ form.view model.form ]
        , Html.h2 [] [ Html.text "toString: stringify users" ]
        , viewUsers model.users
        , Html.h2 [] [ Html.text "toComparable: sort users" ]
        , viewUsers (List.sortBy userTools.toComparable model.users)
        , Html.h2 [] [ Html.text "fuzz: generate users for tests" ]
        , viewUsers (Fuzz.examples 3 userTools.fuzz)
        , Html.h2 [] [ Html.text "random: generate random users" ]
        , viewUsers (model.random |> Tuple.first)
        , Html.h2 [] [ Html.text "codec: encode users as JSON" ]
        , Html.text json
        ]


viewUsers users_ =
    users_
        |> List.map userTools.toString
        |> String.join "\n"
        |> Html.text


type alias Model =
    { random : ( List User, Random.Seed )
    , form :
        Control.State
            ( Control.State String
            , ( Control.State String
              , ( Control.State
                    (List
                        (Control.State
                            ( Control.State ()
                            , ( Control.State ()
                              , ( Control.State (), Control.End )
                              )
                            )
                        )
                    )
                , ( Control.State
                        ( Control.State Bool
                        , ( Control.State Bool, Control.End )
                        )
                  , ( Control.State
                        ( Control.State
                            ( Control.State ()
                            , ( Control.State
                                    ( Control.State String
                                    , Control.End
                                    )
                              , Control.End
                              )
                            )
                        , ( Control.State
                                ( Control.State
                                    (List (Control.State String))
                                , Control.End
                                )
                          , ( Control.State
                                ( Control.State
                                    (List
                                        (Control.State
                                            ( Control.State String
                                            , ( Control.State String
                                              , Control.End
                                              )
                                            )
                                        )
                                    )
                                , Control.End
                                )
                            , ( Control.State
                                    ( Control.State
                                        (List (Control.State String))
                                    , Control.End
                                    )
                              , ( Control.State
                                    ( Control.State String
                                    , ( Control.State String
                                      , Control.End
                                      )
                                    )
                                , ( Control.State
                                        ( Control.State String
                                        , ( Control.State String
                                          , ( Control.State String
                                            , Control.End
                                            )
                                          )
                                        )
                                  , ( Control.State
                                        ( Control.State
                                            ( Control.State String
                                            , Control.End
                                            )
                                        , ( Control.State
                                                ( Control.State String
                                                , Control.End
                                                )
                                          , Control.End
                                          )
                                        )
                                    , Control.End
                                    )
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
              )
            )
    , users : List User
    }


type Msg
    = Tick
    | FormUpdated
        (Control.Delta
            ( Control.Delta String
            , ( Control.Delta String
              , ( Control.Delta
                    (Control.ListDelta
                        ( Control.Delta ()
                        , ( Control.Delta (), ( Control.Delta (), Control.End ) )
                        )
                    )
                , ( Control.Delta
                        ( Control.Delta Bool, ( Control.Delta Bool, Control.End ) )
                  , ( Control.Delta
                        ( Control.Delta
                            ( Control.Delta ()
                            , ( Control.Delta
                                    ( Control.Delta String, Control.End )
                              , Control.End
                              )
                            )
                        , ( Control.Delta
                                ( Control.Delta (Control.ListDelta String)
                                , Control.End
                                )
                          , ( Control.Delta
                                ( Control.Delta
                                    (Control.ListDelta
                                        ( Control.Delta String
                                        , ( Control.Delta String
                                          , Control.End
                                          )
                                        )
                                    )
                                , Control.End
                                )
                            , ( Control.Delta
                                    ( Control.Delta (Control.ListDelta String)
                                    , Control.End
                                    )
                              , ( Control.Delta
                                    ( Control.Delta String
                                    , ( Control.Delta String, Control.End )
                                    )
                                , ( Control.Delta
                                        ( Control.Delta String
                                        , ( Control.Delta String
                                          , ( Control.Delta String, Control.End )
                                          )
                                        )
                                  , ( Control.Delta
                                        ( Control.Delta
                                            ( Control.Delta String
                                            , Control.End
                                            )
                                        , ( Control.Delta
                                                ( Control.Delta String
                                                , Control.End
                                                )
                                          , Control.End
                                          )
                                        )
                                    , Control.End
                                    )
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
              )
            )
        )
    | FormSubmitted
