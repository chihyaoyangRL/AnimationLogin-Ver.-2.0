import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

class ConversorController extends GetxController {
  final realController = TextEditingController().obs;
  final dolarController = TextEditingController().obs;
  RxDouble dolar = 0.0.obs;
  RxDouble euro = 0.0.obs;

  void realChanged(String text) async {
    if (isNumeric(text)) {
      double real = double.parse(text);
      dolarController.value.text = (real / dolar.value).toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  void dolarChanged(String text) {
    if (isNumeric(text)) {
      double dolar = double.parse(text);
      realController.value.text = (dolar * this.dolar.value).toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  resetFields() {
    realController.value.clear();
    dolarController.value.clear();
  }

  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse('https://api.hgbrasil.com/finance'));
    return json.decode(response.body);
  }
}