import 'dart:async';

import 'package:dio/dio.dart';

class SearchCepBloc {
  //broadcast -> Para ser escutado por mais de um arquivo (sempre use)
  final _streamController = StreamController<String>.broadcast();

  //*Entrada
  Sink<String> get searchCep => _streamController.sink;

  //*Saida
  //! Obs: a entrada é String porém auqi vamos fazer uma mutação para que a saida seja um Map
  //! Essa é a vantagem do Bloc conseguir ter um tipo de entrada e um tipo de saida
  //! no asyncMap posso passar uma função que tenha o tipo de entrada como parametro (que seja future)
  Stream<Map> get cepResult => _streamController.stream.asyncMap(_searchCep);

  Future<Map> _searchCep(String cep) async {
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');

      return response.data;
    } catch (e) {
      //*A stream ja tem um fluxo próprio para Exception(ela ja seguimenta o dado ao erro)
      throw Exception('Cep inválido');
    }
  }

  void dispose() {
    _streamController.close();
  }
}
