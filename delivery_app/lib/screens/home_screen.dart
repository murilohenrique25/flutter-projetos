import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/delivery_provider.dart';
import '../models/delivery_model.dart';
import 'delivery_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Entregas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, child) {
          if (provider.currentDelivery != null) {
            return DeliveryScreen(delivery: provider.currentDelivery!);
          }

          return const WaitingScreen();
        },
      ),
    );
  }
}

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _initializeDeliveryListener();
  }

  /// Inicializa o listener de entregas do provider
  void _initializeDeliveryListener() {
    final provider = context.read<DeliveryProvider>();

    // Escuta novas entregas vindo da API
    provider.startListeningForDeliveries((delivery) {
      if (mounted && !_hasShownDialog) {
        _showDeliveryDialog(delivery);
      }
    });
  }

  void _showDeliveryDialog(Delivery delivery) {
    _hasShownDialog = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delivery_dining,
                    color: Colors.green.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Nova Entrega!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  Icons.store,
                  'Estabelecimento',
                  delivery.establishmentName,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.location_on,
                  'Endereço de entrega',
                  delivery.customerAddress,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.attach_money,
                  'Valor da entrega',
                  NumberFormat.currency(
                    locale: 'pt_BR',
                    symbol: 'R\$',
                  ).format(delivery.value),
                  isHighlight: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _hasShownDialog = false;
                  });
                  // Continua aguardando próximas entregas
                },
                child: const Text('Recusar'),
              ),
              ElevatedButton(
                onPressed: () => _acceptDelivery(delivery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Aceitar'),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlight ? Colors.green : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                  color: isHighlight ? Colors.green : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _acceptDelivery(Delivery delivery) async {
    final provider = context.read<DeliveryProvider>();
    Navigator.of(context).pop();

    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final accepted = await provider.acceptDelivery(delivery);

    if (!mounted) return;

    // Fecha loading
    Navigator.of(context).pop();

    if (accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrega aceita com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Entrega foi aceita por outro entregador
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta entrega já foi aceita por outro entregador.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _hasShownDialog = false;
      });
      // Continua aguardando próximas entregas
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.delivery_dining,
                size: 80,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Aguardando novas entregas...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.blue.shade700),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Você será notificado assim que uma nova entrega estiver disponível',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
