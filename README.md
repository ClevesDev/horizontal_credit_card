# horizontal_credit_card

A modern, customizable horizontal credit and debit card UI widget for Flutter fintech applications with interactive 3D perspective tilt, gyroscopic specular reflection, 180° flip animation, tap-to-reveal privacy masking, and frozen card states.

Built with **zero external dependencies** on top of the native Flutter SDK.

---

## Features

* **ISO/IEC 7810 ID-1 Standard Ratio:** Native landscape aspect ratio (1.586 : 1) tailored for classical horizontal payment cards.
* **Interactive 3D Perspective Physics:** Pointer drag and gyroscopic angle deflection calculated via 4x4 homogeneous transformation matrices (`Matrix4`).
* **Dynamic Specular Lighting:** Ambient light sweep reacting dynamically to tilt coordinate changes.
* **180° Perspective Flip:** Smooth hardware-accelerated 3D rotation revealing the magnetic stripe, signature panel, and CVV on the back.
* **Sensitive Data Masking:** Tap-to-reveal privacy masking for 16-digit card numbers and CVV codes.
* **Financial Security States:** Built-in support for `isFrozen` (frosted crystal overlay with padlock) and `isExpired` states.
* **Slot Injections:** Custom widget slots for bank branding logos and payment networks.
* **Zero External Dependencies:** Built purely on Flutter core SDK for 100% enterprise compliance, rock-solid stability, and 120 FPS performance.

---

## Getting Started

Add `horizontal_credit_card` to your `pubspec.yaml`:

```yaml
dependencies:
  horizontal_credit_card: ^0.0.1
```

Or install it from your terminal:

```bash
flutter pub add horizontal_credit_card
```

Import it in your Dart code:

```dart
import 'package:horizontal_credit_card/horizontal_credit_card.dart';
```

---

## Usage Example

```dart
import 'package:flutter/material.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

class CreditCardDemo extends StatefulWidget {
  const CreditCardDemo({super.key});

  @override
  State<CreditCardDemo> createState() => _CreditCardDemoState();
}

class _CreditCardDemoState extends State<CreditCardDemo> {
  bool _isMasked = false;
  bool _isFrozen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      body: Center(
        child: HorizontalCard(
          cardNumber: '4532 8812 9043 7721',
          cardHolder: 'Alexander Wright',
          expiryDate: '09/29',
          cvv: '842',
          brand: CardBrand.visa,
          cardTheme: HorizontalCardTheme.black,
          isMasked: _isMasked,
          isFrozen: _isFrozen,
          onTap: () {
            // Optional tap callback, or leave null for auto-flip
          },
        ),
      ),
    );
  }
}
```

---

## Curated Presets Library (`CardPresets`)

The package includes ready-to-use production card themes categorized into specialized collections:

### 1. Geometric Patterns Collection
* `CardPresets.crimsonOrbit`: Vibrant rose crimson and ruby gradient with intersecting geometric orbital rings.
* `CardPresets.royalAmethyst`: Royal amethyst purple gradient with intersecting geometric orbital rings.
* `CardPresets.oceanAzure`: Ocean cyan and azure gradient with intersecting geometric orbital rings.
* `CardPresets.midnightSapphire`: Deep midnight sapphire navy with luminous geometric orbital rings.
* `CardPresets.amexGreen`: Heritage American Express Green Card with banknote guilloche and centurion watermark.
* `CardPresets.cyberMesh`: High-tech cybersecurity card with isometric grid and cyan glow.

### 2. Minimalist Solid Colors Collection
* `CardPresets.solidMatteBlack`: Stealth matte black finish with silver typography.
* `CardPresets.solidCeramicWhite`: Pure ceramic white card with obsidian typography (Apple Card style).
* `CardPresets.solidCobaltBlue`: International debit cobalt blue with 3D embossed relief.
* `CardPresets.solidHotCoral`: Modern neobank hot coral finish (Monzo style).
* `CardPresets.solidNubankPurple`: Iconic solid electric purple (Nubank style).
* `CardPresets.solidEmerald`: Deep Swiss private banking solid emerald green.

### 3. Luxury Metals Collection
* `CardPresets.obsidianBlack`: Deep obsidian carbon finish with silver borders.
* `CardPresets.appleTitanium`: Minimalist brushed platinum titanium finish.
* `CardPresets.electricPurple`: Vibrant neobank purple gradient.

---

## Physical Typography Relief (`CardTextFinish`)

* `CardTextFinish.embossed`: Stamped physical 3D letterpress with dynamic directional bevel highlights and deep cast shadows.
* `CardTextFinish.silverFoil`: Liquid chrome silver platinum foil stamping.
* `CardTextFinish.goldFoil`: Directional hot-stamped gold bullion foil with specular glint.
* `CardTextFinish.flat`: Crisp anti-aliased digital ink printing.

---

## Parameters Reference

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `cardNumber` | `String` | **Required** | 16-digit (or 15-digit) card number |
| `cardHolder` | `String` | **Required** | Cardholder full name |
| `expiryDate` | `String` | **Required** | Expiration date (MM/YY) |
| `cvv` | `String` | **Required** | 3 or 4 digit security code |
| `brand` | `CardBrand` | `CardBrand.visa` | Payment network brand |
| `cardTheme` | `HorizontalCardTheme` | `HorizontalCardTheme.black` | Theme configuration |
| `textFinish` | `CardTextFinish?` | `null` | Typography finish override |
| `thickness` | `double` | `3.5` | Physical 3D thickness (rim edge) in dp |
| `width` | `double` | `320.0` | Outer card width |
| `height` | `double?` | `width / 1.586` | Outer card height |
| `isFlipped` | `bool` | `false` | Programmatic flip to back |
| `isMasked` | `bool` | `false` | Mask sensitive numbers |
| `isFrozen` | `bool` | `false` | Frosted ice overlay |
| `isExpired` | `bool` | `false` | Expired banner overlay |
| `bankLogo` | `Widget?` | `null` | Custom top-right logo |
| `enableTilt` | `bool` | `true` | Interactive 3D tilt |
| `onTap` | `VoidCallback?` | `null` | Tap callback |
| `onFlip` | `ValueChanged<bool>?` | `null` | Flip state listener |

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
