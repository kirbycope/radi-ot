# radi-ot (Radio + Godot) 📻

**radi-ot** is a 3D audio streaming addon for Godot 4.8 that streams live Seattle radio stations over the internet, supports Steam (Forward+) and Web (Compatibility) exports, features an in-game CanvasLayer HUD with `[J]` / `[L]` tuning controls, optional buffering static, and an `urgent_bulletin()` API for game narrative progression.

---

## 🌟 Features

- **3D Spatial Audio:** `RadiOtPlayer3D` extends `AudioStreamPlayer3D`, providing realistic 3D distance attenuation, unit size, and panning.
- **Seattle Radio Presets (.tres):**
  - **KEXP 90.3 FM** (Indie / Alternative / Eclectic)
  - **C89.5 KNHC** (Electronic / Dance / House)
  - **KNKX 88.5 FM** (Jazz / Blues / NPR News)
  - **Classical KING 98.1 FM** (Classical)
  - **KUOW 94.9 FM** (Puget Sound Public Radio & News)
  - **KBCS 91.3 FM** (Community Radio)
- **Urgent Bulletin System:** Call `urgent_bulletin(stream, text, duration)` to pause the live radio station and broadcast emergency story events or news flashes. When the bulletin finishes, the live stream smoothly resumes.
- **Retro-Modern CanvasLayer HUD:** Displays station frequency, call sign, genre, live signal indicator, animated dial bar, keyboard shortcuts, and Emergency Alert banners.
- **Tuning Controls:** `[J]` (Previous Station), `[L]` (Next Station), and `[M]` (Power Toggle).
- **Procedural FM Static:** Realistic white/pink noise static plays seamlessly while buffering or switching stations.
- **Dual-Platform Architecture:** Uses native WebAudio / JavaScript bridge on Web builds and HTTP streaming on Steam / Desktop builds.

---

## 🚀 Quick Start

1. Enable the **radi-ot** plugin in **Project Settings > Plugins**.
2. Add a `RadiOtPlayer3D` node to your 3D scene (or instance `res://addons/radi_ot/scenes/radi_ot_player_3d.tscn`).
3. Press `[L]` to cycle forward through Seattle radio stations or `[J]` to cycle backward.

---

## 🎮 Narrative Story Bulletins (`urgent_bulletin`)

To interrupt the radio broadcast for story progression:

```gdscript
@onready var radio: RadiOtPlayer3D = $RadiOtPlayer3D

func trigger_story_event() -> void:
    var emergency_audio: AudioStream = preload("res://assets/audio/alien_invasion_news.ogg")
    radio.urgent_bulletin(
        emergency_audio,
        "Breaking News: Strange lights reported over the Space Needle!",
        12.0 # Duration in seconds
    )
```

---

## 📻 Creating Custom Stations (`.tres`)

Create a new `RadioStation` resource in the FileSystem dock:

```text
station_name: "My Seattle Station"
call_sign: "KSEA"
frequency: 101.5
stream_url: "https://stream.example.com/live.aac"
genre: "Synthwave / Cyberpunk"
tagline: "Beats for the Emerald City"
```

Add your station to a `RadioStationCollection` resource or pass it to `RadiOtPlayer3D.station_collection`.

---

## 🧪 Testing

Run the automated GUT unit test suite via the command line or from the Godot Editor GUT panel:

```bash
godot --headless -s addons/gut/gut_cmdln.gd
```

