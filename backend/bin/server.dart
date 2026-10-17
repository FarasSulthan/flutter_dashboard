import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Read-only mock API backed by the bundled dummy JSON file.
///
/// This is intentionally simple: every response is derived directly from
/// `backend/data/dashboard.seed.json`; no database or runtime data file is
/// created and no request can alter the dummy data.
Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final dataPath = Platform.environment['DATA_FILE'] ?? 'backend/data/dashboard.seed.json';
  final repository = DummyJsonRepository(File(dataPath));
  await repository.open();

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  stdout.writeln('Farasha dummy API listening at http://localhost:$port');
  stdout.writeln('Dummy JSON: ${repository.dataFile.path}');

  await for (final request in server) {
    unawaited(_handle(request, repository));
  }
}

Future<void> _handle(HttpRequest request, DummyJsonRepository repository) async {
  try {
    _setCorsHeaders(request.response);
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    if (request.method != 'GET') {
      throw const ApiException(HttpStatus.methodNotAllowed, 'Dummy API hanya mendukung request GET.');
    }

    final path = request.uri.path;
    final segments = request.uri.pathSegments;

    if (path == '/health') {
      return await _sendJson(request.response, HttpStatus.ok, {
        'data': {'status': 'ok', 'mode': 'dummy-json'},
      });
    }
    if (path == '/api/dashboard') {
      return await _sendJson(request.response, HttpStatus.ok, {'data': repository.dashboard()});
    }
    if (path == '/api/reports') {
      return await _sendJson(request.response, HttpStatus.ok, {
        'data': repository.report(request.uri.queryParameters['period']),
      });
    }
    if (path == '/api/settings') {
      return await _sendJson(request.response, HttpStatus.ok, {'data': repository.settings()});
    }

    if ((segments.length == 2 || segments.length == 3) && segments.first == 'api') {
      final collection = segments[1];
      final id = segments.length == 3 ? segments[2] : null;
      if (!const {'products', 'customers', 'orders'}.contains(collection)) {
        throw const ApiException(HttpStatus.notFound, 'Endpoint tidak ditemukan.');
      }
      if (id == null) {
        return await _sendCollection(
          request.response,
          repository.list(collection, request.uri.queryParameters),
        );
      }
      final item = repository.find(collection, id);
      if (item == null) {
        throw const ApiException(HttpStatus.notFound, 'Data tidak ditemukan.');
      }
      return await _sendJson(request.response, HttpStatus.ok, {'data': item});
    }

    throw const ApiException(HttpStatus.notFound, 'Endpoint tidak ditemukan.');
  } on ApiException catch (error) {
    await _sendJson(request.response, error.statusCode, {
      'error': {'message': error.message},
    });
  } on FormatException catch (_) {
    await _sendJson(request.response, HttpStatus.internalServerError, {
      'error': {'message': 'Format dummy JSON tidak valid.'},
    });
  } catch (_) {
    await _sendJson(request.response, HttpStatus.internalServerError, {
      'error': {'message': 'Dummy API tidak dapat memuat data.'},
    });
  }
}

Future<void> _sendCollection(HttpResponse response, List<Map<String, dynamic>> items) {
  return _sendJson(response, HttpStatus.ok, {
    'data': items,
    'meta': {'count': items.length},
  });
}

Future<void> _sendJson(HttpResponse response, int statusCode, Object body) async {
  response
    ..statusCode = statusCode
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body));
  await response.close();
}

void _setCorsHeaders(HttpResponse response) {
  response.headers
    ..set('Access-Control-Allow-Origin', '*')
    ..set('Access-Control-Allow-Methods', 'GET, OPTIONS')
    ..set('Access-Control-Allow-Headers', 'Content-Type');
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;
}

class DummyJsonRepository {
  DummyJsonRepository(this.dataFile);

  final File dataFile;
  late Map<String, dynamic> _data;

  Future<void> open() async {
    if (!await dataFile.exists()) {
      throw FileSystemException('Dummy JSON tidak ditemukan.', dataFile.path);
    }
    _data = _asMap(jsonDecode(await dataFile.readAsString()));
  }

  Map<String, dynamic> dashboard() => _copy(_asMap(_data['dashboard']));

  Map<String, dynamic> settings() => _copy(_asMap(_data['settings']));

  Map<String, dynamic> report(String? period) {
    final reports = _asMap(_data['reports']);
    if (period == null || period.isEmpty) return _copy(reports);

    final result = reports[period];
    if (result is! Map) {
      throw const ApiException(HttpStatus.notFound, 'Periode laporan tidak ditemukan.');
    }
    return _copy(_asMap(result));
  }

  List<Map<String, dynamic>> list(String collection, Map<String, String> query) {
    final search = (query['search'] ?? '').trim().toLowerCase();

    return _collection(collection).where((item) {
      final searchable = switch (collection) {
        'products' => '${item['id']} ${item['name']}',
        'customers' => '${item['name']} ${item['email']} ${item['phone']}',
        'orders' => '${item['id']} ${item['customerName']}',
        _ => '',
      };
      final matchesSearch = search.isEmpty || searchable.toLowerCase().contains(search);
      final matchesFilter = switch (collection) {
        'products' =>
          (query['category'] == null || item['category'] == query['category']) &&
              (query['status'] == null || item['status'] == query['status']),
        'customers' => query['tier'] == null || item['tier'] == query['tier'],
        'orders' => query['status'] == null || item['status'] == query['status'],
        _ => false,
      };
      return matchesSearch && matchesFilter;
    }).map(_copy).toList();
  }

  Map<String, dynamic>? find(String collection, String id) {
    for (final item in _collection(collection)) {
      if (item['id'] == id) return _copy(item);
    }
    return null;
  }

  List<Map<String, dynamic>> _collection(String name) {
    final value = _data[name];
    if (value is! List) throw const FormatException('Koleksi dummy tidak valid.');
    return value.map(_asMap).toList();
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) throw const FormatException('JSON object tidak valid.');
  return Map<String, dynamic>.from(value);
}

Map<String, dynamic> _copy(Map<String, dynamic> value) {
  return _asMap(jsonDecode(jsonEncode(value)));
}
