module CodecAndControl exposing (main)

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
        (\codec control ->
            { codec = codec
            , control = control
            }
        )
        |> MultiTool.add Tools.Codec.interface
        |> MultiTool.add Tools.Control.interface
        |> MultiTool.end


users : List User
users =
    [ { name = "Pete", age = 35, hobbies = { surfs = True, skis = False }, favouriteColour = [ 1 ] }
    , { name = "Ed", age = 41, hobbies = { surfs = False, skis = True }, favouriteColour = [ 2 ] }
    , { name = "David", age = 48, hobbies = { surfs = True, skis = False }, favouriteColour = [ 3 ] }
    ]


type alias User =
    { favouriteColour : List Int
    , name : String
    , age : Int
    , hobbies : Hobbies
    }


userTools =
    appTools.build userToolsDefinition


userToolsDefinition =
    appTools.record User
        |> appTools.field "favouriteColour" .favouriteColour (appTools.list appTools.int)
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
        (MultiTool.matcher2 match match)
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
        , Html.h2 [] [ Html.text "codec: encode users as JSON" ]
        , Html.text json
        ]


type alias Model =
    { form :
        Control.State
            ( Control.State
                (List
                    (Control.State
                        String
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
                    String
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
