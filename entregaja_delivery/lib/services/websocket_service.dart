import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  final RxBool isConnected = false.obs;
  int? _idEntrega;

  void connect(String token, int idEntrega) {
    _idEntrega = idEntrega;

    try {
      /*final uri = Uri.parse(
        'wss://tomcat.vps6912.panel.icontainer.net:8443/control-api/ws/entregas?token=$token',
      );*/

      final uri = Uri.parse(
        'http://localhost:8080/control-api/ws/entregas?token=$token',
      );

      debugPrint('🔌 Conectando ao WebSocket...');

      _channel = WebSocketChannel.connect(uri);
      isConnected.value = true;

      debugPrint('✅ WebSocket conectado');

      _channel!.stream.listen(
        (message) {
          debugPrint('📨 Mensagem recebida: $message');
        },
        onError: (error) {
          debugPrint('❌ Erro no WebSocket: $error');
          isConnected.value = false;
        },
        onDone: () {
          debugPrint('🔌 WebSocket desconectado');
          isConnected.value = false;
        },
      );
    } catch (e) {
      debugPrint('❌ Erro ao conectar WebSocket: $e');
      isConnected.value = false;
    }
  }

  void sendLocation(double lat, double lng) {
    if (_channel == null || !isConnected.value) {
      debugPrint('⚠️ WebSocket não conectado');
      return;
    }

    final data = jsonEncode({
      'idEntrega': _idEntrega,
      'latitude': lat,
      'longitude': lng,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      _channel!.sink.add(data);
      debugPrint('📤 Localização enviada');
    } catch (e) {
      debugPrint('❌ Erro ao enviar: $e');
    }
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
      isConnected.value = false;
      debugPrint('🔌 WebSocket desconectado');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
