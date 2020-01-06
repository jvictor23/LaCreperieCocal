import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Principal.dart' as prefix0;
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Cadastro.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/LoginFacebook.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Principal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  UsuarioController _usuarioController = new UsuarioController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  bool _isLoggedIn = true;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _verificaCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;


    if(email.isNotEmpty){
      if(senha.isNotEmpty && senha.length > 6){

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        FirebaseAuth auth = FirebaseAuth.instance;
        auth.signInWithEmailAndPassword(
            email: usuario.email,
            password: usuario.senha
        ).then((firebaseUser){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Principal()
          ));

        }).catchError((error){
          print(error.toString());
          Toast.show(
              "Erro ao logar usuario, verifique email,senha e conexão com a internet!", context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);
        });

      }else{
        Toast.show(
            "O campo senha não pode ficar vazio e deve conter mais de 6 caracteres!", context, duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }

    }else{
      Toast.show(
          "O campo email não pode ficar vazio", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }

  }

  _loginWithFacebook() async {

    facebookLogin.logInWithReadPermissions(["email","public_profile"])
        .then((result){
          switch(result.status){
            case FacebookLoginStatus.loggedIn:
              final token = result.accessToken.token;
              AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
              FirebaseAuth.instance.signInWithCredential(credential)
                  .then((user) async {
                    Firestore db = Firestore.instance;
                    DocumentSnapshot snapshot = await db.collection("Usuarios").document(user.user.uid).get();
                    if(user.user.uid == "iwkIk7JXGhaNaIlxIifytADzz142" || user.user.uid == "am0OXbilJsO8kK5ZbO8M9tJo6RA2"){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => prefix0.Principal()
                      ));
                    }else {
                      if (snapshot.exists) {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => Principal()
                        ));
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => LoginFacebook(user)
                        ));
                      }
                    }

              })
                  .catchError((error){
                Toast.show(
                    "ERROR!", context, duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
              });
              break;
            case FacebookLoginStatus.cancelledByUser:
              print( "Cancelado pelo usuario ---------------------------------"  + FacebookLoginStatus.cancelledByUser.toString());
              Toast.show(
                  "Você cancelou a autenticação!", context, duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
              break;
            case FacebookLoginStatus.error:
              print(result.errorMessage);
              print("Error2 aqui ----------------------------- "+ FacebookLoginStatus.error.toString());
              Toast.show(
                  "Erro ao relalizar autenticação, tente novamente!", context, duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
              break;
          }
    }).catchError((error){
      print(error);
      Toast.show(
          "ERROR!", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    });

  }

    _logout(){
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
    }


  _verificaUsuarioLogado()async{
    FirebaseUser user = await _usuarioController.verificaUsuarioLogado();
    if(user != null) {
      if (user.uid == "iwkIk7JXGhaNaIlxIifytADzz142" || user.uid == "am0OXbilJsO8kK5ZbO8M9tJo6RA2") {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => prefix0.Principal()
        ));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Principal()
        ));
      }
    }
    }

  @override
  void initState() {
    super.initState();

   // FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    _verificaUsuarioLogado();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          color: Color(Cores().backgroundTelas),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "LaCrêperie Cocal",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Crepe Frânces",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Faça login para usar o nosso app!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Use o facebook para logar",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: ()async{
                        _loginWithFacebook();
                      },
                      child:  Image.asset(
                        "images/logo_facebook.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 25, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cadastro()
                                )
                            );
                          },
                          child: Text("Se preferir, cadastre-se aqui"),
                        )),
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
                    padding: EdgeInsets.only(bottom: 12),
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
                      "Entrar",
                      style: TextStyle(color: Color(Cores().corTexto)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}