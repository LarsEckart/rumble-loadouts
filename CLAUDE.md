# Claude Code Project Context

## Project Overview
Mobile-first Elm web app for Rumble game loadouts. Users can browse raids → difficulty → boss → copy team loadouts to clipboard.

## Tech Stack
- **Elm 0.19.1** - Frontend framework
- **Vanilla CSS** - Mobile-first styling
- **Netlify** - Hosting and deployment
- **JavaScript Ports** - Clipboard functionality

## Key Files
- `src/Main.elm` - Main application logic and data
- `index.html` - HTML template with embedded styles
- `build_project.sh` - Build script for production
- `elm.json` - Elm dependencies

## Data Structure
Loadouts organized as:
```
RaidData → BossData → normalTeams/heroicTeams → Team (hero, loadout)
```

## Build & Deploy
- **Local:** `./build_project.sh`
- **Netlify:** Build command: `./build_project.sh`, Publish: `dist`
- **Live URL:** https://rumble-loadouts.netlify.app/

## Adding New Loadouts
Update the `raidData` list in `src/Main.elm` with new teams in the format:
```elm
{ hero = "Hero Name", loadout = "rumblo:..." }
```

## Development Workflow
After every development change, run `./build_project.sh` to compile and test the application.