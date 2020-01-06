import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Entity/Pedido.dart';
import 'package:lacreperie_cocal/Entity/Produto.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Entity/VendaFisica.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioModel/UsuarioModel.dart';


class UsuarioController{

  UsuarioModel _usuarioModel;

  UsuarioController(){
    this._usuarioModel = new UsuarioModel();
  }

  Future<bool> cadastrarUsuario(Usuario usuario){
    return _usuarioModel.cadastrarUsuario(usuario);
  }

  bool logarUsuario(Usuario usuario, BuildContext context){

    return _usuarioModel.logarUsuario(usuario, context);

  }

  Future<DocumentSnapshot>buscarUsuario(){
    return _usuarioModel.buscarUsuario();
  }

  bool atualizarUsuario(Usuario usuario){
   return _usuarioModel.atualizarUsuario(usuario);
  }

  atualizaQuantidade(Produto produto){
    _usuarioModel.atualizaQuantidade(produto);
  }

  Future<bool> cadastrarUsuarioFacebook(Usuario usuario)async{
    _usuarioModel.cadastrarUsuarioFacebook(usuario);
  }

  enviarCarrinho(Produto produto){
    _usuarioModel.enviarCarrinho(produto);
  }

  finalizarPedido(Pedido pedido){
    _usuarioModel.finalizarPedido(pedido);

  }

  removerCarrinho(String idProduto){
    _usuarioModel.removerCarrinho(idProduto);
  }



  Future<FirebaseUser> verificaUsuarioLogado()async{
    return _usuarioModel.verificaUsuarioLogado();
  }

  StreamController<QuerySnapshot> listarCrepeSalgado(){
    return _usuarioModel.listarCrepeSalgado();
  }

  StreamController<QuerySnapshot> listarCrepeDoce(){
    return _usuarioModel.listarCrepeSalgado();
  }

  StreamController<QuerySnapshot> listarBebida(){
    return _usuarioModel.listarCrepeSalgado();
  }

}