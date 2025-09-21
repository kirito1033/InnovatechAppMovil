class BaseUrlService {
  // Definimos el base URL como constante
  static const String baseUrl = "https://edb2ec0feaea.ngrok-free.app/api_v1";

  // Método para acceder al valor (opcional, ya que es estático)
  static String getBaseUrl() {
    return baseUrl;
  }
}