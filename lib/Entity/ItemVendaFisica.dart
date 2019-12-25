import 'package:lacreperie_cocal/Entity/Pedido.dart';

class ItemVendaFisica{
  String _nomeProduto;
  double _preco;
  int _qtd;


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nomeProduto":this.nomeProduto,
      "preco":this.preco,
      "quantidade":this.qtd,
    };
    return map;
  }

  String get nomeProduto => _nomeProduto;

  set nomeProduto(String value) {
    _nomeProduto = value;
  }

  double get preco => _preco;

  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  set preco(double value) {
    _preco = value;
  }


}