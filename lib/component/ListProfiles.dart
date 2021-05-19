import 'package:e_vacina/component/MyWidgets.dart';
import 'package:e_vacina/screens/MainScreen.dart';
import 'package:e_vacina/screens/UserConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../globals.dart';

final _storage = new FlutterSecureStorage();

Widget buildListProfiles(
    BuildContext context, int index, String name, String profileId) {
  return GestureDetector(
    onTap: () async {
      await _storage.write(key: 'profileIndex', value: index.toString());
      bool resposta = await userController.checkToken();
      if (resposta) {
        await profileController.getById(profileId);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else
        MyWidgets().logout(context, resposta);
    },
    child: Container(
      height: 70,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.black, width: 1.0),
              bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage("assets/EmptyProfile.png"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("$name"),
              ),
            ]),
            IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () async {
                  bool resposta = await userController.checkToken();
                  if (resposta) {
                    await _storage.write(
                        key: 'profileIndex', value: index.toString());
                    await profileController.getById(profileId);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserConfig()));
                  } else
                    MyWidgets().logout(context, resposta);
                })
          ],
        ),
      ),
    ),
  );
}
