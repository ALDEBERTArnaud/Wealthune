import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/crypto/crypto_details_screen.dart';
import 'package:wealthune/views/crypto/create_crypto_screen.dart';
import '../models/cryptocurrency.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_card.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final CryptoService _cryptoService = CryptoService();
  late Future<List<Cryptocurrency>> _cryptosFuture;

  @override
  void initState() {
    super.initState();
    _cryptosFuture = _cryptoService.getCryptocurrencies(); // Initialisation de la liste de crypto-monnaies
  }

  void _navigateAndCreateCrypto(BuildContext context) async {
    // Naviguer vers CreateCryptoScreen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCryptoScreen()),
    );
    // Recharger les crypto-monnaies après la création
    setState(() {
      _cryptosFuture = _cryptoService.getCryptocurrencies();
    });
  }

  void _navigateToCryptoDetails(Cryptocurrency crypto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CryptoDetailsScreen(cryptocurrency: crypto, onCryptoUpdated: () {
          // Rafraîchir la liste des crypto-monnaies
          setState(() {
            _cryptosFuture = _cryptoService.getCryptocurrencies();
          });
        },
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_wealthune.png', height: 50,),
        title: const Text('Cryptomonnaies', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.primaryColor,
            onPressed: () => _navigateAndCreateCrypto(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Cryptocurrency>>(
        future: _cryptosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Afficher une icône de chargement en cas d'attente
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}')); // Afficher un message d'erreur en cas d'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune crypto-monnaie trouvée.")); // Afficher un message si aucune crypto-monnaie n'est trouvée
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final crypto = snapshot.data![index];
                return CryptoCard(
                  crypto: crypto,
                  onTap: () => _navigateToCryptoDetails(crypto),
                );
              },
            );
          }
        },
      ),
    );
  }
}
