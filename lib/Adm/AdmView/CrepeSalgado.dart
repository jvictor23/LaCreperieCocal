import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Adm/AdmView/AtualizarProduto.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:transparent_image/transparent_image.dart';


class CrepeSalgado extends StatefulWidget {
  @override
  _CrepeSalgadoState createState() => _CrepeSalgadoState();
}

class _CrepeSalgadoState extends State<CrepeSalgado> {

  AdmController _admController = new AdmController();

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> _adicionarListenerCrepeSalgado(){
    final stream = Firestore.instance.collection("Produto").document("Crepe Salgado").collection("Crepe Salgado").snapshots();

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
          if (!snapshot.hasData) return Container(child: Center(child: Column(children: <Widget>[Text("Carregando..."),CircularProgressIndicator()],mainAxisAlignment: MainAxisAlignment.center,),),);

          QuerySnapshot querySnapshot = snapshot.data;

          return ListView.builder(
            itemCount: querySnapshot.documents.length,
            itemBuilder: (context, index) {
              List<DocumentSnapshot> doc = querySnapshot.documents.toList();
              DocumentSnapshot produtos = doc[index];
              double preco = produtos["preco"];
              return Card(
                color: Color(Cores().corBotoes),
                child: ListTile(

                  onLongPress: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text(produtos["nomeProduto"]),
                        content: Text(produtos["ingredientes"]),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AtualizarProduto(produtos),
                                ));
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
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "R\$" + preco.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );

    return stream;
  }
}
