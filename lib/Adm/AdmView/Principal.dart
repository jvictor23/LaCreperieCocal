import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Bebidas.dart';
import 'package:lacreperie_cocal/Adm/AdmView/CadastrarProduto.dart';
import 'package:lacreperie_cocal/Adm/AdmView/CrepeDoce.dart';
import 'package:lacreperie_cocal/Adm/AdmView/CrepeSalgado.dart';
import 'package:lacreperie_cocal/Adm/AdmView/ListaPedidos.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Venda.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Vendas.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Login.dart';


class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List<String> _itensMenu = [
    "Sair",
    "Vender",
    "Vendas"
  ];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  _escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
      case "Sair":
        _deslogarUsuario();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Login()
        ));
        break;
      case "Vender":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Venda()
        ));
        break;
      case "Vendas":
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Vendas()
        ));
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
          title: Text("LaCrêperie Cocal Adm"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ListaPedidos()
                ));
              },
            ),
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return _itensMenu.map((String item){
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
              labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: "Crepe \nSalgado",),
                Tab(text: "Crepe \nDoce",),
                Tab(text: "Bebidas",)
              ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CadastrarProduto()
            ));
          },
          backgroundColor: Color(Cores().corBotoes),
          foregroundColor: Colors.black,
          icon: Icon(Icons.add_circle_outline),
          label: Text("Adicionar Produto"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CrepeSalgado(),
            CrepeDoce(),
            Bebidas()
          ],
        )

    );
  }
}
