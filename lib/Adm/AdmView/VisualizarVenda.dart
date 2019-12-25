import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';

class VisualizarVenda extends StatefulWidget {
  @override
  _VisualizarVendaState createState() => _VisualizarVendaState();
  DocumentSnapshot documentSnapshot;
  VisualizarVenda(this.documentSnapshot);
}

class _VisualizarVendaState extends State<VisualizarVenda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                child:  Card(
                    margin: EdgeInsets.all(2),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(Cores().corBotoes)
                        ),
                        child:ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Data da venda:",
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Row(
                                children: <Widget>[
                                  Text(
                                    widget.documentSnapshot["dataVenda"],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.documentSnapshot["horaVenda"],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                                )
                              )

                            ],
                          ),
                        )
                    )
                )
            ),
          ),


          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child:  Card(
                    margin: EdgeInsets.all(2),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(Cores().corBotoes)
                        ),
                        child:ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Tipo da venda:",
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.documentSnapshot["tipo"],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                )
            ),
          ),

          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child:  Card(
                    margin: EdgeInsets.all(2),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(Cores().corBotoes)
                        ),
                        child:ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.documentSnapshot["total"].toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                )
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 5),
            child:  Text(
              "Lista de produtos",
              style: TextStyle(
                  fontSize: 10
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.documentSnapshot["listaVenda"].length,
              itemBuilder: (context, index){
                var a = widget.documentSnapshot["listaVenda"][index];
                return Card(
                  margin: EdgeInsets.all(2),
                  color: Color(Cores().corBotoes),
                  child: ListTile(
                    title: Text(a["nomeProduto"]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
