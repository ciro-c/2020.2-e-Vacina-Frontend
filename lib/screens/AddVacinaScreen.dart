import 'package:e_vacina/component/MyWidgets.dart';
import 'package:e_vacina/screens/MainScreen.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class AddVacina extends StatefulWidget {
  final String vaccineId;
  final dynamic preventDeseases;
  final dynamic recommendations;
  final dynamic name;
  final dynamic description;
  final dynamic numberOfDoses;

  const AddVacina(this.vaccineId, this.preventDeseases, this.recommendations, this.name, this.description, this.numberOfDoses, {Key key}) : super(key: key);
  @override
  _AddVacinaState createState() => _AddVacinaState();
}

class _AddVacinaState extends State<AddVacina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              child: Text(
                widget.name.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 33, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Text("Número de doses: ${widget.numberOfDoses.toString()}",
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.59,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(widget.description.toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.10,
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: MyWidgets().button('Adicionar vacina ao cartão', 240.0,
                    39.0, 15, Colors.red[600], () {
                  vaccineController
                      .postTakenVaccine(widget.vaccineId)
                      .then((resposta) => validate(resposta));
                })),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              // child: Icon(Icons.arrow_downward,),
              child: IconButton(
                iconSize: 40,
                icon: const Icon(Icons.arrow_upward),
                onPressed: () {
                  Navigator.pop(context);
                },
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validate(bool resposta) {
    if (resposta == false) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => PopUpAlertDialog(
                "Vacina já foi inserida na carteira, impossivel inserir novamente",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ));
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => PopUpAlertDialog(
          "Vacina adicionada com sucesso.",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
      );
    }
  }
}
