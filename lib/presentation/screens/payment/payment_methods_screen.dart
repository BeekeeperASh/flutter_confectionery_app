import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Способы оплаты'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.blue),
            title: const Text('Банковская карта'),
            subtitle: const Text('Visa, Mastercard, Mir'),
            trailing: const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: Colors.orange),
            title: const Text('Электронные кошельки'),
            subtitle: const Text('ЮMoney, Qiwi'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.money, color: Colors.green),
            title: const Text('Наличные'),
            subtitle: const Text('Оплата при получении'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}