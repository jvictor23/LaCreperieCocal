
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
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
  String _mostarQtd = "0";
  String _mensagem = "Carregando";
  bool _tempo = false;
  StreamSubscription<DataConnectionStatus> listener;
  bool _conexao = false;

  _verificaUsuarioLogado()async{
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentSnapshot snapshot = await db.collection("Usuarios").document(user.uid).get();

    if(user == null){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Login()
      ));
    }else if(!snapshot.exists){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Login()
      ));
    }
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

  _pegarConexao()async{
    DataConnectionStatus status = await checkInternet();
    if(status == DataConnectionStatus.connected){
        setState(() {
          _conexao = true;
        });

    }

  }


  checkInternet()async{
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _pegarConexao();
    _verificaUsuarioLogado();
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
    Timer(Duration(seconds: 5),(){
      setState(() {
        _mensagem = "Verifique sua conexão com a internet";
        _tempo = true;
      });
    });

    return _conexao == false ? Scaffold(body:
    Center(
        child: _tempo == true ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          <Widget>[
            Text(_mensagem),
            RaisedButton(
              color: Color(Cores().corBotoes),
              child: Text("Recarregar"),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Principal()
                ));
              },
            )
          ],
        ) : Center(child: CircularProgressIndicator(),)
    )
    ) : Scaffold(
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
          children: <Widget>[
            CrepeSalgado(), CrepeDoce(), Bebidas()
          ],
        )
    );
  }
  @override
  void didUpdateWidget(Principal oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    build(context);
  }
}



