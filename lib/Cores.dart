class Cores{
  int _backgroundTelas = 0xffEBDFA4;
  int _corBotoes =0xffFEF4B2;
  int _corCaixaTexto = 0xffFEF4B2;
  int _corHint = 0xff808080;
  int _corTexto =0xff000000;

  Cores();

  int get corTexto => _corTexto;

  int get corHint => _corHint;

  int get corCaixaTexto => _corCaixaTexto;

  int get corBotoes => _corBotoes;

  int get backgroundTelas => _backgroundTelas;


}