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

class HorizontalCardDemoScreen extends StatefulWidget {
  const HorizontalCardDemoScreen({super.key});

  @override
  State<HorizontalCardDemoScreen> createState() =>
      _HorizontalCardDemoScreenState();
}

class _HorizontalCardDemoScreenState extends State<HorizontalCardDemoScreen> {
  HorizontalCardTheme _currentTheme = HorizontalCardTheme.greenCard;
  CardBrand _currentBrand = CardBrand.americanExpress;
  CardTextFinish _currentFinish = CardTextFinish.embossed;
  String _cardNumber = '3759 876543 21001';
  String _cardHolder = 'C F FROST';
  String _expiryDate = '09/28';
  String _cvv = '1001';
  double _thickness = 4.0;
  bool _isMasked = false;
  bool _isFrozen = false;

  void _selectTheme(HorizontalCardTheme theme) {
    setState(() {
      _currentTheme = theme;
      _currentFinish = theme.textFinish;

      if (theme == HorizontalCardTheme.greenCard) {
        _currentBrand = CardBrand.americanExpress;
        _cardNumber = '3759 876543 21001';
        _cardHolder = 'C F FROST';
        _expiryDate = '09/28';
        _cvv = '1001';
      } else if (_currentBrand == CardBrand.americanExpress) {
        _currentBrand = CardBrand.visa;
        _cardNumber = '4532 8812 9043 7721';
        _cardHolder = 'Alexander Wright';
        _expiryDate = '09/29';
        _cvv = '842';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Horizontal Card 3D',
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

              // The 3D Horizontal Card with Physical Thickness and Embossed Letterpress
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

              const SizedBox(height: 20),
              const Text(
                'Tap card to flip • Drag to inspect 3D letterpress light reflection',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 28),

              // Theme Selector
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CARD FINISH & PRESETS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildThemeChip(
                    label: 'US Green Card',
                    isSelected: _currentTheme == HorizontalCardTheme.greenCard,
                    onTap: () => _selectTheme(HorizontalCardTheme.greenCard),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    label: 'Obsidian Black',
                    isSelected: _currentTheme == HorizontalCardTheme.black,
                    onTap: () => _selectTheme(HorizontalCardTheme.black),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    label: 'Electric Purple',
                    isSelected:
                        _currentTheme == HorizontalCardTheme.electricPurple,
                    onTap: () =>
                        _selectTheme(HorizontalCardTheme.electricPurple),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    label: 'Titanium',
                    isSelected: _currentTheme == HorizontalCardTheme.titanium,
                    onTap: () => _selectTheme(HorizontalCardTheme.titanium),
                  ),
                ],
              ),

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
                  _buildBrandChip(CardBrand.americanExpress, 'Amex'),
                  _buildBrandChip(CardBrand.visa, 'Visa'),
                  _buildBrandChip(CardBrand.mastercard, 'Mastercard'),
                  _buildBrandChip(CardBrand.discover, 'Discover'),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF16A34A) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4ADE80)
                  : const Color(0x33FFFFFF),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
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
      selectedColor: const Color(0xFF16A34A),
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
          setState(() {
            _currentBrand = brand;
            if (brand == CardBrand.americanExpress &&
                _cardNumber.startsWith('4532')) {
              _cardNumber = '3759 876543 21001';
              _cardHolder = 'C F FROST';
              _cvv = '1001';
            } else if (brand != CardBrand.americanExpress &&
                _cardNumber.startsWith('3759')) {
              _cardNumber = '4532 8812 9043 7721';
              _cardHolder = 'Alexander Wright';
              _cvv = '842';
            }
          });
        }
      },
      selectedColor: const Color(0xFF16A34A),
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
      selectedColor: const Color(0xFF16A34A),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
