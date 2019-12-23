
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';


class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  UsuarioController _usuarioController = new UsuarioController();

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _verificaCampos() {
    String nome = _controllerNome.text;
    String endereco = _controllerEndereco.text;
    String telefone = _controllerTelefone.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (endereco.isNotEmpty) {
        if (telefone.isNotEmpty) {
          if (email.isNotEmpty) {
            if (senha.isNotEmpty && senha.length > 6) {

              Usuario usuario = Usuario();
              usuario.nome = nome;
              usuario.endereco = endereco;
              usuario.telefone = telefone;
              usuario.email = email;
              usuario.senha = senha;

              if(_usuarioController.cadastrarUsuario(usuario) != null){
                  setState(() {
                    _mensagemErro = "Cadastro realizado com sucesso!, volte a tela anterior e faça o login";
                    _controllerNome.clear();
                    _controllerEndereco.clear();
                    _controllerTelefone.clear();
                    _controllerEmail.clear();
                    _controllerSenha.clear();
                  });
              }else{
                setState(() {
                  _mensagemErro = "Erro ao cadastrar usuario, verifique seus dados ou a conexão com a internet e tente novamente!";
                });
              }




            } else {
              setState(() {
                _mensagemErro = "O campo senha não pode ficar vazio e deve conter mais de 6 caracteres";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "O campo email não pode ficar vazio";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "O campo telefone não pode ficar vazio";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "O campo endereço não pode ficar vazio";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "O campo nome não pode ficar vazio";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro"),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(Cores().backgroundTelas),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: TextField(
                      controller: _controllerNome,
                      style: TextStyle(color: Color(Cores().corTexto)),
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(Cores().corBotoes),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(Cores().corTexto),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: "Nome",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: TextField(
                      controller: _controllerEndereco,
                      style: TextStyle(color: Color(Cores().corTexto)),
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(Cores().corBotoes),
                        prefixIcon: Icon(
                          Icons.home,
                          color: Color(Cores().corTexto),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: "Endereço",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: TextField(
                      controller: _controllerTelefone,
                      style: TextStyle(color: Color(Cores().corTexto)),
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(Cores().corBotoes),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: Color(Cores().corTexto),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: "Telefone",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: TextField(
                      controller: _controllerEmail,
                      style: TextStyle(color: Color(Cores().corTexto)),
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(Cores().corBotoes),
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Color(Cores().corTexto),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _controllerSenha,
                      style: TextStyle(color: Color(Cores().corTexto)),
                      obscureText: true,
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(Cores().corBotoes),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(Cores().corTexto),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintText: "Senha",
                      ),
                    ),
                  ),
                  RaisedButton(
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                    onPressed: () {
                      _verificaCampos();
                    },
                    color: Color(Cores().corBotoes),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Color(Cores().corTexto)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        _mensagemErro,
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
