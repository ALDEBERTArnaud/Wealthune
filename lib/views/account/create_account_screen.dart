import 'package:flutter/material.dart';
import 'package:wealthune/models/bank_account.dart';
import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/utils/colors.dart';

class CreateAccountScreen extends StatefulWidget {
  final Function onAccountCreated;

  const CreateAccountScreen({Key? key, required this.onAccountCreated}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final BankAccountService _accountService = BankAccountService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte bancaire'),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du compte'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom de compte';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(labelText: 'Solde initial'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un solde initial';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Créer le compte'),
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      final newAccount = BankAccount(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
      );

      _accountService.saveAccount(newAccount).then((_) {
        widget.onAccountCreated();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du compte: $error')),
        );
      });
    }
  }
}