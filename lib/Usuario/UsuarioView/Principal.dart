
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Bebidas.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Carrinho.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Configuracoes.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/CrepeDoce.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/CrepeSalgado.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Login.dart';


class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();

}

class _PrincipalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _itensMenu = ["Configurações", "Sair"];

  String _idUser;
  Firestore db = Firestore.instance;
  int _qtdCarrinho = 0;
  UsuarioController _usuarioController = UsuarioController();
  String _mostarQtd = "0";

  _verificaUsuarioLogado()async{
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("usuarios").document(user.uid).get();

   /* if(user == null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => Login()
      ),null);
    }else if(!snapshot.exists){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => Login()
      ),null);
    }*/
  }


  _quantidadeCarrinho()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUser = user.uid;

    db
        .collection("Carrinho")
        .document(_idUser)
        .collection(_idUser)
        .snapshots()
        .listen((snapshot) {
      for (DocumentSnapshot item in snapshot.documents) {
        var totalQtd = item["quantidade"];
        _qtdCarrinho += totalQtd;
      }

      setState(() {
        _mostarQtd = _qtdCarrinho.toString();
      });
      _qtdCarrinho = 0;

    });

  }



  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    //_verificaUsuarioLogado();
    _quantidadeCarrinho();
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Configuracoes())
        );
        break;

      case "Sair":
        _deslogarUsuario();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login())
        );
        break;
    }
  }

  _deslogarUsuario(){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LaCrêperie Cocal"),
          actions: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Carrinho())
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(_mostarQtd),
                  )
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return _itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
              indicatorWeight: 4,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  text: "Crepe \nSalgado",
                ),
                Tab(
                  text: "Crepe \nDoce",
                ),
                Tab(
                  text: "Bebidas",
                )
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[CrepeSalgado(), CrepeDoce(), Bebidas()],
        ));
  }
}
