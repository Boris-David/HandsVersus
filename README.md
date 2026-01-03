# HandsVersus

HandsVersus is a mobile game designed to challenge your quick thinking in a classic game of Rock, Paper, Scissors with a twist!

## Game Mechanics & Rules

The game operates on a simple, fast-paced loop:

1.  **App's Move**: Each turn, the app will randomly select one of the three classic moves: Rock, Paper, or Scissors.
2.  **The Challenge**: Simultaneously, the app will randomly alternate between prompting you to either **DEFEAT ME** (WIN) or **YOU HAVE TO LOSE** against its chosen move.
3.  **Your Turn**: As the player, you must quickly tap the correct counter-move to fulfill the app's challenge.
    *   **Win Condition**: If the app chose "Rock" and prompted "Defeat me", you need "Paper".
    *   **Lose Condition**: If the app chose "Rock" and prompted "Lose", you need "Scissors".
4.  **Scoring**:
    *   **Win**: +1 point for you if you fulfill the challenge.
    *   **Loss**: +1 point for the AI if you fail the challenge or pick a move that doesn't match the goal.
    *   **Draw**: +1 point to the Draw counter if moves are identical (and mission wasn't specifically "Lose").
5.  **Game End**: The game concludes after 3 questions (configurable), at which point your final score is displayed via an alert.

## Visual Assets & Styles

The game features high-quality assets generated and managed by a dedicated Python script (`setup_handsversus.py`). 

### Available Visual Styles:
Every time you launch the app, a random style is chosen among:
-   **Fluent (3D/Modern)**: Microsoft Fluent Emojis for a contemporary 3D look.
-   **Classic (Detailed)**: Apple (Legacy) icons for a highly detailed, iconic feel.
-   **Retro (Web 2.0)**: Facebook (Legacy) emojis for a nostalgic aesthetic.
-   **Sketch (Hand-drawn)**: OpenMoji (Color) for a hand-drawn artistic look.
-   **Flat (Classic)**: Twemoji for a clean, flat design.
-   **Cartoon (Fun)**: Google Noto Color Emojis for a vibrant, rounded feel.
-   **Minimalist (Epuré)**: OpenMoji Black (Line Art) for a sleek, sophisticated black-and-white look.

### App Icons:
The project includes a complete set of custom-designed App Icons:
- **Light Mode**: Vibrant 3D composition.
- **Dark Mode**: High-contrast icons on deep charcoal background.
- **Tinted (iOS 18)**: Monochrome vectors designed for system-wide personalization.

## Development

- **Language**: Swift / SwiftUI
- **Asset Management**: Python 3 + `sips` (macOS Image Processing)
- **Architecture**: Modular ViewBuilders with State-driven logic.

---
*Created as part of Hacking With Swift - Technical Project 2*