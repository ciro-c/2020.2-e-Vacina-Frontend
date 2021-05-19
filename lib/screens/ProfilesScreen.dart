import 'package:e_vacina/component/ListProfiles.dart';
import 'package:e_vacina/component/MyWidgets.dart';
import 'package:e_vacina/screens/CreateProfileScreen.dart';
import 'package:flutter/material.dart';
import 'MainScreen.dart';
import '../globals.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List array = profileController.currentName.split(' ');
  String _nome = profileController.currentName;
  

  String splitName(List array) {
    String name;
    if (array.length > 1) {
      name = array[0].substring(0, 1).toUpperCase() +
          array[1].substring(0, 1).toUpperCase();
    } else {
      name = array[0].substring(0, 1).toUpperCase();
    }
    return name;
  }

  void createProfile(bool resposta) {
    if (resposta) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateProfile()));
    } else
      MyWidgets().logout(context, resposta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(right: 30),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 17.5,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  splitName(array),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(
              _nome,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ]),
        ),
        leading: Builder(builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
              alignment: Alignment.centerRight,
            ),
          );
        }),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.add, size: 30),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 40, 30, 40),
                      child: Text(
                        "Adicionar Perfil",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  userController
                      .checkToken()
                      .then((resposta) => createProfile(resposta));
                },
              ),
            ),
            FutureBuilder(
                future: userController.getProfiles(userController.userId),
                builder: (context, projectSnaps) {
                   if (projectSnaps.hasError) {
                return Text("Something went wrong");
              } else if (projectSnaps.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: projectSnaps.data.length,
                      itemBuilder: (context, i) {
                        List profile = projectSnaps.data;
                        return buildListProfiles(
                            context, i, profile[i]['name'], profile[i]['_id']);
                      });
              }else{
                return Center(child: CircularProgressIndicator());
              }
                })
          ],
        ),
      ),
    );
  }
}
