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
  HorizontalCardTheme _currentTheme = HorizontalCardTheme.black;
  CardBrand _currentBrand = CardBrand.visa;
  bool _isMasked = false;
  bool _isFrozen = false;

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
              const SizedBox(height: 16),

              // The 3D Horizontal Card
              Center(
                child: HorizontalCard(
                  cardNumber: '4532 8812 9043 7721',
                  cardHolder: 'Alexander Wright',
                  expiryDate: '09/29',
                  cvv: '842',
                  brand: _currentBrand,
                  cardTheme: _currentTheme,
                  isMasked: _isMasked,
                  isFrozen: _isFrozen,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Tap card to flip • Drag to inspect 3D reflection',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              // Theme Selector
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'FINISH / THEME',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildThemeChip(
                    label: 'Obsidian Black',
                    isSelected: _currentTheme == HorizontalCardTheme.black,
                    onTap: () => setState(
                        () => _currentTheme = HorizontalCardTheme.black),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    label: 'Electric Purple',
                    isSelected:
                        _currentTheme == HorizontalCardTheme.electricPurple,
                    onTap: () => setState(() =>
                        _currentTheme = HorizontalCardTheme.electricPurple),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    label: 'Titanium',
                    isSelected: _currentTheme == HorizontalCardTheme.titanium,
                    onTap: () => setState(
                        () => _currentTheme = HorizontalCardTheme.titanium),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Brand Selector
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
              const SizedBox(height: 12),
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
                    label: Text(_isMasked ? 'Reveal' : 'Mask'),
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
                    label: Text(_isFrozen ? 'Unfreeze' : 'Freeze'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFrozen
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
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
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF60A5FA)
                  : const Color(0x33FFFFFF),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
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
      selectedColor: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
