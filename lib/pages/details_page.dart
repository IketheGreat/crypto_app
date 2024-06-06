import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currrencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: _currrencies.length,
              itemBuilder: (_context, index) {
                String _currency = _currrencies[index].toString().toUpperCase();
                String _exchangeRate = _exchangeRates[index].toString();
                return ListTile(
                  title: Text(
                    _currency,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    _exchangeRate,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              })),
    );
  }
}
