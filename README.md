# IslandBuddy

Un companion animato che vive nella Dynamic Island e ti avvisa di task/promemoria/eventi, con stati d'animo (idle, alert, happy, impatient, sleepy, tapped) e un colore associato a ciascuno.

## Struttura

- `project.yml` — spec XcodeGen, genera il progetto Xcode (non versionato: lo crea la CI).
- `Sources/Shared` — modelli condivisi tra app e widget extension (`BuddyMood`, `BuddyActivityAttributes`, `BuddyItem`).
- `Sources/IslandBuddy` — app principale: legge Reminders/Calendar (EventKit) e avvia/aggiorna la Live Activity.
- `Sources/IslandBuddyWidget` — widget extension: la vista della Dynamic Island e gli App Intents per i bottoni "Fatto"/"Rimanda".
- `Resources/IslandBuddy/Assets.xcassets` — asset catalog. Gli imageset `buddy_*` sono vuoti: vanno riempiti con le tue immagini.

## Prima di buildare: metti le immagini del personaggio

Per ogni stato, aggiungi dentro `Resources/IslandBuddy/Assets.xcassets/buddy_<stato>.imageset/` i file:

- `buddy_<stato>.png` (1x)
- `buddy_<stato>@2x.png` (2x)
- `buddy_<stato>@3x.png` (3x)

Stati: `idle`, `alert`, `happy`, `impatient`, `sleepy`, `tapped`. PNG con sfondo trasparente, stessa inquadratura per tutti.

## Build (in cloud, senza Xcode in locale)

Il push su `main` fa partire una GitHub Action (`.github/workflows/build.yml`) che:
1. genera il progetto Xcode con XcodeGen,
2. compila un `.app` **non firmato** per dispositivo reale,
3. lo impacchetta in `IslandBuddy-unsigned.ipa` e lo carica come artifact scaricabile dalla pagina della Action.

## Installazione sul telefono (senza Xcode)

1. Scarica `IslandBuddy-unsigned.ipa` dall'artifact della build.
2. Installa [AltStore](https://altstore.io) sul tuo Mac (AltServer) e sul telefono.
3. Con il telefono sulla stessa wifi del Mac e AltServer aperto, apri AltStore sul telefono e installa quell'`.ipa`.
4. Con Apple ID gratuito la firma scade ogni ~7 giorni: AltStore la rinnova da solo se il Mac è acceso e raggiungibile in quel momento, altrimenti va rifatto a mano.

## Limiti noti (v1)

- L'aggiornamento della Live Activity avviene quando apri l'app (foreground), non in tempo reale in background: per quello servirebbe un push server (APNs, tipo push "liveactivity"), non ancora implementato.
- Collegata solo a Reminders/Calendar; Telegram/Mail sono fasi successive.
