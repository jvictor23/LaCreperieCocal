import 'package:cloud_firestore/cloud_firestore.dart';

class Produto{
  String _imagem;
  String _nomeProduto;
  String _ingredientes;
  String _tipo;
  String _id;
  int _qtd;
  double _preco;


  Produto();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nomeProduto": this.nomeProduto,
      "ingredientes" : this.ingredientes,
      "tipo" : this.tipo,
      "preco" : this.preco,
      "imagem" : this.imagem,
      "id" :this.id,
      "quantidade" : this.qtd
    };
    return map;
  }


  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get ingredientes => _ingredientes;

  set ingredientes(String value) {
    _ingredientes = value;
  }

  String get nomeProduto => _nomeProduto;

  set nomeProduto(String value) {
    _nomeProduto = value;
  }

  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}