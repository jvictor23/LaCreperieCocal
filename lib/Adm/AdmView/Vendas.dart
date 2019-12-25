import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Adm/AdmView/VisualizarVenda.dart';
import 'package:lacreperie_cocal/Cores.dart';

class Vendas extends StatefulWidget {
  @override
  _VendasState createState() => _VendasState();
}

class _VendasState extends State<Vendas> {

  DateTime _data = DateTime.now();
  TextEditingController _controllerData = TextEditingController();
  AdmController _admController = AdmController();
  QuerySnapshot _querySnapshot;
  String _mostrarTotal = "0,00";
  double _total = 0.0;
  double _ultimoTotal = 0.0;

  _somarVenda(){
    for(DocumentSnapshot documentSnapshot in _querySnapshot.documents){
      var total = documentSnapshot["total"];
      _total += total;
    }

    setState(() {
      _mostrarTotal = _total.toString();
    });

    _ultimoTotal = _total;
    _total = 0.0;

    print(_ultimoTotal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendas"),
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
          IconButton(
            icon: Icon(
                Icons.calendar_today,
              //color: Colors.white,
            ),
            onPressed: ()async{

              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Escolha o tipo de busca"),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Mensal"),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Digite o mês da venda (Ex. 15/2019)"),
                                  content: TextField(
                                    autofocus: true,
                                  controller: _controllerData,
                                  style: TextStyle(color: Color(Cores().corTexto)),
                                  cursorColor: Color(Cores().corTexto),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(Cores().corBotoes),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancelar"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Confirmar"),
                                      onPressed: ()async{

                                        _admController.buscarVendaMensal(_controllerData.text)
                                            .then((result){
                                              setState(() {
                                                _querySnapshot = result;
                                                _somarVenda();
                                              });
                                        })
                                            .catchError((error){
                                              print(error);
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        ),
                        FlatButton(
                          child: Text("Diário"),
                          onPressed: ()async{
                            final dtPick = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2025)
              );

              if(dtPick != null && dtPick != _data){
                setState(() {
                  _data = dtPick;
                });
              }

              String data = formatDate(_data, [mm, yyyy]);
              String dataDia = formatDate(_data, [dd, "/", mm, "/", yyyy]);

              _admController.buscarVendaDiario(data, dataDia).then((result){
                setState(() {
                  _querySnapshot = result;
                  _somarVenda();
                });
              }).catchError((error){
                print(error);
              });

              Navigator.pop(context);

              },
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
                }
              );



            },
          )
        ],
      ),
      body: _querySnapshot == null ? Center(child: Text(""),) : ListView.builder(
          itemCount: _querySnapshot.documents.length,
          itemBuilder: (context, index){
            DocumentSnapshot documentSnapshot = _querySnapshot.documents[index];
            if(documentSnapshot == null){
              return CircularProgressIndicator();
            }else{
              return Card(
                color: Color(Cores().corBotoes),
                child: ListTile(
                  leading: Text(documentSnapshot["dataVenda"]),
                  trailing: Text(documentSnapshot["horaVenda"]),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VisualizarVenda(documentSnapshot)));
                  },

                ),
              );
            }

          }
      ),
    );
  }
}
