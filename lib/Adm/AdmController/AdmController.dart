import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lacreperie_cocal/Adm/AdmModel/AdmModel.dart';

import 'dart:async';

import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/Venda.dart';

class AdmController{

  AdmModel _admModel;

  AdmController(){
    this._admModel = new AdmModel();
  }

  Future<bool> cadastrarProduto(Produto produto){

    return _admModel.cadastrarProduto(produto);

  }

  bool atualizarProduto(){

  }

  Future<bool> cadastrarVenda(Venda venda, String data){
    return _admModel.cadastrarVenda(venda, data);
  }

  Future<QuerySnapshot>buscarVendaMensal(String data){
   return _admModel.buscarVendaMensal(data);
  }

  bool excluirProduto(String idProduto, String tipoProduto){
    _admModel.excluirProduto(idProduto, tipoProduto);
  }

  Future<QuerySnapshot> buscarCrepeSalgado()async{
    return _admModel.buscarCrepeSalgado();
  }

  Future<List<DocumentSnapshot>> buscarCrepeDoce()async{
    return _admModel.buscarCrepeDoce();
  }

  Future<QuerySnapshot> buscarBebidas() async{
    return _admModel.buscarBebidas();
  }


  /*StreamController<QuerySnapshot> listarCrepeSalgado(){
    return _admModel.listarCrepeSalgado();
  }

  StreamController<QuerySnapshot> listarCrepeDoce(){
    return _admModel.listarCrepeSalgado();
  }

  StreamController<QuerySnapshot> listarBebida(){
    return _admModel.listarCrepeSalgado();
  }*/

}