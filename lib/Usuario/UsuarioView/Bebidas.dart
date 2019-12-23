import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import '../../Cores.dart';



class Bebidas extends StatefulWidget {
  @override
  _BebidasState createState() => _BebidasState();
}

class _BebidasState extends State<Bebidas> {

  UsuarioController _usuarioController = new UsuarioController();

  final _controller = StreamController<QuerySnapshot>.broadcast();
  int _qtd = 1;

  Stream<QuerySnapshot> _adicionarListenerCrepeSalgado(){
    final stream = Firestore.instance.collection("Produto").document("Bebidas").collection("Bebidas").snapshots();

    stream.listen((snapshot){

      _controller.add(snapshot);

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerCrepeSalgado();
  }

  @override
  Widget build(BuildContext context) {

    var stream = StreamBuilder(
        stream: _controller.stream,

        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(child: Center(child: Column(children: <Widget>[Text("Carregando..."),CircularProgressIndicator()],),),);
          QuerySnapshot querySnapshot = snapshot.data;

          return ListView.builder(
            itemCount: querySnapshot.documents.length,
            itemBuilder: (context, index) {
              List<DocumentSnapshot> doc = querySnapshot.documents.toList();
              DocumentSnapshot produtos = doc[index];

              return Card(
                color: Color(Cores().corBotoes),
                child: ListTile(

                    onTap: () {
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
                                  initialValue: _qtd.toString(),
                                  onChanged: (result){
                                    _qtd = int.parse(result);
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
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar")
                            ),
                            FlatButton(
                                child: Text("Adicionar ao carrinho"),
                                onPressed: (){

                                  Produto produto = Produto();
                                  produto.nomeProduto = produtos["nomeProduto"];
                                  produto.ingredientes = produtos["ingredientes"];
                                  produto.preco = produtos["preco"];
                                  produto.imagem = produtos["imagem"];
                                  produto.qtd = _qtd;
                                  _usuarioController.enviarCarrinho(produto);

                                  Navigator.pop(context);

                                }
                            )
                          ],
                        );
                      });
                    },
                    leading: GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(

                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(color: Colors.grey),
                                    child: Image.network(
                                      produtos["imagem"],
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              )
                          );
                        }
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            produtos["imagem"]
                        ),
                      ),
                    ),
                    title: Padding(
                        padding: EdgeInsets.only(top: 6,),
                        child: Text(produtos["nomeProduto"])
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(produtos["ingredientes"]),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "R\$"+produtos["preco"].toString(),
                          style: TextStyle(
                              color: Colors.blue
                          ),
                        ),
                      ],
                    )
                ),
              );
            },
          );
        }
    );

    return stream;
  }
}