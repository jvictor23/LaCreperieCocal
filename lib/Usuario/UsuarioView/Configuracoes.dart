import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
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
  String _nome;
  String _endereco;
  String _telefone;




  _verificaCampos(Usuario usuario){
    if(usuario.nome != null){
      if(usuario.endereco != null){
        if(usuario.telefone != null){

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
                          _endereco = changed;
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

                    _telefone = changed;

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

                     if(_endereco == null){
                       _endereco = _snapshot["endereco"];
                     }
                     if(_telefone == null){
                       _telefone = _snapshot["telefone"];
                     }
                     print("aqui endereco - "+_endereco.toString());
                     print("aqui telefone - "+_telefone.toString());

                     _usuario.endereco = _endereco;
                     _usuario.telefone = _telefone;
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
