import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper{
  static Dio? dio;
  static init(){
    dio = Dio(BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com/",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    dio?.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      compact: true,
    ));
  }

  static getFromApi({
    required String? url,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await dio!.get(
      url!,
      queryParameters: query,
      cancelToken: cancelToken,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
  }

  static postToApi({
    required String? url,
    required dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken
  }) async {
    return await dio!.post(
      url!,
      queryParameters: query,
      cancelToken: cancelToken,
      data: data,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
      }),
    );
  }
}