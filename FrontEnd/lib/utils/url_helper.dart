// FrontEnd/lib/utils/url_helper.dart

class UrlHelper {
  static const String _baseUrl = 'http://localhost:8080';

  static String normalizeImageUrl(String? url) {
    if (url == null) return '';
    if (url.startsWith('http')) return url;
    // Đảm bảo không thêm /api vào trước
    return _baseUrl + url;
  }
} 