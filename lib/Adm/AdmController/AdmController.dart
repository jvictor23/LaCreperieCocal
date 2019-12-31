import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lacreperie_cocal/Adm/AdmModel/AdmModel.dart';

import 'dart:async';

import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/VendaFisica.dart';
import 'package:lacreperie_cocal/Entity/VendaOnline.dart';

class AdmController{

  AdmModel _admModel;

  AdmController(){
    this._admModel = new AdmModel();
  }

  Future<bool> cadastrarProduto(Produto produto){

    return _admModel.cadastrarProduto(produto);

  }

  bool atualizarProduto(Produto produto){
    return _admModel.atualizarProduto(produto);
  }

  bool excluirPedido(String idPedido){
   return _admModel.excluirPedido(idPedido);
  }

  Future<bool> cadastrarVendaFisica(VendaFisica venda, String data){
    return _admModel.cadastrarVendaFisica(venda, data);
  }

  Future<bool> cadastrarVendaOnline(VendaOnline venda, String data){
    return _admModel.cadastrarVendaOnline(venda, data);
  }

  Future<QuerySnapshot> buscarVendaMensal(String data){
   return _admModel.buscarVendaMensal(data);
  }

  Future<QuerySnapshot> buscarVendaDiario(String data, String dataDia){
   return _admModel.buscarVendaDiario(data, dataDia);
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