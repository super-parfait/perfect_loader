# perfect_loader

Indeterminate **circular progress** with a **scalloped (wavy) ring**, similar in spirit to the Google Play Store install animation. Implemented with `CustomPaint` only (no images).

## Install

```yaml
dependencies:
  perfect_loader: ^0.1.0
```

## Usage

```dart
import 'package:perfect_loader/perfect_loader.dart';

const PerfectLoader(
  size: 56,
  activeColor: Color(0xFF1A73E8),
  trackColor: Color(0xFF8AB4F8),
)
```

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `size` | `56` | Square width/height. |
| `strokeWidth` | auto | Ring thickness; derived from `size` if omitted. |
| `activeColor` | Play blue | Rotating arc. |
| `trackColor` | Light blue | Full wavy track (slightly transparent when painted). |
| `duration` | 1400 ms | One rotation of the arc. |
| `sweepFraction` | `0.38` | Arc length as fraction of perimeter. |
| `waveCount` | `16` | Number of scallops. |

## Publishing to pub.dev

1. Replace `USERNAME` in `pubspec.yaml` (`homepage`, `repository`, `issue_tracker`) with your GitHub (or remove `homepage` / point to pub package page).
2. Run `dart pub publish --dry-run`, then `dart pub publish`.
3. Ensure you have verified publisher on pub.dev.

## Integrating into an existing app (e.g. Dughu)

1. Add the dependency (path while developing, then pub.dev):

   ```yaml
   dependencies:
     perfect_loader:
       path: ../perfect_loader  # adjust
   ```

2. Replace the local widget import with  
   `package:play_store_wavy_loader/play_store_wavy_loader.dart`.

3. Rename `PlayStoreWavyVideoLoader` → `PlayStoreWavyLoader` (or wrap once in your app).

4. Pass your brand colors, e.g.  
   `activeColor: Color(0xFFB66B34)`,  
   `trackColor: Color.lerp(thatColor, Colors.white, 0.48)!`.

## License

MIT — see [LICENSE](LICENSE).
