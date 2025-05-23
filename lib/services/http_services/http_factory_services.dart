import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpFactoryServices {
  //GET API CALL

  static Future<dynamic> getMethod(String url,
      {required Map<String, String> header}) async {
    try {
      debugPrint("get url : $url");
      debugPrint("get header : $header");
      http.Response response = await http.get(Uri.parse(url), headers: header);
      debugPrint("response : ${response.body}",wrapWidth: 2000);
      debugPrint("response statusCode: ${response.statusCode}");
      return response;
    } catch (e) {
      debugPrint("get_method_error : $e");
      return e;
    }
  }

  //POST API CALL
  static Future<dynamic> postMethod(
    String url, {
    dynamic data,
    Map<String, String>? header,
  }) async {
    debugPrint("post url : $url");
    debugPrint("post data : $data");
    debugPrint("post header : $header");
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: header,
        body: data,
      );
      debugPrint("response : ${response.body}");
      debugPrint("response statusCode: ${response.statusCode}");
      return response;
    }
    catch (e) {
      debugPrint("post_method_error : $e");
      return e;
    }
  }

  //DELETE API CALL
  static Future<dynamic> deleteMethod(
    String url, {
    dynamic data,
    Map<String, String>? header,
  }) async {
    debugPrint("delete url : $url");
    debugPrint("delete data : $data");
    debugPrint("delete header : $header");
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: header,
        body: data,
      );
      debugPrint("response : ${response.body}");
      debugPrint("response statusCode: ${response.statusCode}");
      return response;
    } catch (e) {
      debugPrint("delete_method_error ====>>>$e");
      return e;
    }
  }

  //PUT API CALL
  static Future<dynamic> putMethod(
    String url, {
    dynamic data,
    Map<String, String>? header,
  }) async {
    debugPrint("put url : $url");
    debugPrint("put data : $data");
    debugPrint("put header : $header");
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: header,
        body: data,
      );
      debugPrint("response : ${response.body}");
      debugPrint("response statusCode: ${response.statusCode}");
      return response;
    } catch (e) {
      debugPrint("put_method_error : $e");
      return e;
    }
  }

  static Future<dynamic> postMultiPartResponse(
      {required String url,
      Map<String, String>? bodyData,
      // dynamic bodyData,
      List<MultipartFile>? listFile,
      Map<String, String>? header}) async {
    debugPrint("put url : $url");
    debugPrint("put data : $bodyData");
    debugPrint("put MultipartFile : $listFile");
    debugPrint("put header : $header");

    final request = http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.files.addAll(listFile!);
      request.headers.addAll(header!);
      request.fields.addAll(bodyData!);

      var responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      debugPrint("response : ${response.body}");
      debugPrint("response statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      }
      return null;
    } catch (e) {
      debugPrint("multipart_method_error : $e");
      return e;
    }
  }
}
