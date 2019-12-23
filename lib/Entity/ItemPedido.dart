class ItemPedido{

  String _nomeProduto;
  String _ingredientes;
  double _preco;
  String _imagem;
  int _quantidade;

  ItemPedido();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nomeProduto": this.nomeProduto,
      "ingredientes" : this.ingredientes,
      "preco" : this.preco,
      "imagem" : this.imagem,
    };
    return map;
  }

  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }

  String get ingredientes => _ingredientes;

  set ingredientes(String value) {
    _ingredientes = value;
  }

  String get nomeProduto => _nomeProduto;

  set nomeProduto(String value) {
    _nomeProduto = value;
  }


}