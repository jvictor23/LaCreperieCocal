import 'package:flutter/material.dart';
import 'package:lacreperie_cocal/Adm/AdmView/Pedido.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/Login.dart';
import 'package:lacreperie_cocal/Usuario/UsuarioView/LoginFacebook.dart';

ThemeData data = new ThemeData(
    primaryColor: Color(0xff000000),
    primaryColorDark: Colors.grey,
    accentColor: Color(0xff000000),
    scaffoldBackgroundColor: Color(0xffEBDFA4)
);

void main() => runApp(
    MaterialApp(
  theme: data,
  home: Login(),
  debugShowCheckedModeBanner: false,
));

