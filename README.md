# Rumble Loadouts

[![Netlify Status](https://api.netlify.com/api/v1/badges/dd0eb07a-ed7f-4c73-8da0-1b53673a5a0a/deploy-status)](https://app.netlify.com/projects/rumble-loadouts/deploys)

Mobile-first web app for looking up and copying team loadouts for Rumble raids.

🚀 **Live App:** https://rumble-loadouts.netlify.app/

## Features

- Browse loadouts by raid (Molten Core, Ironforge, Horde Event)
- Filter by difficulty (Normal/Heroic)
- One-click copy to clipboard
- Mobile-optimized interface
- Offline functionality with Service Worker

## Screenshots

<div align="center">

### Mobile Interface

<img src="screenshots/mobile-home.png" width="300" alt="Home screen showing raid selection">

*Main screen with raid selection*

<img src="screenshots/mobile-difficulty.png" width="300" alt="Difficulty selection for Molten Core">

*Difficulty selection (Normal/Heroic)*

<img src="screenshots/mobile-bosses.png" width="300" alt="Boss list for Molten Core Normal">

*Boss selection screen*

<img src="screenshots/mobile-loadouts.png" width="300" alt="Loadouts for Ragnaros with copy buttons">

*Team loadouts with one-click copy*

</div>

## Development

```bash
./build_project.sh
```

Built with Elm and deployed on Netlify.
