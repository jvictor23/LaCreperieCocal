import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Pedido.dart';
import 'package:lacreperie_cocal/Cores.dart';

class ListaPedidos extends StatefulWidget {
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

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
          if (!snapshot.hasData) return Container(child: Center(child: Column(children: <Widget>[Text("Carregando..."),CircularProgressIndicator()],),),);

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
