# MIDI Marker Tool

A standalone companion to [Beat Match Lab](../beatmatch-lab): a dedicated editor for annotating a single MIDI track with precise, labeled marker points (downbeats, phrase starts, breaks) — then exporting a new `.mid` with them baked in as standard MIDI Marker meta-events, so the data travels with the file and doesn't depend on any particular app reading it.

This tool does nothing else — no mixing, no beatmatching. Just: load a track, see every note, play it back with real instruments, drop markers exactly where you want them, export.

## Running it

**Don't open `index.html` directly** (double-clicking it loads it as a `file://` URL) — browsers block the fetches this app needs (the AudioWorklet module, the soundfont) from `file://`.

Easiest: double-click **`Start MIDI Marker Tool.command`**. It starts a local server and opens your browser to it.

Or run any static file server yourself, e.g.:

```bash
python3 -m http.server 8100
```

and open `http://localhost:8100/index.html`.

## What it does

- **Load any `.mid`/`.midi` file** (file picker or drag-and-drop) and see its entire note content rendered as a piano roll, with bar/beat gridlines derived from the file's own tempo and time signature.
- **Play it back** through a real SoundFont2 synthesizer ([SpessaSynth](https://github.com/spessasus/SpessaSynth), via an AudioWorklet, loaded with `soundfonts/GeneralUserGS.sf3`) — the same engine Beat Match Lab uses, so what you hear while placing markers matches what you'll hear there.
- **Zoom and scrub** via the zoom/position sliders, or click anywhere on the roll to seek there.
- **Snap to grid** (on by default) — toggle it off, or switch it between beat/bar granularity, so a click-to-seek lands exactly on a gridline instead of an arbitrary pixel. Only affects click-to-seek; a live tap (M) always lands exactly where you tapped, since that's feel-based by design.
- **Drop a labeled marker** at the current playhead position — either live while listening (press **M**, or click "+ Drop marker at playhead", DJ tap-along style) or precisely after seeking to an exact spot. Space bar toggles play/pause.
- **Edit markers** in the list below the roll: rename inline, nudge ±10ms with the ◀/▶ buttons, click a marker's time to jump the playhead there, or delete it.
- **Export** writes every marker as a real MIDI [Marker meta-event](https://www.recordingblogs.com/wiki/marker-meta-event-midi) (type 0x06) at its exact tick position, via `@tonejs/midi`'s own serializer — nothing about the original notes/tracks is touched. Re-opening an exported file shows its markers back in the list for further editing.

## Marker naming convention

MIDI's Marker event is just a tick position plus a text string — there's no built-in taxonomy of "downbeat" vs. "phrase" vs. "break". This tool doesn't impose one either; name markers however the consuming app (e.g. Beat Match Lab) expects to parse them, for example: `downbeat`, `phrase`, `break:in`, `break:out`.

## Known limitations

- Assumes a single, constant tempo and time signature for grid lines (the first one found in the file); a track with tempo changes logs a note about this on load but the grid won't reflect them.
- No vertical zoom — a track using a very wide pitch range will show thin note rows.
- Seeking mid-playback won't retrigger notes that were already sustaining across the seek point (standard scrubbing behavior).
