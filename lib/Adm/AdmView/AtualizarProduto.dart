import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:toast/toast.dart';


class AtualizarProduto extends StatefulWidget {
  @override
  _AtualizarProdutoState createState() => _AtualizarProdutoState();

  DocumentSnapshot produtos;

  AtualizarProduto(this.produtos);

}

class _AtualizarProdutoState extends State<AtualizarProduto> {


  String _mensagemErro ="";

  TextEditingController _controllerTipo = TextEditingController();

  String _nomeProduto;
  String _ingredientes;
  String _tipo;
  String _preco;

  AdmController _admController = AdmController();


  _verificarCampos(){

    if(_nomeProduto.isNotEmpty){
      if(_ingredientes.isNotEmpty){
        if(_tipo.isNotEmpty){
          if(_preco.isNotEmpty){

            Produto produto = Produto();
            produto.nomeProduto = _nomeProduto;
            produto.ingredientes = _ingredientes;
            produto.tipo = _tipo;
            produto.preco = double.parse(_preco);
            produto.id = widget.produtos["id"];
            produto.imagem = widget.produtos["imagem"];

            if(_admController.atualizarProduto(produto)){
              Toast.show("Produto Atualizado!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              Navigator.pop(context);
            }


          }else{
            setState(() {
              _mensagemErro = "O campo preço não pode ficar vazio!";
            });
          }
        }else{
          setState(() {
            _mensagemErro = "O campo tipo não pode ficar vazio!";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "O campo ingredientes não pode ficar vazio!";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "O campo nome do produto não pode ficar vazio!";
      });
    }

  }

  _atualizarProduto(Produto produto){

    Firestore db = Firestore.instance;
    // db.collection("Produto").document(produto.tipo).collection()

  }

  @override
  Widget build(BuildContext context) {

    _nomeProduto = widget.produtos["nomeProduto"];
    _ingredientes = widget.produtos["ingredientes"];
    _tipo = widget.produtos["tipo"];
    _preco = widget.produtos["preco"].toString();



    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Produto"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: TextFormField(
                    initialValue: _nomeProduto,
                    onChanged: (change){
                      _nomeProduto = change;
                    },
                    style: TextStyle(color: Color(Cores().corTexto)),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.restaurant,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Nome do produto",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: TextFormField(
                   // controller: _controllerIgredientes,
                    initialValue: _ingredientes,
                    onChanged: (change){
                      _ingredientes = change;
                    },
                    style: TextStyle(color: Color(Cores().corTexto)),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.fastfood,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Ingredientes",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: TextFormField(
                    initialValue: _tipo,
                    enabled: false,
                    onChanged: (change){
                      _tipo = change;
                    },
                    onTap: (){
                      showDialog(context: context,builder:(context){
                        return  AlertDialog(

                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: (){
                                    setState(() {
                                     _controllerTipo = TextEditingController(text: "Crepe Salgado");
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Crepe Salgado",
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: (){
                                    setState(() {
                                      _controllerTipo = TextEditingController(text: "Crepe Doce");
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Crepe Doce",
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: (){
                                    setState(() {
                                    _controllerTipo = TextEditingController(text: "Bebidas");
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Bebidas",
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ],
                            )
                        );
                      }
                      );
                    },
                    style: TextStyle(color: Color(Cores().corTexto)),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.blur_circular,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Tipo",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    initialValue: _preco,
                    onChanged: (change){
                      _preco = change;
                    },
                    style: TextStyle(color: Color(Cores().corTexto)),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Preço",
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                  onPressed: () {
                    _verificarCampos();
                  },
                  color: Color(Cores().corBotoes),
                  child: Text(
                    "AtualizarProduto",
                    style: TextStyle(color: Color(Cores().corTexto)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
