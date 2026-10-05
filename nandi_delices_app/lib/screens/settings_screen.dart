import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/restaurant_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _whatsappController;
  late TextEditingController _phoneController;
  late TextEditingController _feeController;
  late TextEditingController _addressController;
  late TextEditingController _hoursController;
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    final config = context.read<RestaurantProvider>().config;
    _nameController = TextEditingController(text: config.name);
    _whatsappController = TextEditingController(text: config.whatsappNumber);
    _phoneController = TextEditingController(text: config.phone);
    _feeController = TextEditingController(text: config.deliveryFee.toString());
    _addressController = TextEditingController(text: config.address);
    _hoursController = TextEditingController(text: config.openingHours);
    _isOpen = config.isOpen;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _phoneController.dispose();
    _feeController.dispose();
    _addressController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RestaurantProvider>();
    final fee = double.tryParse(_feeController.text) ?? 2.0;

    final updated = provider.config.copyWith(
      name: _nameController.text.trim(),
      whatsappNumber: _whatsappController.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
      phone: _phoneController.text.trim(),
      deliveryFee: fee,
      address: _addressController.text.trim(),
      openingHours: _hoursController.text.trim(),
      isOpen: _isOpen,
    );

    provider.updateConfig(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Paramètres enregistrés avec succès !"),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text("Configuration Restaurant"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryGreen, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Personnalisez le numéro WhatsApp de destination des commandes sans modifier le code source.",
                        style: TextStyle(fontSize: 12, color: Color(0xFF1B5E20)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Fields Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  children: [
                    // Open / Closed Live Switch
                    Container(
                      decoration: BoxDecoration(
                        color: _isOpen ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isOpen ? const Color(0xFFC8E6C9) : const Color(0xFFFFCDD2),
                        ),
                      ),
                      child: SwitchListTile(
                        value: _isOpen,
                        activeTrackColor: AppTheme.primaryGreen,
                        title: Text(
                          _isOpen ? "Restaurant Ouvert 🟢" : "Restaurant Fermé 🔴",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _isOpen ? const Color(0xFF1B5E20) : AppTheme.warmRed,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          _isOpen ? "Accepte les commandes normalement" : "Affiche la bannière Fermé (closed.webp)",
                          style: const TextStyle(fontSize: 11),
                        ),
                        onChanged: (val) {
                          setState(() => _isOpen = val);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Restaurant Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nom du restaurant",
                        prefixIcon: Icon(Icons.store),
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Champ requis" : null,
                    ),

                    const SizedBox(height: 14),

                    // WhatsApp Number
                    TextFormField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Numéro WhatsApp de réception (Format international sans +)",
                        hintText: "Ex: 33652764960",
                        prefixIcon: Icon(Icons.chat, color: AppTheme.whatsappGreen),
                        helperText: "Exemple: 33652764960 (pour la France), 23051234567 (pour Maurice)",
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Numéro WhatsApp requis";
                        if (v.contains('+') || v.contains(' ')) {
                          return "Entrez les chiffres uniquement sans + ni espaces";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // Phone for calls
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Téléphone d'appel",
                        hintText: "+33 6 52 76 49 60",
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Delivery Fee
                    TextFormField(
                      controller: _feeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Frais de livraison (€)",
                        hintText: "2.00",
                        prefixIcon: Icon(Icons.euro),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Adresse du restaurant",
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Opening Hours
                    TextFormField(
                      controller: _hoursController,
                      decoration: const InputDecoration(
                        labelText: "Horaires d'ouverture",
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveSettings,
                child: const Text("Enregistrer les modifications"),
              ),

              const SizedBox(height: 12),

              // Reset Button
              OutlinedButton(
                onPressed: () {
                  provider.resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Paramètres réinitialisés")),
                  );
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: AppTheme.warmRed,
                  side: const BorderSide(color: AppTheme.warmRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Réinitialiser aux valeurs par défaut"),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
