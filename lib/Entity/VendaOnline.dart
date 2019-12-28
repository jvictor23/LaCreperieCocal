import 'package:date_format/date_format.dart';

class VendaOnline{
  String _dataVenda;
  String _horaVenda;
  double _total;
  List<dynamic> _listaVenda;
  String _tipo;
  String _idVenda;
  String _metodoPagamento;
  String _nomeCliente;
  String _idCliente;

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      "dataVenda" : this.dataVenda,
      "horaVenda" : this.horaVenda,
      "total" : this.total,
      "listaVenda" : this.listaVenda,
      "tipo" : this.tipo,
      "idVenda" : this.idVenda,
      "metodoPagamento" : this.metodoPagamento,
      "nomeCliente" : this.nomeCliente,
      "idCliente" : this.idCliente
    };
    return map;
  }


  String get idCliente => _idCliente;

  set idCliente(String value) {
    _idCliente = value;
  }

  String get dataVenda => _dataVenda;

  set dataVenda(String value) {
    _dataVenda = value;
  }

  String get horaVenda => _horaVenda;

  String get nomeCliente => _nomeCliente;

  set nomeCliente(String value) {
    _nomeCliente = value;
  }

  String get metodoPagamento => _metodoPagamento;

  set metodoPagamento(String value) {
    _metodoPagamento = value;
  }

  String get idVenda => _idVenda;

  set idVenda(String value) {
    _idVenda = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  List<dynamic> get listaVenda => _listaVenda;

  set listaVenda(List<dynamic> value) {
    _listaVenda = value;
  }

  double get total => _total;

  set total(double value) {
    _total = value;
  }

  set horaVenda(String value) {
    _horaVenda = value;
  }


}