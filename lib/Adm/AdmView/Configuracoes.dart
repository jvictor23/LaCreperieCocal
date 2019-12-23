import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Cores.dart';




class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Nome:"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      style: TextStyle(color: Color(Cores().corTexto)),
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
                    child: TextField(
                      style: TextStyle(color: Color(Cores().corTexto)),
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
                  TextField(
                    style: TextStyle(color: Color(Cores().corTexto)),
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
                    child: RaisedButton(
                      elevation: 20,
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                      onPressed: () {},
                      color: Color(Cores().corBotoes),
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Color(Cores().corTexto)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
