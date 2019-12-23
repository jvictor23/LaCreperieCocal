import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/ItemPedido.dart';
import 'package:lacreperie_cocal/Entity/Pedido.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {

  String _obs;
  String _metodoPagamento;
  UsuarioController _usuarioController = new UsuarioController();
  TextEditingController _controllerObs = new TextEditingController();
  List<DocumentSnapshot> _doc;
  List<Map<String, dynamic>> itensCarrinho = new List();

  bool _estadoSwitch = false;
  String _idUser;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _mostrarTotal = "0,00";
  var _total = 0.00;
  int _qtd = 1;

  _recuperarDadosUsuario() async {
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
        var total = item["preco"] * item["quantidade"];
        _total += total;
      }

      setState(() {
        _mostrarTotal = _total.toString();
      });

    });

    _adicionarListenerCarrinho();
  }

  // ignore: missing_return
  Stream<QuerySnapshot> _adicionarListenerCarrinho() {
    final stream = db
        .collection("Carrinho")
        .document(_idUser)
        .collection(_idUser)
        .snapshots();

    stream.listen((snapshot) {
      _controller.add(snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "R\$" + _mostrarTotal,
                style: TextStyle(fontSize: 25),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Carregando..."),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
            QuerySnapshot querySnapshot = snapshot.data;


            return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (context, index) {
                 _doc = querySnapshot.documents.toList();
                 DocumentSnapshot produtos = _doc[index];
                  return Card(
                    color: Color(Cores().corBotoes),
                    child: ListTile(
                      onTap: (){
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text(produtos["nomeProduto"]),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(produtos["ingredientes"]),
                                ),
                                Text("Quantidade"),
                                Padding(
                                  padding: EdgeInsets.only(left: 80, right: 80),
                                  child: TextFormField(
                                    initialValue: produtos["quantidade"].toString(),
                                    onChanged: (result){
                                      _qtd = int.parse(result);
                                      Produto produto = new Produto();
                                      produto.id = produtos["id"];
                                      produto.imagem = produtos["imagem"];
                                      produto.ingredientes = produtos["ingredientes"];
                                      produto.nomeProduto = produtos["nomeProduto"];
                                      produto.preco =  produtos["preco"];
                                      produto.qtd = _qtd;

                                      _usuarioController.atualizaQuantidade(produto);

                                      if(_qtd == 0){
                                      _usuarioController.removerCarrinho(produto.id);
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6)
                                        )
                                    ),
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Fechar"),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Deseja remover este produto do carrinho?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Confirmar"),
                                    onPressed: (){

                                      _usuarioController.removerCarrinho(produtos["id"]);

                                      var total = produtos["quantidade"]*produtos["preco"];
                                      var x =_total-total;
                                      setState(() {
                                        _mostrarTotal=x.toString();
                                      });

                                      Navigator.pop(context);

                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration:
                                          BoxDecoration(color: Colors.grey),
                                          child: Image.network(
                                            produtos["imagem"],
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      ],
                                    ));
                              });
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(produtos["imagem"]),
                        ),
                      ),
                      title: Padding(
                          padding: EdgeInsets.only(top: 6,),
                          child: Text(
                            produtos["nomeProduto"],
                            style: TextStyle(
                                fontSize: 16
                            ),
                          )
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(produtos["ingredientes"]),
                      ),
                      trailing: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                  "R\$" + produtos["preco"].toString(),
                                style: TextStyle(
                                    color: Colors.blue
                                ),
                              )
                              ,
                            ),
                            Text(
                                "Qtd:"+produtos["quantidade"].toString(),
                              style: TextStyle(
                                color: Colors.red
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Finalizar Pedido"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Dinheiro"),
                            Switch(
                              value: _estadoSwitch,
                              onChanged: (toque) {
                                setState(() {
                                  _estadoSwitch = toque;
                                });
                              },
                            ),
                            Text("Cartão")
                          ],
                        ),
                        TextField(
                          controller: _controllerObs,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Observação",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1))),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.white,
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      color: Colors.white,
                      child: Text("Confirmar"),
                      onPressed: (){
                        if(_estadoSwitch){
                          setState(() {
                            _metodoPagamento = "Cartão";
                          });
                        }else{
                          setState(() {
                            _metodoPagamento = "Dinheiro";
                          });
                        }



                      ItemPedido itemPedido = new ItemPedido();
                        for(DocumentSnapshot a in _doc){

                          itemPedido.nomeProduto = a["nomeProduto"];
                          itemPedido.ingredientes = a["ingredientes"];
                          itemPedido.imagem = a["imagem"];
                          itemPedido.preco = a["preco"];
                          itensCarrinho.add(itemPedido.toMap());

                        }


                       Pedido pedido = new Pedido();
                       pedido.mapItemPedido = itensCarrinho;
                       pedido.meioPagamento = _metodoPagamento;
                       pedido.total = _total;
                       pedido.observacao = _controllerObs.text;
                        _usuarioController.finalizarPedido(pedido);
                        Navigator.pop(context);

                      },
                    )
                  ],
                );
              });
        },
        backgroundColor: Color(Cores().corBotoes),
        foregroundColor: Colors.black,
        icon: Icon(Icons.playlist_add_check),
        label: Text("Finalizar"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
