import 'package:date_format/date_format.dart';

class Venda{

 String _dataVenda;
 String _horaVenda;
 double _total;
 List<Map<String,dynamic>> _listaVenda;
 String _tipo;
 String _idVenda;

 Map<String, dynamic> toMap(){
   Map<String, dynamic> map = {
     "dataVenda" : this.dataVenda,
     "horaVenda" : this.horaVenda,
     "total" : this.total,
     "listaVenda" : this.listaVenda,
     "tipo" : this.tipo,
     "idVenda" : this.idVenda
   };
   return map;
 }


 List<Map<String, dynamic>> get listaVenda => _listaVenda;

 set listaVenda(List<Map<String, dynamic>> value) {
   _listaVenda = value;
 }

 double get total => _total;

 set total(double value) {
   _total = value;
 }


 String get dataVenda => _dataVenda;

 set dataVenda(String value) {
   _dataVenda = value;
 }

 String get tipo => _tipo;

 set tipo(String value) {
   _tipo = value;
 }

 String get idVenda => _idVenda;

 set idVenda(String value) {
   _idVenda = value;
 }

 String get horaVenda => _horaVenda;

 set horaVenda(String value) {
   _horaVenda = value;
 }


}