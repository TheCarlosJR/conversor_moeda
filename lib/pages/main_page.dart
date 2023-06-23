
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:conversor_moeda/repositories/defines.dart';
import 'package:http/http.dart' as http;


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {


  double vDolar = 1;
  double vEuro  = 1;
  final rControl = TextEditingController();
  final uControl = TextEditingController();
  final eControl = TextEditingController();


  //obtem dados backend
  Future<Map> getData() async {
    http.Response response = await http.get(uriRequest);
    return (json.decode(response.body));
  }


  //limpa tudo
  void _clearAll() {
    rControl.text = "";
    uControl.text = "";
    eControl.text = "";
  }


  //obtem string de forma segura
  double? _getCoinChanged(String v) {
    if (v.isEmpty) {
      _clearAll();
      return null;
    }

    double? coin = double.tryParse(v);
    if (coin == null) {
      _clearAll();
      return null;
    }

    return coin;
  }


  //altera dados texto real
  void _realChanged(String v) {
    double? real = _getCoinChanged(v);

    if (real != null) {
      uControl.text = (real / vDolar).toStringAsFixed(2);
      eControl.text = (real / vEuro).toStringAsFixed(2);
    }
  }


  //altera dados texto dolar
  void _dolarChanged(String v) {
    double? dolar = _getCoinChanged(v);

    if (dolar != null) {
      rControl.text = (dolar * vDolar).toStringAsFixed(2);
      eControl.text = ((dolar * vDolar) / vEuro).toStringAsFixed(2);
    }
  }


  //altera dados texto euro
  void _euroChanged(String v) {
    double? euro = _getCoinChanged(v);

    if (euro != null) {
      rControl.text = (euro * vEuro).toStringAsFixed(2);
      uControl.text = ((euro * vEuro) / vDolar).toStringAsFixed(2);
    }
  }


  //cria widget textfield
  Widget buildTextField(
      String labelVal,
      String labelPre,
      Function(String)? txtFunc,
      TextEditingController txtControl) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true), //iOS compativel
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
            width: 4,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
            width: 3,
          ),
        ),
        labelText: labelVal,
        prefixText: labelPre,
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 26,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
      ),
      controller: txtControl,
      onChanged: txtFunc,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Conversor"),
        backgroundColor: Colors.amberAccent,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<Map>(
                future: getData(),
                builder: (context, snapshot) {

                  switch(snapshot.connectionState) {

                    //esperando conexao
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        "Carregando valores...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 24,
                        ),
                      );

                    //resposta padrao
                    default:
                      //verifica erros
                      if(snapshot.hasError) {
                        return const Text(
                          "ERRO: Não foi possível carregar!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                          ),
                        );
                      }

                      //verifica se nenhum erro
                      else {
                        vDolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                        vEuro  = snapshot.data?["results"]["currencies"]["EUR"]["buy"];

                        return Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                print(snapshot.data?["results"]);
                              },
                              iconSize: 150,
                              icon: const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                              ),
                            ),
                            /*
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 150,
                            ),
                             */
                            const Divider(),
                            buildTextField("Real", "R\$ ", _realChanged, rControl),
                            const Divider(),
                            buildTextField("Dolar", "US\$ ", _dolarChanged, uControl),
                            const Divider(),
                            buildTextField("Euro", "€ ", _euroChanged, eControl),
                          ],
                        );
                      } // else
                  } // switch
                }, // builder
            ),
          ),
      ),
    );
  }

}
