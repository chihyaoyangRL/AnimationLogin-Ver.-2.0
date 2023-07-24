import 'package:get/get.dart';
import '../../controller..dart';
import '../../utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animationlogin2/screen/conversor/ConversorController.dart';

class ConversorPage extends StatefulWidget {
  @override
  _ConversorPageState createState() => _ConversorPageState();
}

class _ConversorPageState extends State<ConversorPage> {
  final ConversorController controller = Get.put(ConversorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cor_primary,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('conversor'.tr),
        backgroundColor: cor_primary,
        actions: [IconButton(onPressed: () => controller.resetFields(), icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: controller.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: loading.loader(cor_primary));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.data != null && !snapshot.data.isEmpty) {
                controller.dolar.value = snapshot.data['results']['currencies']['USD']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.white),
                      Obx(() => customTextField("real".tr, " R\$ ", controller.realController.value, controller.realChanged)),
                      SizedBox(height: 5),
                      Obx(() => customTextField("dolar".tr, " \$ ", controller.dolarController.value, controller.dolarChanged)),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('notFound'.tr, style: TextStyle(color: Colors.red)));
              }
              break;
          }
          return null;
        },
      ),
    );
  }

  Widget customTextField(String label, String prefix, TextEditingController controller, Function fun) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
      child: TextFormField(
        controller: controller,
        onChanged: fun,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixText: prefix,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(top: 25.0, right: 30.0, bottom: 20.0, left: 5.0),
        ),
      ),
    );
  }
}