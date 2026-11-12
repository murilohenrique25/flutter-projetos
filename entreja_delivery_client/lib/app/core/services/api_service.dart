import 'package:delivery_cliente_app/app/core/services/storage_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;

  static const String _baseUrl = 'https://api.deliveryexpress.com';

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptors
    _dio.interceptors.add(dio.LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        final token = Get.find<StorageService>().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  // Auth endpoints
  Future<dio.Response> login(String email, String password) async {
    try {
      return await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio.Response> register(Map<String, dynamic> userData) async {
    try {
      return await _dio.post('/api/auth/register', data: userData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Products endpoints
  Future<dio.Response> getProdutos() async {
    try {
      return await _dio.get('/api/produtos');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio.Response> getProdutosByCategoria(int categoriaId) async {
    try {
      return await _dio.get('/api/produtos/categoria/$categoriaId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio.Response> getCategorias() async {
    try {
      return await _dio.get('/api/categorias');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Orders endpoints
  Future<dio.Response> createPedido(Map<String, dynamic> pedidoData) async {
    try {
      return await _dio.post('/api/pedidos', data: pedidoData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio.Response> getPedidosUsuario(int usuarioId) async {
    try {
      return await _dio.get('/api/pedidos/usuario/$usuarioId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio.Response> getPedidoStatus(int pedidoId) async {
    try {
      return await _dio.get('/api/pedidos/$pedidoId/status');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Coupons endpoints
  Future<dio.Response> validarCupom(String codigo) async {
    try {
      return await _dio.post('/api/cupons/validar', data: {'codigo': codigo});
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Configuration endpoints
  Future<dio.Response> getConfiguracoes() async {
    try {
      return await _dio.get('/api/config/funcionamento');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is dio.DioException) {
      switch (error.type) {
        case dio.DioExceptionType.connectionTimeout:
        case dio.DioExceptionType.sendTimeout:
        case dio.DioExceptionType.receiveTimeout:
          return Exception('Tempo limite excedido. Verifique sua conexão.');
        case dio.DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 'Erro no servidor';
          return Exception('Erro $statusCode: $message');
        default:
          return Exception('Erro de conexão. Verifique sua internet.');
      }
    }
    return Exception('Erro inesperado: ${error.toString()}');
  }
}
