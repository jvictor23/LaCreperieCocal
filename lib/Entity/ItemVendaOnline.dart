class ItemVendaOnline{
  String _nomeCliente;
  String _endereco;
  String _telefone;
  String _obs;
  String _metodoPagamento;
  double _total;

  String get nomeCliente => _nomeCliente;

  set nomeCliente(String value) {
    _nomeCliente = value;
  }

  String get endereco => _endereco;

  double get total => _total;

  set total(double value) {
    _total = value;
  }

  String get metodoPagamento => _metodoPagamento;

  set metodoPagamento(String value) {
    _metodoPagamento = value;
  }

  String get obs => _obs;

  set obs(String value) {
    _obs = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  set endereco(String value) {
    _endereco = value;
  }


}