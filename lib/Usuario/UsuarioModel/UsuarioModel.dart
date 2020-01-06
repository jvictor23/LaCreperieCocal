import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Entity/Pedido.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Principal.dart';



class UsuarioModel{



  Future<bool> cadastrarUsuario(Usuario usuario)async{

    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {
      usuario.id = firebaseUser.user.uid;
      db.collection("Usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());
    }).catchError((error) {
      print(error.toString());
    });

    return true;
  }

  Future<bool> cadastrarUsuarioFacebook(Usuario usuario)async{

    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;

      db.collection("Usuarios")
          .document(usuario.id)
          .setData(usuario.toMap());

    return true;
  }


  bool logarUsuario(Usuario usuario, BuildContext context){




  }

  Future<FirebaseUser> verificaUsuarioLogado()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    return user;

  }

  enviarCarrinho(Produto produto)async{



    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    Firestore db = Firestore.instance;
    DocumentReference rf = await db.collection("Carrinho").document(user.uid).collection(user.uid).add(produto.toMap());
    String idProdutoCarrinho = rf.documentID;
    produto.id = idProdutoCarrinho;
    db.collection("Carrinho").document(user.uid).collection(user.uid).document(idProdutoCarrinho).setData(produto.toMap());
  }


  atualizaQuantidade(Produto produto)async{
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    db.collection("Carrinho").document(user.uid).collection(user.uid).document(produto.id).setData(produto.toMap());

  }

  removerCarrinho(String idProduto)async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    Firestore db = Firestore.instance;
    db.collection("Carrinho").document(user.uid).collection(user.uid).document(idProduto).delete();
  }

  finalizarPedido(Pedido pedido)async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("Usuarios").document(user.uid).get();
    var dados = snapshot.data;
    pedido.endereco = dados["endereco"];
    pedido.nomeUsuario = dados["nome"];
    pedido.telefone = dados["telefone"];
    pedido.idUsuario = user.uid;

    final ref = db.collection("Pedidos");
    DocumentReference docRef = ref.document();
    docRef.setData(pedido.toMap()).then((doc){
      pedido.idPedido = docRef.documentID;
      db.collection("Pedidos").document(docRef.documentID).setData(pedido.toMap());
    });





    //Limpar Carrinho
    // ignore: missing_return
    DocumentReference doc = await db.collection("Carrinho").document(user.uid).collection(user.uid).getDocuments().then((snapshot){

      for(DocumentSnapshot ds in snapshot.documents){

        ds.reference.delete();
      }

    });

  }

  Future<DocumentSnapshot> buscarUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot = await db.collection("Usuarios").document(user.uid).get();

    return snapshot;
  }



   bool atualizarUsuario(Usuario usuario){
    Firestore db = Firestore.instance;
    db.collection("Usuarios").document(usuario.id).setData(usuario.toMap());
    return true;
  }

  StreamController<QuerySnapshot> listarCrepeSalgado(){

    var _controller = StreamController<QuerySnapshot>.broadcast();
    var stream = Firestore.instance.collection("Produto").document("Crepe Salgado").collection("Crepe Salgado").snapshots();

    stream.listen((snapshot){

      _controller.add(snapshot);

    });
    return _controller;
  }

  StreamController<QuerySnapshot> listarCrepeDoce(){

    var _controller = StreamController<QuerySnapshot>.broadcast();
    var stream = Firestore.instance.collection("Produto").document("Crepe Doce").collection("Crepe CrepeDoce").snapshots();

    stream.listen((snapshot){

      _controller.add(snapshot);

    });
    return _controller;
  }

  StreamController<QuerySnapshot> listarBebida(){
    final _controller = StreamController<QuerySnapshot>.broadcast();
    final stream = Firestore.instance.collection("Produto").document("Bebidas").collection("Bebidas").snapshots();

    stream.listen((snapshot){

      _controller.add(snapshot);

    });
    return _controller;
  }



}