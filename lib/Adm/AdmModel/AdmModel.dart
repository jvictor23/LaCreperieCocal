import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Entity/Venda.dart';

class AdmModel{

  final db = Firestore.instance;

  Future<bool> cadastrarProduto(Produto produto)async{

   DocumentReference rf = await db.collection("Produto").
    document(produto.tipo).
    collection(produto.tipo).add(produto.toMap());

   String id = rf.documentID;
   produto.id = id;

   db.collection("Produto").document(produto.tipo).collection(produto.tipo).document(id).setData(produto.toMap());

    return true;

  }



  bool atualizarProduto(){

  }

  Future<bool> cadastrarVenda(Venda venda,String data)async{
    DocumentReference doc = await db.collection("Vendas").document(data).collection(data).add(venda.toMap());
    venda.idVenda = doc.documentID;
    db.collection("Vendas").document(data).collection(data).document(venda.idVenda).setData(venda.toMap());

    return true;
  }

  Future<QuerySnapshot>buscarVendaMensal(String data)async{
    String _data = data.replaceAll( RegExp(r'/'), "");
    print(_data);

    
    QuerySnapshot querySnapshot = await db.collection("Vendas").
    document(_data).
    collection(_data).getDocuments();

    return querySnapshot;
  }

  bool excluirProduto(String idProduto, String tipoProduto){
    db.collection("Produto").document(tipoProduto).collection(tipoProduto).document(idProduto).delete();
    return true;
  }

  Future<QuerySnapshot> buscarCrepeSalgado() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("Produto").document("Crepe Salgado").collection("Crepe Salgado").getDocuments();
    return querySnapshot;
  }

    Future<List<DocumentSnapshot>>buscarCrepeDoce() async {
    Firestore db = Firestore.instance;
    List<DocumentSnapshot> lista = List();
    QuerySnapshot querySnapshot1 = await db.collection("Produto").document("Crepe Doce").collection("Crepe Doce").getDocuments();
    for(DocumentSnapshot documentSnapshot in querySnapshot1.documents){
      lista.add(documentSnapshot);
    }

    QuerySnapshot querySnapshot2 = await db.collection("Produto").document("Crepe Salgado").collection("Crepe Salgado").getDocuments();
    for(DocumentSnapshot documentSnapshot in querySnapshot2.documents){
      lista.add(documentSnapshot);
    }
    QuerySnapshot querySnapshot3 = await db.collection("Produto").document("Bebidas").collection("Bebidas").getDocuments();
    for(DocumentSnapshot documentSnapshot in querySnapshot3.documents){
      lista.add(documentSnapshot);
    }

   return lista;
  }

  Future<QuerySnapshot> buscarBebidas() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("Produto").document("Bebidas").collection("Bebidas").getDocuments();
    return querySnapshot;
  }
}