import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../Cores.dart';



class Bebidas extends StatefulWidget {
  @override
  _BebidasState createState() => _BebidasState();
}

class _BebidasState extends State<Bebidas> {

  AdmController _admController = new AdmController();

  final _controller = StreamController<QuerySnapshot>.broadcast();

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
                  onLongPress: () {
                    showDialog(context: context, builder: (context) {
                      return  AlertDialog(
                        title: Text(produtos["nomeProduto"]),
                        content: Text(produtos["ingredientes"]),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Atualizar")
                          ),
                          FlatButton(
                              onPressed: () {
                                _admController.excluirProduto(produtos["id"], produtos["tipo"]);
                                Navigator.pop(context);
                              },
                              child: Text("Deletar")
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
                  title: Text(produtos["nomeProduto"]),
                  subtitle: Text(produtos["ingredientes"]),
                  trailing: Text("R\$"+produtos["preco"].toString()),
                ),
              );
            },
          );
        }
    );

    return stream;
  }
}