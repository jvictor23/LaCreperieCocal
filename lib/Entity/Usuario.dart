class Usuario{
  String _id;
  String _nome;
  String _endereco;
  String _telefone;
  String _email;
  String _senha;

  Usuario();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map ={
      "id" : this.id,
      "nome" : this.nome,
      "endereco" : this.endereco,
      "telefone" : this.telefone,
      "email" : this.email,
      "senha" : this.senha
    };
    return map;

  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


}