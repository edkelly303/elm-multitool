module All exposing (main)

import Browser
import Codec
import Control
import Html
import Html.Attributes
import MultiTool
import Tools.Codec
import Tools.Control
import Tools.ToComparable
import Tools.ToString


appTools =
    MultiTool.define
        (\codec control toString toComparable ->
            { codec = codec
            , control = control
            , toString = toString
            , toComparable = toComparable
            }
        )
        |> MultiTool.add .codec Tools.Codec.interface
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.add .toString Tools.ToString.interface
        |> MultiTool.add .toComparable Tools.ToComparable.interface
        |> MultiTool.end


users : List User
users =
    [ { name = "Pete", age = 35, hobbies = { surfs = True, skis = False }, favouriteColour = [ Red ] }
    , { name = "Ed", age = 41, hobbies = { surfs = False, skis = True }, favouriteColour = [ Green 2 ] }
    , { name = "David", age = 48, hobbies = { surfs = True, skis = False }, favouriteColour = [ Blue ] }
    ]


type alias User =
    { favouriteColour : List Colour
    , name : String
    , age : Int
    , hobbies : Hobbies
    }


userTools =
    appTools.build userToolsDefinition


userToolsDefinition =
    appTools.record User
        |> appTools.field "favouriteColour" .favouriteColour (appTools.list colourToolsDefinition)
        |> appTools.field "name" .name appTools.string
        |> appTools.field "age" .age appTools.int
        |> appTools.field "hobbies" .hobbies hobbiesToolsDefinition
        |> appTools.endRecord


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
    | Green Int
    | Blue


colourToolsDefinition =
    let
        match red green blue tag =
            case tag of
                Red ->
                    red

                Green i ->
                    green i

                Blue ->
                    blue
    in
    appTools.custom
        { codec = match
        , control = match
        , toString = match
        , toComparable = match
        }
        |> appTools.tag0 "Red" Red
        |> appTools.tag1 "Green" Green appTools.int
        |> appTools.tag0 "Blue" Blue
        |> appTools.endCustom


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
      }
    , Cmd.none
    )


update msg model =
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
        , Html.h2 [] [ Html.text "codec: encode users as JSON" ]
        , Html.text json
        ]


viewUsers users_ =
    users_
        |> List.map userTools.toString
        |> String.join "\n"
        |> Html.text


type alias Model =
    { form :
        Control.State
            ( Control.State
                (List
                    (Control.State
                        ( Control.State ()
                        , ( Control.State
                                ( Control.State String, Control.End )
                          , ( Control.State (), Control.End )
                          )
                        )
                    )
                )
            , ( Control.State String
              , ( Control.State String
                , ( Control.State
                        ( Control.State Bool
                        , ( Control.State Bool, Control.End )
                        )
                  , Control.End
                  )
                )
              )
            )
    , users : List User
    }


type Msg
    = FormUpdated
        (Control.Delta
            ( Control.Delta
                (Control.ListDelta
                    ( Control.Delta ()
                    , ( Control.Delta ( Control.Delta String, Control.End )
                      , ( Control.Delta (), Control.End )
                      )
                    )
                )
            , ( Control.Delta String
              , ( Control.Delta String
                , ( Control.Delta
                        ( Control.Delta Bool, ( Control.Delta Bool, Control.End ) )
                  , Control.End
                  )
                )
              )
            )
        )
    | FormSubmitted
