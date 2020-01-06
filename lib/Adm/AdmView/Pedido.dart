import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';

class Pedido extends StatefulWidget {

  String nomeCliente;
  String endereco;
  String telefone;
  String tipoPagamento;
  String observacao;
  double total;
  List<dynamic> listaPedido;


  Pedido(this.nomeCliente, this.endereco, this.telefone, this.tipoPagamento, this.total, this.listaPedido, this.observacao);

  @override
  _PedidoState createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
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
                             "Nome do Cliente:",
                             style: TextStyle(
                                 fontSize: 10
                             ),
                           ),

                           Padding(
                             padding: EdgeInsets.only(left: 4),
                             child: Text(
                               widget.nomeCliente,
                               style: TextStyle(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
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
                                    "Endereço:",
                                    style: TextStyle(
                                        fontSize: 10
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      widget.endereco,
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
                                    "Telefone:",
                                    style: TextStyle(
                                        fontSize: 10
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      widget.telefone,
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
                                    "Observação:",
                                    style: TextStyle(
                                        fontSize: 10
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      widget.observacao,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "Método de Pagamento:",
                                    style: TextStyle(
                                      fontSize: 10
                                    ),
                                  ),
                                  Text(
                                    "Total:",
                                    style: TextStyle(
                                        fontSize: 10
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      widget.tipoPagamento,
                                    style: TextStyle(
                                        fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                      widget.total.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
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
                  itemCount: widget.listaPedido.length,
                  itemBuilder: (context, index){
                    var a = widget.listaPedido[index];
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
