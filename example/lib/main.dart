import 'package:flutter/material.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  runApp(const HorizontalCardDemoApp());
}

class HorizontalCardDemoApp extends StatelessWidget {
  const HorizontalCardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Credit Card Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1D),
      ),
      home: const HorizontalCardDemoScreen(),
    );
  }
}

enum PresetCategory { geometric, solid, luxury }

class HorizontalCardDemoScreen extends StatefulWidget {
  const HorizontalCardDemoScreen({super.key});

  @override
  State<HorizontalCardDemoScreen> createState() =>
      _HorizontalCardDemoScreenState();
}

class _HorizontalCardDemoScreenState extends State<HorizontalCardDemoScreen> {
  PresetCategory _selectedCategory = PresetCategory.geometric;
  HorizontalCardTheme _currentTheme = CardPresets.crimsonOrbit;
  CardBrand _currentBrand = CardBrand.mastercard;
  CardTextFinish _currentFinish = CardTextFinish.embossed;
  String _cardNumber = '5412 7523 9812 4568';
  String _cardHolder = 'ALEXANDER WRIGHT';
  String _expiryDate = '08/29';
  String _cvv = '456';
  double _thickness = 3.5;
  bool _isMasked = false;
  bool _isFrozen = false;

  void _selectPreset(HorizontalCardTheme theme,
      {CardBrand? brand, String? number, String? holder}) {
    setState(() {
      _currentTheme = theme;
      _currentFinish = theme.textFinish;

      if (brand != null) {
        _currentBrand = brand;
      }
      if (number != null) {
        _cardNumber = number;
      }
      if (holder != null) {
        _cardHolder = holder;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Horizontal Card 3D Studio',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // The 3D Horizontal Card with Extruded Thickness and Embossed Letterpress
              Center(
                child: HorizontalCard(
                  cardNumber: _cardNumber,
                  cardHolder: _cardHolder,
                  expiryDate: _expiryDate,
                  cvv: _cvv,
                  brand: _currentBrand,
                  cardTheme: _currentTheme,
                  textFinish: _currentFinish,
                  thickness: _thickness,
                  isMasked: _isMasked,
                  isFrozen: _isFrozen,
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                'Tap card to flip • Drag to inspect 3D physical thickness and light reflection',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // Category Filter Tab (Geometric vs Solid vs Luxury)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildCategoryTab(
                      label: 'Geometric Patterns',
                      category: PresetCategory.geometric,
                    ),
                    _buildCategoryTab(
                      label: 'Solid Colors',
                      category: PresetCategory.solid,
                    ),
                    _buildCategoryTab(
                      label: 'Luxury Metals',
                      category: PresetCategory.luxury,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Presets Grid according to selected category
              _buildPresetsForCategory(),

              const SizedBox(height: 24),

              // Typography Finish Selector (Physical 3D Letterpress vs Foils)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TYPOGRAPHY RELIEF (LETTERPRESS / FOIL)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFinishChip(
                    CardTextFinish.embossed,
                    'Physical 3D Embossed',
                  ),
                  _buildFinishChip(
                    CardTextFinish.silverFoil,
                    'Silver Platinum Foil',
                  ),
                  _buildFinishChip(
                    CardTextFinish.goldFoil,
                    'Hot Gold Foil',
                  ),
                  _buildFinishChip(
                    CardTextFinish.flat,
                    'Flat Modern Ink',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Physical 3D Edge Thickness Selector
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PHYSICAL CARD THICKNESS (ESPESOR 3D)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildThicknessChip(5.0, 'Heavy Metal (5.0 mm)'),
                  _buildThicknessChip(3.5, 'Premium (3.5 mm)'),
                  _buildThicknessChip(2.0, 'Standard (2.0 mm)'),
                  _buildThicknessChip(0.0, 'Flat (0.0 mm)'),
                ],
              ),

              const SizedBox(height: 24),

              // Payment Network Brand Selector
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PAYMENT NETWORK',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  _buildBrandChip(CardBrand.visa, 'Visa'),
                  _buildBrandChip(CardBrand.mastercard, 'Mastercard'),
                  _buildBrandChip(CardBrand.americanExpress, 'Amex'),
                  _buildBrandChip(CardBrand.discover, 'Discover'),
                ],
              ),

              const SizedBox(height: 24),

              // Security Toggles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _isMasked = !_isMasked),
                    icon: Icon(
                      _isMasked ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                    ),
                    label: Text(_isMasked ? 'Reveal Numbers' : 'Mask Numbers'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _isFrozen = !_isFrozen),
                    icon: Icon(
                      _isFrozen ? Icons.ac_unit : Icons.lock_outline,
                      size: 16,
                    ),
                    label: Text(_isFrozen ? 'Unfreeze Card' : 'Freeze Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFrozen
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab({
    required String label,
    required PresetCategory category,
  }) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = category),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetsForCategory() {
    switch (_selectedCategory) {
      case PresetCategory.geometric:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip(
              label: 'Crimson Orbit',
              color: const Color(0xFFE11D48),
              isSelected: _currentTheme == CardPresets.crimsonOrbit,
              onTap: () => _selectPreset(
                CardPresets.crimsonOrbit,
                brand: CardBrand.mastercard,
                number: '5412 7523 9812 4568',
                holder: 'ALEXANDER WRIGHT',
              ),
            ),
            _buildPresetChip(
              label: 'Royal Amethyst',
              color: const Color(0xFF7C3AED),
              isSelected: _currentTheme == CardPresets.royalAmethyst,
              onTap: () => _selectPreset(
                CardPresets.royalAmethyst,
                brand: CardBrand.mastercard,
                number: '5321 8842 1290 7741',
                holder: 'BEATRICE VANCE',
              ),
            ),
            _buildPresetChip(
              label: 'Ocean Azure',
              color: const Color(0xFF0284C7),
              isSelected: _currentTheme == CardPresets.oceanAzure,
              onTap: () => _selectPreset(
                CardPresets.oceanAzure,
                brand: CardBrand.visa,
                number: '4112 3456 7890 1234',
                holder: 'SEBASTIAN COLE',
              ),
            ),
            _buildPresetChip(
              label: 'Midnight Sapphire',
              color: const Color(0xFF0F172A),
              isSelected: _currentTheme == CardPresets.midnightSapphire,
              onTap: () => _selectPreset(
                CardPresets.midnightSapphire,
                brand: CardBrand.visa,
                number: '4890 1245 7768 9901',
                holder: 'VALERIE STERLING',
              ),
            ),
            _buildPresetChip(
              label: 'US Green Card',
              color: const Color(0xFF1E452E),
              isSelected: _currentTheme == HorizontalCardTheme.greenCard,
              onTap: () => _selectPreset(
                HorizontalCardTheme.greenCard,
                brand: CardBrand.americanExpress,
                number: '3759 876543 21001',
                holder: 'C F FROST',
              ),
            ),
            _buildPresetChip(
              label: 'Cyber Mesh',
              color: const Color(0xFF0284C7),
              isSelected: _currentTheme == CardPresets.cyberMesh,
              onTap: () => _selectPreset(
                CardPresets.cyberMesh,
                brand: CardBrand.visa,
                number: '4532 9901 2234 8812',
                holder: 'NEXUS ARCHITECT',
              ),
            ),
          ],
        );

      case PresetCategory.solid:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip(
              label: 'Solid Matte Black',
              color: const Color(0xFF18181B),
              isSelected: _currentTheme == CardPresets.solidMatteBlack,
              onTap: () => _selectPreset(
                CardPresets.solidMatteBlack,
                brand: CardBrand.mastercard,
                number: '5512 8843 1290 7712',
                holder: 'DAMIAN CROSS',
              ),
            ),
            _buildPresetChip(
              label: 'Solid Ceramic White',
              color: const Color(0xFFF8FAFC),
              textColor: const Color(0xFF0F172A),
              isSelected: _currentTheme == CardPresets.solidCeramicWhite,
              onTap: () => _selectPreset(
                CardPresets.solidCeramicWhite,
                brand: CardBrand.visa,
                number: '4000 1234 5678 9010',
                holder: 'VICTORIA BLAKE',
              ),
            ),
            _buildPresetChip(
              label: 'Solid Cobalt Blue',
              color: const Color(0xFF1D4ED8),
              isSelected: _currentTheme == CardPresets.solidCobaltBlue,
              onTap: () => _selectPreset(
                CardPresets.solidCobaltBlue,
                brand: CardBrand.visa,
                number: '4532 8812 9043 7721',
                holder: 'GLOBAL DEBIT',
              ),
            ),
            _buildPresetChip(
              label: 'Solid Hot Coral',
              color: const Color(0xFFFF4D4D),
              isSelected: _currentTheme == CardPresets.solidHotCoral,
              onTap: () => _selectPreset(
                CardPresets.solidHotCoral,
                brand: CardBrand.mastercard,
                number: '5200 4812 3901 6623',
                holder: 'MONZO TRAVELER',
              ),
            ),
            _buildPresetChip(
              label: 'Solid Nubank Purple',
              color: const Color(0xFF820AD1),
              isSelected: _currentTheme == CardPresets.solidNubankPurple,
              onTap: () => _selectPreset(
                CardPresets.solidNubankPurple,
                brand: CardBrand.mastercard,
                number: '5123 9912 3341 0089',
                holder: 'NEOBANK REWARDS',
              ),
            ),
            _buildPresetChip(
              label: 'Solid Swiss Emerald',
              color: const Color(0xFF047857),
              isSelected: _currentTheme == CardPresets.solidEmerald,
              onTap: () => _selectPreset(
                CardPresets.solidEmerald,
                brand: CardBrand.visa,
                number: '4912 7701 4452 9012',
                holder: 'PRIVATE WEALTH',
              ),
            ),
          ],
        );

      case PresetCategory.luxury:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip(
              label: 'Obsidian Black',
              color: const Color(0xFF0F172A),
              isSelected: _currentTheme == HorizontalCardTheme.black,
              onTap: () => _selectPreset(
                HorizontalCardTheme.black,
                brand: CardBrand.visa,
              ),
            ),
            _buildPresetChip(
              label: 'Apple Titanium',
              color: const Color(0xFFCBD5E1),
              textColor: const Color(0xFF0F172A),
              isSelected: _currentTheme == HorizontalCardTheme.titanium,
              onTap: () => _selectPreset(
                HorizontalCardTheme.titanium,
                brand: CardBrand.mastercard,
              ),
            ),
            _buildPresetChip(
              label: 'Electric Purple',
              color: const Color(0xFF6B21A8),
              isSelected: _currentTheme == HorizontalCardTheme.electricPurple,
              onTap: () => _selectPreset(
                HorizontalCardTheme.electricPurple,
                brand: CardBrand.visa,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildPresetChip({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0x33FFFFFF),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54, width: 0.8),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? textColor : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishChip(CardTextFinish finish, String label) {
    final isSelected = _currentFinish == finish;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _currentFinish = finish);
        }
      },
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  Widget _buildThicknessChip(double value, String label) {
    final isSelected = _thickness == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _thickness = value);
        }
      },
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  Widget _buildBrandChip(CardBrand brand, String label) {
    final isSelected = _currentBrand == brand;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _currentBrand = brand);
        }
      },
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
