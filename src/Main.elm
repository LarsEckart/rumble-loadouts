port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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
    ( { currentView = RaidList }
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
            ( model
            , copyToClipboard loadout
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
            , normalTeams = [ { hero = "Anub'arak", loadout = "rumblo:CBAQARoECB4QARoECEcQAhoECAkQABoECE0QAhoECEwQAhoECDIQAA==" } ]
            , heroicTeams = 
                [ { hero = "Maiev", loadout = "rumblo:CDgQAhoECEcQAhoECFoQARoECCQQABoECDIQABoECFgQARoECAkQAA==" }
                , { hero = "Anub'arak", loadout = "rumblo:CBAQARoECB4QARoECEcQAhoECAkQABoECE0QAhoECEwQAhoECDIQAA==" }
                ]
            }
          , { name = "Magmadar"
            , normalTeams = [ { hero = "Doomhammer", loadout = "rumblo:CB8QABoECBwQABoECFgQARoECB0QARoECAcQABoECAgQAhoECEQQAg==" } ]
            , heroicTeams = [ { hero = "Doomhammer", loadout = "rumblo:CB8QABoECBwQABoECFgQARoECB0QARoECAcQABoECAgQAhoECEQQAg==" } ]
            }
          , { name = "Gehennas"
            , normalTeams = [ { hero = "Rivendare", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECEcQAhoECBMQARoECCYQAhoECDsQAg==" }, { hero = "Rivendare (pilot)", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECEcQAhoECBMQARoECCYQAhoECDsQAg==" } ]
            , heroicTeams = [ { hero = "Rivendare", loadout = "rumblo:CBIQAhoECDoQARoECEQQAhoECEcQAhoECBMQARoECCYQAhoECDsQAg==" } ]
            }
          , { name = "Garr"
            , normalTeams = 
                [ { hero = "Cenarius", loadout = "rumblo:CBcQARoECBUQABoECBsQARoECAMQABoECFkQAhoECEYQABoECF0QAA==" }
                , { hero = "Sneed", loadout = "rumblo:CE4QARoECEsQAhoECFkQAhoECDsQAhoECEEQABoECDoQARoECF0QAA==" }
                ]
            , heroicTeams = 
                [ { hero = "Thalnos", loadout = "rumblo:CBQQABoECCwQABoECEQQAhoECA0QARoECFkQAhoECF0QABoECAkQAA==" }
                , { hero = "Cenarius", loadout = "rumblo:CBcQARoECBUQABoECA0QARoECEQQAhoECFkQAhoECEYQABoECF0QAA==" }
                ]
            }
          , { name = "Geddon"
            , normalTeams = 
                [ { hero = "Ragnaros", loadout = "rumblo:CEgQABoECBsQABoECCYQAhoECDEQABoECDIQABoECF0QARoECCsQAg==" }
                , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECBEQAhoECBsQARoECCYQAhoECBkQABoECDEQABoECCsQAQ==" }
                ]
            , heroicTeams = 
                [ { hero = "Ragnaros", loadout = "rumblo:CEgQABoECBsQABoECCYQAhoECDEQABoECDIQABoECF0QARoECCsQAg==" }
                , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECBEQAhoECB4QARoECCYQAhoECBkQABoECBsQARoECCsQAg==" }
                ]
            }
          , { name = "Golemagg"
            , normalTeams = 
                [ { hero = "Jaina Rime", loadout = "rumblo:CDcQARoECDEQARoECB0QABoECAgQAhoECCwQABoECEwQAhoECAcQAA==" }
                , { hero = "Jaina Blizzard", loadout = "rumblo:CDcQARoECB0QARoECAMQABoECAgQAhoECEcQAhoECDEQARoECAcQAA==" }
                ]
            , heroicTeams = 
                [ { hero = "Jaina", loadout = "rumblo:CDcQARoECDMQARoECF0QABoECAgQAhoECEQQAhoECEwQAhoECAcQAA==" }
                , { hero = "Ragnaros", loadout = "rumblo:CEgQARoECCQQAhoECDsQARoECDEQABoECF0QARoECEQQAhoECEwQAg==" }
                ]
            }
          , { name = "Ragnaros"
            , normalTeams = 
                [ { hero = "Malfurion", loadout = "rumblo:CDkQAhoECA8QAhoECDYQARoECBEQAhoECB0QARoECFgQARoECFoQAQ==" }
                , { hero = "Drakkisath", loadout = "rumblo:CCEQABoECBsQARoECFgQARoECDEQARoECB0QARoECF0QABoECEsQAg==" }
                ]
            , heroicTeams = 
                [ { hero = "Drakkisath Fast", loadout = "rumblo:CCEQABoECBsQARoECFgQARoECC4QABoECB0QARoECCMQARoECEsQAg==" }
                , { hero = "Malfurion", loadout = "rumblo:CDkQAhoECBUQAhoECC4QABoECAkQABoECB0QARoECFgQARoECFoQAQ==" }
                ]
            }
          ]
      }
    , { name = "Ironforge"
      , bosses = 
          [ { name = "Thiefcatchers"
            , normalTeams = 
                [ { hero = "Grom", loadout = "rumblo:CDAQAhoECFEQAhoECEsQAhoECB4QARoECFkQAhoECEYQABoECF0QAA==" }
                , { hero = "Thrall", loadout = "rumblo:CF8QABoECFkQAhoECFEQARoECA8QAhoECAUQARoECF0QAhoECEQQAg==" }
                , { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECAUQARoECB4QARoECFkQAhoECEQQAhoECF0QABoECFEQAA==" }
                ]
            , heroicTeams = 
                [ { hero = "Cairne", loadout = "rumblo:CBYQABoECFkQAhoECFEQAhoECF0QABoECEYQABoECB4QARoECAsQAQ==" }
                , { hero = "Tirion Blizzard", loadout = "rumblo:CFMQABoECF0QABoECAMQABoECA4QABoECEYQABoECFkQAhoECB4QAQ==" }
                , { hero = "Thrall", loadout = "rumblo:CF8QABoECFkQAhoECBMQARoECB4QARoECDsQARoECF0QABoECEYQAA==" }
                ]
            }
          , { name = "Mekkatorque"
            , normalTeams = 
                [ { hero = "Anub'arak", loadout = "rumblo:CBAQARoECB4QABoECEcQAhoECE0QAhoECFgQARoECEwQAhoECFkQAg==" }
                , { hero = "Cenarius", loadout = "rumblo:CBcQARoECBUQABoECBsQARoECEcQAhoECEQQAhoECF0QABoECFkQAg==" }
                ]
            , heroicTeams = 
                [ { hero = "Arthas", loadout = "rumblo:CF4QARoECEQQAhoECF0QABoECEYQABoECFgQARoECBMQARoECFkQAg==" }
                , { hero = "Rend", loadout = "crumblo:CEoQABoECAsQARoECFgQARoECDIQABoECCAQABoECEQQAhoECBMQAQ==" }
                , { hero = "Ragnaros Grunts", loadout = "crumblo:CEgQARoECBsQAhoECAYQARoECFkQAhoECF0QABoECEQQAhoECFYQAQ==" }
                , { hero = "Ragnaros Giant", loadout = "rumblo:CEgQARoECDsQARoECAYQARoECFkQAhoECF0QABoECEQQAhoECBsQAg==" }
                ]
            }
          , { name = "Magni"
            , normalTeams = 
                [ { hero = "Sylvanas", loadout = "rumblo:CFIQAhoECEQQAhoECB4QARoECFEQAhoECAkQABoECF0QABoECFoQAQ==" }
                , { hero = "Thalnos", loadout = "rumblo:CBQQABoECA0QARoECEQQAhoECAkQABoECA8QAhoECF0QABoECFEQAg==" }
                ]
            , heroicTeams = 
                [ { hero = "Thaurissan", loadout = "rumblo:CCUQARoECBsQARoECEYQABoECDsQAhoECEQQAhoECFkQAhoECAkQAA==" }
                , { hero = "Sneed", loadout = "rumblo:CE4QABoECAkQABoECFEQAhoECDoQARoECFoQARoECEYQARoECFkQAg==" }
                , { hero = "Arthas", loadout = "rumblo:CF4QABoECEQQAhoECF0QABoECFkQAhoECFoQARoECAkQABoECBwQAA==" }
                ]
            }
          ]
      }
    , { name = "Horde Event"
      , bosses = 
          [ { name = "Mythic Bosses"
            , normalTeams = 
                [ { hero = "Thrall Mythic Onu", loadout = "rumblo:CEMQABoECFkQAhoECEYQABoECF0QARoECEQQAhoECB4QARoECE8QAg==" }
                , { hero = "Gazlowe Mythic Arthas", loadout = "rumblo:CF4QABoECEQQAhoECF0QABoECFkQAhoECEYQABoECB4QARoECCQQAg==" }
                , { hero = "Magatha Mythic Arthas", loadout = "rumblo:CF4QABoECEQQAhoECF0QABoECFkQAhoECEYQABoECB4QARoECFgQAQ==" }
                ]
            , heroicTeams = []
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
                    Normal -> boss.normalTeams
                    Heroic -> boss.heroicTeams
            )
        |> Maybe.withDefault []


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ case model.currentView of
            RaidList ->
                viewRaidList

            DifficultySelect raidName ->
                viewDifficultySelect raidName

            BossList raidName difficulty ->
                viewBossList raidName difficulty

            TeamList raidName difficulty bossName ->
                viewTeamList raidName difficulty bossName
        ]

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
        difficultyText = case difficulty of
            Normal -> "Normal"
            Heroic -> "Heroic"
        
        raid = List.filter (\r -> r.name == raidName) raids |> List.head
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
        difficultyText = case difficulty of
            Normal -> "Normal"
            Heroic -> "Heroic"
        
        teams = getBossTeamsForDifficulty raidName bossName difficulty
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