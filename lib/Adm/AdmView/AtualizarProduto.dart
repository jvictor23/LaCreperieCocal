import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';


class AtualizarProduto extends StatefulWidget {
  @override
  _AtualizarProdutoState createState() => _AtualizarProdutoState();
  String nomeProduto;
  String ingredientes;
  String tipo;
  double preco;

  AtualizarProduto(this.nomeProduto, this.ingredientes, this.tipo, this.preco);

}

class _AtualizarProdutoState extends State<AtualizarProduto> {

  TextEditingController _controllerNomeProduto;
  TextEditingController _controllerIgredientes;
  TextEditingController _controllerTipo;
  TextEditingController _controllerPreco;




  String _mensagemErro ="";

  _verificarCampos(){

    String nomeProduto = _controllerNomeProduto.text;
    String ingredientes = _controllerIgredientes.text;
    String tipo= _controllerTipo.text;
    String preco = _controllerPreco.text;

    if(nomeProduto.isNotEmpty){
      if(ingredientes.isNotEmpty){
        if(tipo.isNotEmpty){
          if(preco.isNotEmpty){

            Produto produto = Produto();
            produto.nomeProduto = nomeProduto;
            produto.ingredientes = ingredientes;
            produto.tipo = tipo;
            produto.preco = preco as double;

            _atualizarProduto(produto);

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

      var _nomeProduto = widget.nomeProduto;

   _controllerNomeProduto = new TextEditingController(text: _nomeProduto);
    _controllerIgredientes = new TextEditingController(text: widget.ingredientes);
    _controllerTipo = new TextEditingController(text: widget.tipo);
    _controllerPreco = new TextEditingController(text: widget.preco.toString());

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
                  child: TextField(
                    controller: _controllerNomeProduto,
                    onChanged: (nomeProduto){
                      setState(() {
                        _nomeProduto = nomeProduto;
                      });
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
                  child: TextField(
                    controller: _controllerIgredientes,
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
                  child: TextField(
                    controller: _controllerTipo,
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
                  child: TextField(
                    controller: _controllerPreco,
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
