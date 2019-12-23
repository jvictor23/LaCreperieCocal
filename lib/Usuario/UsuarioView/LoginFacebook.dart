import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Principal.dart';

class LoginFacebook extends StatefulWidget {
  @override
  _LoginFacebookState createState() => _LoginFacebookState();

  AuthResult user;
  LoginFacebook(this.user);
}

class _LoginFacebookState extends State<LoginFacebook> {

  UsuarioController _usuarioController = new UsuarioController();

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _verificaCampos(AuthResult user) {
    String nome = _controllerNome.text;
    String endereco = _controllerEndereco.text;
    String telefone = _controllerTelefone.text;

    if (nome.isNotEmpty) {
      if (endereco.isNotEmpty) {
        if (telefone.isNotEmpty) {


              Usuario usuario = Usuario();
              usuario.nome = user.user.displayName;
              usuario.endereco = endereco;
              usuario.telefone = telefone;
              usuario.email = user.user.email;
              usuario.id = user.user.uid;

              if(_usuarioController.cadastrarUsuarioFacebook(usuario) != null){
                setState(() {
                  _controllerNome.clear();
                  _controllerEndereco.clear();
                  _controllerTelefone.clear();
                  _controllerEmail.clear();
                  _controllerSenha.clear();
                });
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Principal()
                ));
              }else{
                setState(() {
                  _mensagemErro = "Erro ao salvar dados, verifique seus dados ou a conexão com a internet e tente novamente!";
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
                      controller: _controllerNome = new TextEditingController(text: widget.user.user.displayName),
                      style: TextStyle(color: Color(Cores().corTexto)),
                      cursorColor: Color(Cores().corTexto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(

                        enabled: false,
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

                  RaisedButton(
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                    onPressed: () {
                      _verificaCampos(widget.user);
                    },
                    color: Color(Cores().corBotoes),
                    child: Text(
                      "Salvar Informações",
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
        )
    );
  }
}
