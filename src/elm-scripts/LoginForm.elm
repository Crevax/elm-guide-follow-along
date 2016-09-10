module LoginForm exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import List exposing (..)
import String exposing (..)
import Regex exposing (..)


main : Program Never
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : Int
    }


passwordRegex : Regex.Regex
passwordRegex =
    Regex.regex "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{1,}$"


model : Model
model =
    Model "" "" "" 0



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            let
                ageInt =
                    Result.withDefault 0 (String.toInt age)
            in
                { model | age = ageInt }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type' "text", placeholder "Name", onInput Name ] []
        , input [ type' "password", placeholder "Password", onInput Password ] []
        , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , input [ type' "number", onInput Age ] []
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, messages ) =
            let
                messages =
                    validateModel model
            in
                if List.isEmpty (messages) then
                    ( "green", [ "Ok" ] )
                else
                    ( "red", messages )
    in
        div [ style [ ( "color", color ) ] ] (List.map (\m -> p [] [ (text m) ]) messages)


validateModel : Model -> List String
validateModel model =
    [ ( model.password /= model.passwordAgain, "Passwords do not match" )
    , ( String.length model.password < 8, "Password must be at least 8 characters" )
    , ( Regex.contains (passwordRegex) model.password /= True, "Password must contain at least 1 upper case letter, one lowercase letter, and one number" )
    , ( model.age <= 0, "Age must be greater than 0" )
    ]
        |> List.filter fst
        |> List.map snd
