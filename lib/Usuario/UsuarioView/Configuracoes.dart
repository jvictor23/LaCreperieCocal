import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';
import 'package:lacreperie_cocal/Entity/Usuario.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioController/UsuarioController.dart';
import 'package:toast/toast.dart';


class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  UsuarioController _usuarioController = UsuarioController();
  Usuario _usuario = Usuario();
  DocumentSnapshot _snapshot;


  _verificaCampos(Usuario usuario){
    if(usuario.nome.isNotEmpty){
      if(usuario.endereco.isNotEmpty){
        if(usuario.telefone.isNotEmpty){

          if(_usuarioController.atualizarUsuario(usuario)){
            Toast.show("Dados atualizados!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }else{
            Toast.show("Erro ao atualizar dados, tente novamente!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }

        }else{
          Toast.show("O campo telefone não pode ficar vazio!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }else{
        Toast.show("O campo endereço não pode ficar vazio!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }else{
      Toast.show("O campo nome não pode ficar vazio!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }




  @override
  Widget build(BuildContext context) {

    _usuarioController.buscarUsuario().then((result){
      setState(() {
        _snapshot = result;
      });
    }).catchError((error){
      print(error);
    });

    if(_snapshot != null){
      _usuario.nome = _snapshot["nome"];
      _usuario.endereco = _snapshot["endereco"];
      _usuario.senha = _snapshot["senha"];
      _usuario.id = _snapshot["id"];
      _usuario.email = _snapshot["email"];
      _usuario.telefone = _snapshot["telefone"];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Center(
            child: _snapshot == null ? Center(child: CircularProgressIndicator(),) : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
               Padding(
                 padding: EdgeInsets.only(left: 5),
                 child:  Text("Nome:"),
               ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    enabled: false,
                    initialValue: _usuario.nome == null ? "" : _usuario.nome,
                    onChanged: (changed){
                        _usuario.nome = changed;
                    },
                    style: TextStyle(
                        color: Color(Cores().corTexto)
                    ),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Nome",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Endereço:"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    initialValue: _usuario.endereco == null ? "" : _usuario.endereco,
                    onChanged: (changed){

                        _usuario.endereco = changed;

                    },
                    style: TextStyle(
                        color: Color(Cores().corTexto)
                    ),
                    cursorColor: Color(Cores().corTexto),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(Cores().corBotoes),
                      prefixIcon: Icon(
                        Icons.home,
                        color: Color(Cores().corTexto),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: "Endereço",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Telefone:"),
                ),
                TextFormField(
                  initialValue: _usuario.telefone == null ? "" : _usuario.telefone,
                  onChanged: (changed){

                      _usuario.telefone = changed;

                  },
                  style: TextStyle(
                      color: Color(Cores().corTexto)
                  ),
                  cursorColor: Color(Cores().corTexto),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(Cores().corBotoes),
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Color(Cores().corTexto),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    hintText: "Telefone",
                  ),
                ),
               Padding(
                 padding: EdgeInsets.only(top: 16),
                 child:  RaisedButton(
                   elevation: 20,
                   padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                   onPressed: (){
                     _verificaCampos(_usuario);
                   },
                   color: Color(Cores().corBotoes),
                   child: Text(
                     "Salvar",
                     style: TextStyle(
                         color: Color(Cores().corTexto)
                     ),
                   ),
                 ),
               )
              ],
            ),
          ),
        ),
      )
    );
  }
}
