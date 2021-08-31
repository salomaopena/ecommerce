//@dart=2.9
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const token = '6ee91c6b3cc2f926223ceb5d4ae75e08';

class CEPAbertoService {

  Future<void> getAddressFromCep(String zipCode) async {
    final cleanCep = zipCode.replaceAll('.', '').replaceAll('-', '');
    final endPoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map>(endPoint);

      if(response.data.isEmpty){
        return Future.error('CEP Invalido');
      }

      print(response.data);

    } on DioError catch (error) {
      debugPrint(error.toString());
      return Future.error('Erro ao buscar CEP $error');
    }
  }
}
