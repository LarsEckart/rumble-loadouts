port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Process
import Task
import Toast



-- PORTS


port copyToClipboard : String -> Cmd msg



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { currentView : View
    , toasts : Toast.Tray String
    }


type View
    = RaidList
    | DifficultySelect String
    | BossList String Difficulty
    | TeamList String Difficulty String


type Difficulty
    = Normal
    | Heroic


type alias Raid =
    { name : String
    , bosses : List Boss
    }


type alias Boss =
    { name : String
    , teams : List Team
    }


type alias Team =
    { hero : String
    , loadout : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentView = RaidList, toasts = Toast.tray }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SelectRaid String
    | SelectDifficulty String Difficulty
    | SelectBoss String Difficulty String
    | BackToRaids
    | BackToDifficulty String
    | BackToBosses String Difficulty
    | CopyLoadout String
    | ToastMsg Toast.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectRaid raidName ->
            ( { model | currentView = DifficultySelect raidName }
            , Cmd.none
            )

        SelectDifficulty raidName difficulty ->
            ( { model | currentView = BossList raidName difficulty }
            , Cmd.none
            )

        SelectBoss raidName difficulty bossName ->
            ( { model | currentView = TeamList raidName difficulty bossName }
            , Cmd.none
            )

        BackToRaids ->
            ( { model | currentView = RaidList }
            , Cmd.none
            )

        BackToDifficulty raidName ->
            ( { model | currentView = DifficultySelect raidName }
            , Cmd.none
            )

        BackToBosses raidName difficulty ->
            ( { model | currentView = BossList raidName difficulty }
            , Cmd.none
            )

        CopyLoadout loadout ->
            let
                (newToasts, toastCmd) =
                    Toast.add model.toasts (Toast.expireIn 1000 "Copied to clipboard!")
            in
            ( { model | toasts = newToasts }
            , Cmd.batch
                [ copyToClipboard loadout
                , Cmd.map ToastMsg toastCmd
                ]
            )

        ToastMsg toastMsg ->
            let
                (newToasts, toastCmd) =
                    Toast.update toastMsg model.toasts
            in
            ( { model | toasts = newToasts }
            , Cmd.map ToastMsg toastCmd
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- DATA


type alias BossData =
    { name : String
    , normalTeams : List Team
    , heroicTeams : List Team
    }


type alias RaidData =
    { name : String
    , bosses : List BossData
    }


raidData : List RaidData
raidData =
    [ { name = "Molten Core"
      , bosses =
            [ { name = "Lucifron"
              , normalTeams = 
                    [ { hero = "Grommash", loadout = "rumblo:CDAQARoECAkQABoECFkQAhoECDIQABoECFgQARoECEcQAhoECFoQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Maiev", loadout = "rumblo:CDgQAhoECEcQAhoECFoQARoECCQQABoECDIQABoECFgQARoECAkQAA==" }
                    , { hero = "Anub'arak", loadout = "rumblo:CBAQARoECB4QARoECEcQAhoECAkQABoECE0QAhoECEwQAhoECDIQAA==" }
                    ]
              }
            , { name = "Magmadar"
              , normalTeams = 
                    [ { hero = "Hogger", loadout = "rumblo:CDUQABoECDIQABoECAgQAhoECEQQAhoECB0QARoECAcQABoECBwQAA==" }
                    ]
              , heroicTeams = 
                    [ { hero = "Doomhammer", loadout = "rumblo:CB8QABoECBwQABoECFgQARoECB0QARoECAcQABoECAgQAhoECEQQAg==" }
                    , { hero = "Grom", loadout = "rumblo:CDAQARoECBwQABoECAkQABoECB0QARoECFgQARoECEQQAhoECEcQAg==" }
                    ]
              }
            , { name = "Gehennas & Shazzah"
              , normalTeams = 
                    [ { hero = "Baron Rivendare", loadout = "rumblo:CBIQAhoECCsQARoECDoQARoECC4QABoECBMQARoECCYQAhoECBsQAQ==" }
                    ]
              , heroicTeams = 
                    [ { hero = "Rivendare", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECEcQAhoECBMQARoECCYQAhoECDsQAg==" }
                    , { hero = "Hogger", loadout = "rumblo:CDUQABoECD8QABoECEcQAhoECEQQAhoECBsQAhoECBMQARoECCYQAg==" }
                    , { hero = "Rivendare Giant", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECEcQAhoECBMQARoECCYQAhoECDsQAg==" }
                    , { hero = "Rivendare Fire Elemental", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECCcQABoECBMQARoECEsQABoECEcQAg==" }
                    ]
              }
            , { name = "Garr"
              , normalTeams =
                    [ { hero = "Cairne", loadout = "rumblo:CBYQABoECFkQAhoECEsQAhoECC4QABoECEQQAhoECEwQAhoECF0QAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Thalnos", loadout = "rumblo:CBQQABoECCwQABoECEQQAhoECA0QARoECFkQAhoECF0QABoECAkQAA==" }
                    , { hero = "Cenarius", loadout = "rumblo:CBcQARoECBUQABoECA0QARoECEQQAhoECFkQAhoECEYQABoECF0QAA==" }
                    , { hero = "Sneed", loadout = "rumblo:CE4QARoECEsQAhoECFkQAhoECDsQAhoECEEQABoECDoQARoECF0QAA==" }
                    ]
              }
            , { name = "Geddon"
              , normalTeams =
                    [ { hero = "Charlga", loadout = "rumblo:CBgQARoECBkQABoECCYQAhoECDIQABoECDoQAhoECCsQARoECBsQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Ragnaros", loadout = "rumblo:CEgQABoECBsQABoECCYQAhoECDEQABoECDIQABoECF0QARoECCsQAg==" }
                    , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECBEQAhoECB4QARoECCYQAhoECBkQABoECBsQARoECCsQAg==" }
                    ]
              }
            , { name = "Golemagg"
              , normalTeams =
                    [ { hero = "Murk-Eye", loadout = "rumblo:CEIQAhoECBkQABoECAwQABoECEcQAhoECB4QARoECFgQARoECCYQAg==" }
                    , { hero = "Cenarius", loadout = "rumblo:CBcQABoECBUQAhoECAgQABoECCIQARoECB0QARoECEQQAhoECF0QAA==" }
                    ]
              , heroicTeams =
                    [ { hero = "Jaina", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQAhoECEQQAhoECEwQAhoECAcQAA==" }
                    , { hero = "Ragnaros", loadout = "rumblo:CEgQARoECCQQAhoECDsQARoECDEQABoECF0QARoECEQQAhoECEwQAg==" }
                    , { hero = "Jaina Rime", loadout = "rumblo:CDcQARoECDEQARoECB0QABoECAgQAhoECCwQABoECEwQAhoECAcQAA==" }
                    , { hero = "Jaina Blizzard", loadout = "rumblo:CDcQARoECB0QARoECAMQABoECAgQAhoECEcQAhoECDEQARoECAcQAA==" }
                    , { hero = "Jaina Priestess/Rime", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQAhoECEQQAhoECEwQAhoECAcQAA==" }
                    , { hero = "Jaina Priestess/Bandits", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQAhoECEQQAhoECB0QABoECAcQAA==" }
                    , { hero = "Jaina No Starfall", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQARoECEQQAhoECEcQAhoECEwQAg==" }
                    , { hero = "Jaina No Starfall No Rime", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQARoECEQQAhoECEcQAhoECFgQAQ==" }
                    ]
              }
            , { name = "Ragnaros"
              , normalTeams =
                    [ { hero = "Thalnos", loadout = "rumblo:CBQQABoECCYQAhoECB0QARoECAkQARoECBsQARoECAIQAhoECAoQAQ==" }
                    , { hero = "Onu (Execute)", loadout = "rumblo:CEMQAhoECB0QARoECCYQAhoECBEQAhoECAkQABoECFgQARoECFEQAQ==" }
                    , { hero = "Onu (Miner)", loadout = "rumblo:CEMQAhoECBsQARoECCYQAhoECBEQAhoECB0QARoECFgQARoECFEQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Drakkisath Fast", loadout = "rumblo:CCEQABoECBsQARoECFgQARoECC4QABoECB0QARoECCMQARoECEsQAg==" }
                    , { hero = "Malfurion", loadout = "rumblo:CDkQAhoECBUQAhoECC4QABoECAkQABoECB0QARoECFgQARoECFoQAQ==" }
                    , { hero = "Sneed", loadout = "rumblo:CE4QARoECBsQARoECCYQAhoECFoQARoECC4QABoECBEQAhoECCsQAA==" }
                    ]
              }
            ]
      }
    , { name = "Siege of Ironforge"
      , bosses =
            [ { name = "Thiefcatchers"
              , normalTeams =
                    [ { hero = "Thrall", loadout = "rumblo:CF8QABoECFkQAhoECFEQARoECA8QAhoECAUQARoECF0QAhoECEQQAg==" }
                    , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECAUQARoECB4QARoECFkQAhoECEQQAhoECF0QABoECFEQAA==" }
                    , { hero = "Grom", loadout = "rumblo:CDAQAhoECFEQAhoECEsQAhoECB4QARoECFkQAhoECEYQABoECF0QAA==" }
                    ]
              , heroicTeams =
                    [ { hero = "Cairne", loadout = "rumblo:CBYQABoECFkQAhoECFEQAhoECF0QABoECEYQABoECB4QARoECAsQAQ==" }
                    , { hero = "Tirion Blizzard", loadout = "rumblo:CFMQABoECF0QABoECAMQABoECA4QABoECEYQABoECFkQAhoECB4QAQ==" }
                    , { hero = "Thrall", loadout = "rumblo:CF8QABoECFkQAhoECBMQARoECB4QARoECDsQARoECF0QABoECEYQAA==" }
                    ]
              }
            , { name = "Mekkatorque"
              , normalTeams =
                    [ { hero = "Cenarius", loadout = "rumblo:CBcQARoECBUQABoECBsQARoECEcQAhoECEQQAhoECF0QABoECFkQAg==" }
                    , { hero = "Anub'arak", loadout = "rumblo:CBAQARoECB4QABoECEcQAhoECE0QAhoECFgQARoECEwQAhoECFkQAg==" }
                    ]
              , heroicTeams =
                    [ { hero = "Arthas (Eggs)", loadout = "rumblo:CF4QARoECEQQAhoECF0QABoECEYQABoECFgQARoECBMQARoECFkQAg==" }
                    , { hero = "Arthas (Living Bomb)", loadout = "rumblo:CF4QARoECEQQAhoECF0QABoECEYQABoECAsQARoECBMQARoECFkQAg==" }
                    , { hero = "Rend", loadout = "rumblo:CEoQABoECAsQARoECFgQARoECDIQABoECCAQABoECEQQAhoECBMQAQ==" }
                    , { hero = "Ragnaros Grunts", loadout = "rumblo:CEgQARoECBsQAhoECAYQARoECFkQAhoECF0QABoECEQQAhoECFYQAQ==" }
                    , { hero = "Ragnaros Giant", loadout = "rumblo:CEgQARoECDsQARoECAYQARoECFkQAhoECF0QABoECEQQAhoECBsQAg==" }
                    ]
              }
            , { name = "Magni"
              , normalTeams =
                    [ { hero = "Sylvanas AoW", loadout = "rumblo:CFIQAhoECEQQAhoECA8QAhoECFEQAhoECAkQABoECF0QABoECFkQAg==" }
                    , { hero = "Thalnos", loadout = "rumblo:CBQQABoECA0QARoECEQQAhoECAkQABoECA8QAhoECF0QABoECFEQAg==" }
                    , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECEQQAhoECB4QARoECFEQAhoECAkQABoECF0QABoECFoQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Thaurissan", loadout = "rumblo:CCUQARoECBsQARoECEYQABoECDsQAhoECEQQAhoECFkQAhoECAkQAA==" }
                    , { hero = "Arthas", loadout = "rumblo:CF4QABoECEQQAhoECF0QABoECFkQAhoECFoQARoECAkQABoECBwQAA==" }
                    , { hero = "Sneed", loadout = "rumblo:CE4QABoECAkQABoECFEQAhoECDoQARoECFoQARoECEYQARoECFkQAg==" }
                    ]
              }
            ]
      }
    , { name = "Siege of Stormwind"
      , bosses =
            [ { name = "Marcus"
              , normalTeams =
                    [ { hero = "Doomhammer", loadout = "rumblo:CB8QAhoECFkQAhoECFgQARoECCoQABoECEsQAhoECBMQARoECEYQAA==" }
                    , { hero = "Tirion", loadout = "rumblo:CFMQABoECCoQABoECC4QABoECFgQARoECFkQAhoECEYQABoECBMQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Arthas", loadout = "rumblo:CF4QABoECEQQAhoECF0QABoECFgQARoECBMQARoECFkQAhoECEYQAA==" }
                    , { hero = "Anub'arak", loadout = "rumblo:CBAQARoECE0QAhoECEcQAhoECB4QARoECEQQAhoECFkQAhoECFgQAQ==" }
                    ]
              }
            , { name = "Allison"
              , normalTeams =
                    [ { hero = "Anub'arak", loadout = "rumblo:CBAQARoECEwQARoECEcQAhoECB4QAhoECFgQARoECFkQAhoECE0QAg==" }
                    , { hero = "Ysera", loadout = "rumblo:CFsQARoECAUQARoECA0QABoECB0QARoECFgQARoECCQQAhoECEcQAg==" }
                    ]
              , heroicTeams =
                    [ { hero = "Cenarius", loadout = "rumblo:CBcQARoECBMQARoECAsQAhoECFEQAhoECFkQAhoECEQQAhoECF0QAA==" }
                    , { hero = "Cairne", loadout = "rumblo:CBYQABoECFkQAhoECBMQARoECF0QABoECEQQAhoECFYQARoECAsQAg==" }
                    ]
              }
            , { name = "Bolvar"
              , normalTeams =
                    [ { hero = "Malfurion", loadout = "rumblo:CDkQAhoECBUQABoECB0QARoECD0QAhoECDYQARoECFkQAhoECFgQAQ==" }
                    ]
              , heroicTeams =
                    [ { hero = "Sneed", loadout = "rumblo:CE4QAhoECFkQAhoECBMQARoECDsQAhoECAkQABoECF0QABoECEYQAA==" }
                    , { hero = "Arthas", loadout = "rumblo:CF4QAhoECEQQAhoECF0QABoECEYQABoECAkQABoECB0QARoECFkQAg==" }
                    ]
              }
            ]
      }
    ]


raids : List Raid
raids =
    List.map
        (\raidInfo ->
            { name = raidInfo.name
            , bosses = List.map (\boss -> { name = boss.name, teams = boss.normalTeams ++ boss.heroicTeams }) raidInfo.bosses
            }
        )
        raidData


getBossTeamsForDifficulty : String -> String -> Difficulty -> List Team
getBossTeamsForDifficulty raidName bossName difficulty =
    raidData
        |> List.filter (\r -> r.name == raidName)
        |> List.head
        |> Maybe.map .bosses
        |> Maybe.withDefault []
        |> List.filter (\b -> b.name == bossName)
        |> List.head
        |> Maybe.map
            (\boss ->
                case difficulty of
                    Normal ->
                        boss.normalTeams

                    Heroic ->
                        boss.heroicTeams
            )
        |> Maybe.withDefault []



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ Toast.render viewToast model.toasts (Toast.config ToastMsg)
        , case model.currentView of
            RaidList ->
                viewRaidList

            DifficultySelect raidName ->
                viewDifficultySelect raidName

            BossList raidName difficulty ->
                viewBossList raidName difficulty

            TeamList raidName difficulty bossName ->
                viewTeamList raidName difficulty bossName
        ]


viewToast : List (Html.Attribute msg) -> Toast.Info String -> Html msg
viewToast attrs info =
    div (class "toast" :: attrs) [ text info.content ]


viewRaidList : Html Msg
viewRaidList =
    div []
        [ h1 [] [ text "Rumble Loadouts" ]
        , div []
            (List.map
                (\raid ->
                    button
                        [ class "btn"
                        , onClick (SelectRaid raid.name)
                        ]
                        [ text raid.name ]
                )
                raids
            )
        ]


viewDifficultySelect : String -> Html Msg
viewDifficultySelect raidName =
    div []
        [ button [ class "btn back-btn", onClick BackToRaids ] [ text "← Back" ]
        , h2 [] [ text raidName ]
        , button
            [ class "btn"
            , onClick (SelectDifficulty raidName Normal)
            ]
            [ text "Normal" ]
        , button
            [ class "btn"
            , onClick (SelectDifficulty raidName Heroic)
            ]
            [ text "Heroic" ]
        ]


viewBossList : String -> Difficulty -> Html Msg
viewBossList raidName difficulty =
    let
        difficultyText =
            case difficulty of
                Normal ->
                    "Normal"

                Heroic ->
                    "Heroic"

        raid =
            List.filter (\r -> r.name == raidName) raids |> List.head
    in
    div []
        [ button [ class "btn back-btn", onClick (BackToDifficulty raidName) ] [ text "← Back" ]
        , h2 [] [ text (raidName ++ " - " ++ difficultyText) ]
        , case raid of
            Just r ->
                div []
                    (List.map
                        (\boss ->
                            button
                                [ class "btn"
                                , onClick (SelectBoss raidName difficulty boss.name)
                                ]
                                [ text boss.name ]
                        )
                        r.bosses
                    )

            Nothing ->
                text "Raid not found"
        ]


viewTeamList : String -> Difficulty -> String -> Html Msg
viewTeamList raidName difficulty bossName =
    let
        difficultyText =
            case difficulty of
                Normal ->
                    "Normal"

                Heroic ->
                    "Heroic"

        teams =
            getBossTeamsForDifficulty raidName bossName difficulty
    in
    div []
        [ button [ class "btn back-btn", onClick (BackToBosses raidName difficulty) ] [ text "← Back" ]
        , h2 [] [ text (bossName ++ " - " ++ difficultyText) ]
        , if List.isEmpty teams then
            div [ style "text-align" "center", style "padding" "2rem", style "color" "#999" ]
                [ text "No teams available for this difficulty" ]

          else
            div []
                (List.map
                    (\team ->
                        div [ class "loadout" ]
                            [ span [] [ text team.hero ]
                            , button
                                [ class "btn copy-btn"
                                , onClick (CopyLoadout team.loadout)
                                ]
                                [ text "Copy" ]
                            ]
                    )
                    teams
                )
        ]
