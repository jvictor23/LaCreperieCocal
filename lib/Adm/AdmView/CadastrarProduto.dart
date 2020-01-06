
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lacreperie_cocal/Adm/AdmController/AdmController.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'dart:io';

import 'package:lacreperie_cocal/Entity/Produto.dart';




class CadastrarProduto extends StatefulWidget {
  @override
  _CadastrarProdutoState createState() => _CadastrarProdutoState();
}

class _CadastrarProdutoState extends State<CadastrarProduto> {

  AdmController _admController = new AdmController();

  TextEditingController _controllerNomeProduto = TextEditingController();
  TextEditingController _controllerIgredientes= TextEditingController();
  TextEditingController _controllerTipo = TextEditingController();
  var _controllerPreco = MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ".");
  String _mensagemErro ="";
  File _imagem;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  _verificarCampos(){

    String nomeProduto = _controllerNomeProduto.text;
    String ingredientes = _controllerIgredientes.text;
    String tipo= _controllerTipo.text;
    String p = _controllerPreco.text.replaceAll((r'R$'), "");
    double preco = double.parse(p);

    if(nomeProduto.isNotEmpty){
      if(ingredientes.isNotEmpty){
        if(tipo.isNotEmpty){
          if(preco != null){

            Produto produto = Produto();
            produto.nomeProduto = nomeProduto;
            produto.ingredientes = ingredientes;
            produto.tipo = tipo;
            produto.preco = preco;

            _uploadImagem(produto);

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

  Future _uploadImagem(Produto produto)async{

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("ImagemProduto").child(produto.nomeProduto+".JPEG");

    StorageUploadTask task = arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent storageTaskEvent){

      if(storageTaskEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageTaskEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }


    });

    task.onComplete.then((StorageTaskSnapshot snapshot){

      _recuperarUrlImagem(snapshot,produto);

    });

  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot, Produto produto)async{

    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
      _imagem = null;
    });

    produto.imagem = _urlImagemRecuperada;

    _salvarProduto(produto);

  }



  _salvarProduto(Produto produto){

    if(_admController.cadastrarProduto(produto) != null){
      setState(() {
        _mensagemErro = "Produto Cadastrado!";
      });
      _controllerNomeProduto.clear();
      _controllerIgredientes.clear();
      _controllerTipo.clear();
      _controllerPreco.clear();
    }else{
      setState(() {
        _mensagemErro = "Erro ao cadastrar Produto, tente novamente";
      });
    }



  }

  Future _pegarImagem()async{
    File imagemSelecionada;

    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 350,maxHeight: 450);


    setState(() {
      _imagem = imagemSelecionada;

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Produto"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.grey
                          ),
                          child: _imagem == null
                              ? Text("Nenhuma imagem selecionada")
                              : Image.file(
                              _imagem,
                            fit: BoxFit.fill,

                          ),
                        ),
                        onTap: (){
                          _pegarImagem();
                        },

                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: TextField(
                    controller: _controllerNomeProduto,
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
                    enabled: true,
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
                        TextInputType.number,
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
                    "Cadastrar Produto",
                    style: TextStyle(color: Color(Cores().corTexto)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ),
               Center(
                 child:  _subindoImagem
                     ? CircularProgressIndicator()
                     : Container(),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
