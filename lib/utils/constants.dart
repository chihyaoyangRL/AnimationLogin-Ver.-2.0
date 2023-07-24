import 'dart:ui';

const int DB_VERSION = 1;
const String audioPath = '/audio/'; // → não muda
const String DB_NAME = 'ferramenta_db.db';
const Color cor_primary = Color(0xFF158B78);
const Color cor_secondary = Color(0xFF03C7C9);
const double zoom = 16.0;
const double minZoom = 15.0;
const double maxZoom = 18.0;
final RegExp exp = RegExp('\/((?:.(?!\/))+\$)'); //Remover String