
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/ItemVenda.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/VendaFisica.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import 'package:toast/toast.dart';

class Venda extends StatefulWidget {
  @override
  _VendaState createState() => _VendaState();
}

class _VendaState extends State<Venda> {

  AdmController _admController = AdmController();
  List<DocumentSnapshot> doc;
  DocumentSnapshot item;
  int _qtd = 1;
  List<Produto> _listaProduto = List<Produto>();
  List<Map<String, dynamic>> _lista = List();
  var _total = 0.00;
  String _mostrarTotal = "0,00";


  _pegarProdutos(Produto produto){
    setState(() {
      _listaProduto.add(produto);
    });

    var total = produto.preco * produto.qtd;

    _total += total;


    setState(() {
      _mostrarTotal = _total.toStringAsFixed(2);
    });

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _admController.buscarCrepeDoce().then((result) {
      doc = result;
    });

      return Scaffold(
        appBar: AppBar(
          title: Text("Venda"),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "R\$" + _mostrarTotal,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            FlatButton(
              disabledTextColor: Colors.black,
              disabledColor: Colors.black,
              child: Text(
                "Confirmar",
                style: TextStyle(
                    color: _listaProduto.isEmpty ? Colors.black : Colors.white
                ),
              ),
              onPressed: _listaProduto.isEmpty ? null : () {
                DateTime _dataEHora = DateTime.now();
                String _data = formatDate(_dataEHora, [mm, yyyy]).toString();
                print("aqui---------- " + _data);

                VendaFisica venda = VendaFisica();
                ItemVenda itemVenda = ItemVenda();

                for (Produto p in _listaProduto) {
                  itemVenda.nomeProduto = p.nomeProduto;
                  itemVenda.qtd = p.qtd;
                  itemVenda.preco = p.preco;
                  _lista.add(itemVenda.toMap());
                }

                venda.dataVenda =
                    formatDate(_dataEHora, [dd, "/", mm, "/", yyyy]).toString();
                venda.horaVenda = formatDate(_dataEHora, [H, ":", nn]).toString();
                venda.listaVenda = _lista;
                venda.tipo = "Fisica";
                venda.total = _total;

                if (_admController.cadastrarVendaFisica(venda, _data) != null) {
                  Toast.show(
                      "Venda realizada!", context, duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                  setState(() {
                    _listaProduto = List();
                    _total = 0.0;
                    _qtd = 0;
                    _mostrarTotal = _total.toStringAsFixed(2);
                    Navigator.pop(context);
                  });
                } else {
                  Toast.show("Erro ao realizar venda, tente novamente!", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              },
            )
          ],
        ),
        body: _listaProduto == null
            ? Center(child: Text("Nenhum produto"),)
            : ListView.builder(
            itemCount: _listaProduto.length,
            itemBuilder: (context, index) {
              Produto produtos = _listaProduto[index];
              return Card(
                color: Color(Cores().corBotoes),
                child: ListTile(
                  leading: Text(produtos.nomeProduto),
                  trailing: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "R\$" + produtos.preco.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.blue
                            ),
                          )
                          ,
                        ),
                        Text(
                          "Qtd:" + produtos.qtd.toString(),
                          style: TextStyle(
                              color: Colors.red
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                      builder: (context){
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 5),
                                child: Text(
                                    produtos.nomeProduto
                                ),
                              ),
                              Text("Quantidade"),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 80, right: 80),
                                child: TextFormField(
                                  initialValue: _qtd
                                      .toString(),
                                  onChanged: (result) {
                                    _qtd = int.parse(
                                        result);
                                  },
                                  keyboardType: TextInputType
                                      .number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius
                                              .circular(6)
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar")
                            ),
                            FlatButton(
                                child: Text("Confirmar"),
                                onPressed: () {
                                  setState(() {
                                    produtos.qtd = _qtd;
                                  });
                                  var x = produtos.qtd * produtos.preco;
                                  _total = x;
                                  setState(() {
                                    _mostrarTotal = _total.toStringAsFixed(2);
                                  });
                                  Navigator.pop(context);
                                }
                            )
                          ],
                        );
                      }
                    );
                  },
                  onLongPress: (){
                    showDialog(
                        context: context,
                      builder: (context){
                          return AlertDialog(
                            title: Text("Deseja remover este produto da lista?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancelar"),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Confirmar"),
                                onPressed: (){
                                  Navigator.pop(context);
                                  var total = produtos.qtd*produtos.preco;
                                  var x = _total - total;
                                  setState(() {
                                    _mostrarTotal = x.toStringAsFixed(2);
                                  });
                                  _total = x;
                                  setState(() {
                                        _listaProduto.removeAt(index);
                                      });
                                },
                              ),
                            ],
                          );
                      }
                    );
                  },
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  if(doc == null){
                    return AlertDialog(
                      content: Center(
                        child: CircularProgressIndicator()
                        )
                      ,);
                  }
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: doc.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot produtos = doc[index];
                                double preco = produtos["preco"];
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: Text(
                                                        produtos["nomeProduto"]),
                                                  ),
                                                  Text("Quantidade"),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: TextFormField(
                                                      initialValue: _qtd
                                                          .toString(),
                                                      onChanged: (result) {
                                                        _qtd = int.parse(
                                                            result);
                                                      },
                                                      keyboardType: TextInputType
                                                          .number,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(6)
                                                          )
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancelar")
                                                ),
                                                FlatButton(
                                                    child: Text("Confirmar"),
                                                    onPressed: () {
                                                      Produto produto = Produto();
                                                      produto.nomeProduto =
                                                      produtos["nomeProduto"];
                                                      produto.preco =
                                                      produtos["preco"];
                                                      produto.qtd = _qtd;
                                                      _pegarProdutos(produto);

                                                      Navigator.pop(context);
                                                    }
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    },
                                    title: Text(produtos["nomeProduto"]),
                                    trailing: Text(
                                        preco.toStringAsFixed(2)),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Fechar")
                        ),
                      ],
                    );
                  }
            );
          },
          child: Icon(Icons.add),
        ),
      );
    }
}
