import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'response.dart';

class RestApiClient {
  late String baseRoute;
  static const int TIMEOUT_SECONDS = 120;
  final String baseApiEndPoint = BASE_ROUTE;

  RestApiClient();

  Future<http.Response> getData<T>(String endpoint) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'Bearer $accessToken';}
    else if (authToken != null) {authorization = 'Bearer $authToken';}

    final response = await http.get(
      Uri.http(baseApiEndPoint, endpoint),
      headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.cacheControlHeader: "max-age=3600, must-revalidate"
      },
    ).timeout(const Duration(seconds: TIMEOUT_SECONDS), onTimeout: _onTimeout);

    return response;
  }

  Future<http.Response> getExternal(String endpoint) async {
    Uri uri = Uri.http('', endpoint);
    final response = await http.get(uri).timeout(
        const Duration(seconds: TIMEOUT_SECONDS),
        onTimeout: _onTimeout);
    return response;
  }

  Future<http.Response> deleteData(String endpoint) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'bearer $accessToken';}
    else if (authToken != null) {authorization = 'bearer $authToken';}

    final response = await http.delete(
      Uri.http(baseApiEndPoint, endpoint),
      headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.cacheControlHeader: "max-age=3600, must-revalidate"
      },
    ).timeout(const Duration(seconds: TIMEOUT_SECONDS), onTimeout: _onTimeout);

    return response;
  }

  Future<http.Response?> postData(String endpoint, Map<String, dynamic> data,
      [String? contentType]) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');
    String authorization = '';
    if (accessToken != null) {authorization = 'Bearer $accessToken';}
    else if (authToken != null) {authorization = 'Bearer $authToken';}
    try{
      final response = await http.post(
        Uri.parse("$baseApiEndPoint$endpoint"),
        headers: {
          HttpHeaders.authorizationHeader: authorization,
          HttpHeaders.contentTypeHeader: (contentType ?? "application/json; charset=UTF-8"),
          HttpHeaders.acceptHeader: "application/json"
        },
          // ignore: unnecessary_null_comparison
          body: data != null ? (contentType == null ? json.encode(data) : data) : null
        )
        .timeout(const Duration(seconds: TIMEOUT_SECONDS), onTimeout: _onTimeout);
      return response;
    }
    catch(exception){
      return null;
    }

  }

  Future<http.StreamedResponse> postFormData(
      String endpoint, Map<String, dynamic> data) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'bearer $accessToken';}
    else if (authToken != null) {authorization = 'bearer $authToken';}

    var formData = urlEncodeMap(data);
    var uri = Uri.parse('$baseApiEndPoint$endpoint');
    var request = http.Request("POST", uri);
    request.headers.addAll({
      HttpHeaders.authorizationHeader: authorization,
      HttpHeaders.contentTypeHeader:
      ("application/x-www-form-urlencoded; charset=UTF-8")
    });
    request.body = formData;
    var response = await request.send();

    return response;
  }

  Future<MappedNetworkServiceResponse<T>> postDataAsync<T>(
      String endpoint, Map<String, dynamic> data,
      [String? contentType]) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'bearer $accessToken';}
    else if (authToken != null) {authorization = 'bearer $authToken';}

    final response = await http
        .post(Uri.http(baseApiEndPoint, endpoint),
        headers: {
          HttpHeaders.authorizationHeader: authorization,
          HttpHeaders.contentTypeHeader: (contentType ?? "application/json; charset=UTF-8")
        },
        body: data != null ? (contentType == null ? json.encode(data) : data) : null)
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
        onTimeout: _onTimeout);

    return processResponse<T>(response);
  }

  Future<http.StreamedResponse> uploadData(String endpoint, File file) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'Bearer $accessToken';}
    else if (authToken != null) {authorization = 'Bearer $authToken';}

    // var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    var uri = Uri.parse("$baseApiEndPoint$endpoint");
    final request = http.MultipartRequest("POST", uri);
    request.files.add(
        http.MultipartFile('file', stream, length, filename: basename(file.path)));
    request.headers.addAll({HttpHeaders.authorizationHeader: authorization});
    int byteCount = 0;

    Stream<List<int>> stream2 = stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;
          sink.add(data);
        },
        handleError: (error, stack, sink) {},
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    var response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> uploadDataWithId(String endpoint, File file, int id) async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    var authToken = prefs.getString('AuthorizationToken');

    late String authorization;

    if (accessToken != null) {authorization = 'Bearer $accessToken';}
    else if (authToken != null) {authorization = 'Bearer $authToken';}

    // var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    var uri = Uri.parse("$baseApiEndPoint$endpoint");
    final request = http.MultipartRequest("POST", uri);
    request.files.add(
        http.MultipartFile('file', stream, length, filename: basename(file.path)));
    request.fields['id'] = id.toString();
    request.headers.addAll({HttpHeaders.authorizationHeader: authorization});
    int byteCount = 0;

    Stream<List<int>> stream2 = stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;
          // print(byteCount);
          sink.add(data);
        },
        handleError: (error, stack, sink) {},
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    var response = await request.send();

    return response;
  }

  Future<http.Response> _onTimeout() {
    throw const SocketException("Timeout during request");
  }

  MappedNetworkServiceResponse<T> processResponse<T>(http.Response response) {
    if (!((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.body == null))) {
      var jsonResult = response.body;
      dynamic resultClass = jsonDecode(jsonResult);

      return MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: NetworkServiceResponse<T>(success: true));
    } else {
      var errorResponse = response.body;
      return MappedNetworkServiceResponse<T>(
          networkServiceResponse: NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
    }
  }

  /// Deep encode the [Map<String, dynamic>] to percent-encoding.
  /// It is mostly used with  the "application/x-www-form-urlencoded" content-type.
  static String urlEncodeMap(Map data) {
    StringBuffer urlData = StringBuffer("");
    bool first = true;
    void urlEncode(dynamic sub, String path) {
      if (sub is List) {
        for (int i = 0; i < sub.length; i++) {
          urlEncode(sub[i],
              "$path%5B${(sub[i] is Map || sub[i] is List) ? i : ''}%5D");
        }
      } else if (sub is Map) {
        sub.forEach((k, v) {
          if (path == "") {
            urlEncode(v, Uri.encodeQueryComponent(k));
          } else {
            urlEncode(v, "$path%5B${Uri.encodeQueryComponent(k)}%5D");
          }
        });
      } else {
        if (!first) {
          urlData.write("&");
        }
        first = false;
        if (sub == null) {
          // `null` value handling logic is consistent with `Uri`
          urlData.write(path);
        } else {
          urlData.write("$path=${Uri.encodeQueryComponent(sub.toString())}");
        }
      }
    }

    urlEncode(data, "");
    return urlData.toString();
  }

  String getQueryString(Map data,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';

    data.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }
      if (value != null) {
        if (value is String || value is int || value is double) {
          query +=
          '$prefix${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}';
        } else if (value is List || value is Map) {
          if (value is List) value = value.asMap();
          value.forEach((k, v) {
            var subQuery = getQueryString({k: v},
                prefix: '$prefix$key', inRecursion: true);
            query += subQuery;
          });
        }
      }
    });

    return query;
  }
}
