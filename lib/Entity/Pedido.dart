import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lacreperie_cocal/Entity/ItemPedido.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';

class Pedido{
  String _idPedido;
  String _idUsuario;
  String _endereco;
  List<Map<String,dynamic>> _mapItemPedido;
  String _meioPagamento;
  String _nomeUsuario;
  String _telefone;
  String _observacao;
  double _total;


  Pedido();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "endereco": this._endereco,
      "meioPagamento" : this._meioPagamento,
      "nomeUsuario" : this._nomeUsuario,
      "telefone" : this._telefone,
      "observacao" : this._observacao,
      "total" :this._total,
      "listaPedidos" : this._mapItemPedido,
      "idPedido" : this.idPedido,
      "idUsuario" : this.idUsuario
    };
    return map;
  }


  String get observacao => _observacao;

  set observacao(String value) {
    _observacao = value;
  }

  double get total => _total;

  set total(double value) {
    _total = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get nomeUsuario => _nomeUsuario;

  set nomeUsuario(String value) {
    _nomeUsuario = value;
  }

  String get meioPagamento => _meioPagamento;

  set meioPagamento(String value) {
    _meioPagamento = value;
  }


  List<Map<String, dynamic>> get mapItemPedido => _mapItemPedido;

  set mapItemPedido(List<Map<String, dynamic>> value) {
    _mapItemPedido = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get idPedido => _idPedido;

  set idPedido(String value) {
    _idPedido = value;
  }


}