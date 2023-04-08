module Example exposing (main)

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


multiTool =
    MultiTool.defineTool
        (\toString codec control toComparable ->
            { toString = toString
            , codec = codec
            , control = control
            , toComparable = toComparable
            }
        )
        |> MultiTool.add Tools.ToString.interface
        |> MultiTool.add Tools.Codec.interface
        |> MultiTool.add Tools.Control.interface
        |> MultiTool.add Tools.ToComparable.interface
        |> MultiTool.endTool


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
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


tools =
    multiTool.build user


form =
    Control.toForm "User Form" FormUpdated FormSubmitted tools.control


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
                (Codec.list tools.codec)
                model.users
    in
    Html.pre []
        [ Html.h1 [] [ Html.text "elm-multitool demo" ]
        , Html.h2 [] [ Html.text "control: create a user" ]
        , Html.div [ Html.Attributes.style "width" "400px" ] [ form.view model.form ]
        , Html.h2 [] [ Html.text "toString: stringify users" ]
        , viewUsers model.users
        , Html.h2 [] [ Html.text "toComparable: sort users" ]
        , viewUsers (List.sortBy tools.toComparable model.users)
        , Html.h2 [] [ Html.text "codec: encode users as JSON" ]
        , Html.text json
        ]


viewUsers users_ =
    users_
        |> List.map tools.toString
        |> String.join "\n"
        |> Html.text
