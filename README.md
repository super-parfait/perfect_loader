# perfect_loader

Indicateur de progression circulaire indéterminé avec un anneau ondulé (scalloped), similaire à l'animation d'installation du Google Play Store. Implémenté uniquement avec `CustomPaint` (pas d'images).

## Installation

```yaml
dependencies:
  perfect_loader: ^0.1.0
```

## Utilisation

```dart
import 'package:perfect_loader/perfect_loader.dart';

const PerfectLoader(
  size: 56,
  activeColor: Color(0xFF1A73E8),
  trackColor: Color(0xFF8AB4F8),
)
```

### Paramètres

| Paramètre | Défaut | Description |
|-----------|--------|-------------|
| `size` | `56` | Largeur/hauteur carrée. |
| `strokeWidth` | auto | Épaisseur de l'anneau ; dérivée de `size` si omis. |
| `activeColor` | Bleu Play | Arc rotatif. |
| `trackColor` | Bleu clair | Anneau ondulé complet (légèrement transparent lors du dessin). |
| `duration` | 1400 ms | Une rotation complète de l'arc. |
| `sweepFraction` | `0.38` | Longueur de l'arc en fraction du périmètre. |
| `waveCount` | `16` | Nombre de scallops. |

## Publication sur pub.dev

1. Remplacez `USERNAME` dans `pubspec.yaml` (`homepage`, `repository`, `issue_tracker`) par votre nom d'utilisateur GitHub (ou supprimez `homepage` / pointez vers la page du package pub).
2. Exécutez `dart pub publish --dry-run`, puis `dart pub publish`.
3. Assurez-vous d'avoir un éditeur vérifié sur pub.dev.

## Intégration dans une application existante (ex. Dughu)

1. Ajoutez la dépendance (chemin local pendant le développement, puis pub.dev) :

   ```yaml
   dependencies:
     perfect_loader:
       path: ../perfect_loader  # ajustez
   ```

2. Remplacez l'import du widget local par  
   `package:perfect_loader/perfect_loader.dart`.

3. Renommez `PlayStoreWavyLoader` → `PerfectLoader` (ou enveloppez une fois dans votre app).

4. Passez vos couleurs de marque, ex.  
   `activeColor: Color(0xFFB66B34)`,  
   `trackColor: Color.lerp(thatColor, Colors.white, 0.48)!`.

## Licence

MIT — voir [LICENSE](LICENSE).
