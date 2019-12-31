import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Pedido.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:date_format/date_format.dart';
import 'package:lacreperie_cocal/Entity/ItemVenda.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/VendaFisica.dart';
import 'package:lacreperie_cocal/Entity/VendaOnline.dart';
import 'package:toast/toast.dart';

class ListaPedidos extends StatefulWidget {
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  AdmController _admController = AdmController();
  List<DocumentSnapshot> doc;
  DocumentSnapshot item;
  int _qtd = 1;
  List<Map<String, dynamic>> _lista = List();
  Stream<QuerySnapshot> _adicionarListenerListaPedidos(){
   Firestore.instance.collection("Pedidos").getDocuments().then((snapshot){
     _controller.add(snapshot);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerListaPedidos();
  }

  @override
  Widget build(BuildContext context) {

    var stream = StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(child: Center(child: Column(children: <Widget>[Center(child: Text("Carregando..."),),Center(child: CircularProgressIndicator(),)],),),);

          QuerySnapshot querySnapshot = snapshot.data;

          return ListView.builder(
            itemCount: querySnapshot.documents.length,
            itemBuilder: (context, index) {
              List<DocumentSnapshot> doc = querySnapshot.documents.toList();
              DocumentSnapshot pedidos = doc[index];

              return Card(
                color: Color(Cores().corBotoes),
                child: ListTile(

                  onTap: () {

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Pedido(pedidos["nomeUsuario"],pedidos["endereco"], pedidos["telefone"], pedidos["meioPagamento"], pedidos["total"], pedidos["listaPedidos"],pedidos["observacao"])
                    ));

                  },
                  onLongPress: (){
                    showDialog(
                        context: context,
                      builder: (context){
                          return AlertDialog(
                            title: Text("Confirmar Venda?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar"),
                              ),
                              FlatButton(
                                onPressed: (){

                                  DateTime _dataEHora = DateTime.now();
                                  String _data = formatDate(_dataEHora, [mm, yyyy]).toString();

                                  VendaOnline venda = VendaOnline();

                                  venda.dataVenda = formatDate(_dataEHora, [dd, "/", mm, "/", yyyy]).toString();
                                  venda.horaVenda = formatDate(_dataEHora, [H, ":", nn]).toString();
                                  venda.listaVenda = pedidos["listaPedidos"];
                                  venda.tipo = "Online";
                                  venda.total = pedidos["total"];
                                  venda.nomeCliente = pedidos["nomeUsuario"];
                                  venda.metodoPagamento = pedidos["meioPagamento"];
                                  venda.idCliente = pedidos["idUsuario"];

                                  if(_admController.cadastrarVendaOnline(venda, _data)!= null){
                                    Toast.show("Venda realizada!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    Toast.show("Erro ao realizar venda, tente novamente!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  }
                                },
                                child: Text("Confirmar"),
                              ),
                            ],
                          );
                      }
                    );
                  },

                  title: Text(pedidos["nomeUsuario"]),
                ),
              );
            },
          );
        }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
      ),
      body: stream,
    );
  }
}
