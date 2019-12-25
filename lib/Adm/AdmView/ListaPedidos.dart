import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Pedido.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:date_format/date_format.dart';
import 'package:lacreperie_cocal/Entity/ItemVendaFisica.dart';
import 'package:lacreperie_cocal/Entity/ItemVendaOnline.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/Venda.dart';
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
  List<Produto> _listaProduto = List<Produto>();
  List<Map<String, dynamic>> _lista = List();
  var _total = 0.00;
  String _mostrarTotal = "0,00";

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

                                  DateTime _dataEHora = DateTime.now();
                                  String _data = formatDate(_dataEHora, [mm, yyyy]).toString();

                                  Venda venda = Venda();
                                  ItemVendaOnline itemVenda = ItemVendaOnline();

                                  for(Produto p in _listaProduto){
                                    itemVenda.nomeProduto = p.nomeProduto;
                                    itemVenda.qtd = p.qtd;
                                    itemVenda.preco = p.preco;
                                    _lista.add(itemVenda.toMap());
                                  }

                                  venda.dataVenda = formatDate(_dataEHora, [dd, "/", mm, "/", yyyy]).toString();
                                  venda.horaVenda = formatDate(_dataEHora, [H, ":", nn]).toString();
                                  venda.listaVenda = _lista;
                                  venda.tipo = "Online";
                                  venda.total = _total;

                                  if(_admController.cadastrarVenda(venda, _data)!= null){
                                    Toast.show("Venda realizada!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                    setState(() {
                                      _listaProduto = List();
                                      _total = 0.0;
                                      _qtd = 0;
                                      _mostrarTotal = _total.toString();
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    Toast.show("Erro ao realizar venda, tente novamente!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  }
                                },
                                child: Text("Confirmar"),
                              ),
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar"),
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
