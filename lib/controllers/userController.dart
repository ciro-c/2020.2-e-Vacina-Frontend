import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:e_vacina/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'userController.g.dart';

class UserController = UserControllerBase with _$UserController;

final _storage = new FlutterSecureStorage();

abstract class UserControllerBase with Store {
  @observable
  String email = '';

  @action
  changeEmail(String value) => email = value;

  @observable
  String phoneNumber = '';

  @action
  changePhoneNumber(String value) => phoneNumber = value;

  @observable
  String password = '';

  @action
  changePassword(String value) => password = value;

  @observable
  String userId = '';

  @action
  changeUserId(String value) => userId = value;

  @observable
  dynamic token = '';

  @action
  changeToken(String value) => token = value;

  @observable
  List profiles;

  @action
  changeProfiles(List value) => profiles = value;

  @observable
  bool isRegister = false;

  @action
  changeRegister(bool value) => isRegister = value;

  @action
  login(String email, String password) async {
    var resposta = true;
    try {
      Response response = await api.auth(email, password);
      changeToken(response.data['token']);
      changeUserId(response.data['user']['_id']);
      changeEmail(response.data['user']['email']);
      changePhoneNumber(response.data['user']['phoneNumber']);
      await getProfiles(userId);
      if (!isRegister) {
        await profileController
            .changeCurrentId(profiles[profileController.currentIndex]['_id']);
        await _storage.write(key: 'email', value: email);
        await _storage.write(key: 'password', value: password);
        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'userId', value: userId);
      }
    } on DioError catch (err) {
      print("Erro: ${err.response.statusCode}");
      resposta = false;
    }
    return resposta;
  }

  @action
  persistLogin() async {
    bool _resposta = true;
    try {
      String _password = await _storage.read(key: 'password');
      String _email = await _storage.read(key: 'email');
      String _index = await _storage.read(key: 'profileIndex') ?? "0";
      int intParse = int.parse(_index);
      profileController.changeCurrentIndex(intParse);
      bool rLogin = await login(_email, _password);
      if (!rLogin) _resposta = false;
    } catch (err) {
      _resposta = false;
    }
    return _resposta;
  }

  @action
  logout() async {
    changeToken('');
    changeUserId('');
    await _storage.write(key: 'profileIndex', value: "0");
    await _storage.deleteAll();
  }

  @action
  register(String email, String phoneNumber, String password, String name,
      String cpf, String sex, String birthDate) async {
    String resposta = "true";
    changeRegister(true);
    try {
      await api.registerUser(email, phoneNumber, password);
      await login(email, password);
    } catch (err) {
      return err.response.data.toString();
    }
    bool rProfile = await profileController.createProfile(
        userId, name, cpf, sex, birthDate);
    if (!rProfile) resposta = "false";
    profileController.changeCurrentIndex(0);
    changeEmail(email);
    changePassword(password);
    changePhoneNumber(phoneNumber);
    if (resposta == "false") {
      try {
        await delete();
      } catch (e2) {
        print("erro delete: $e2");
      }
    }
    changeRegister(false);

    return resposta;
  }

  @action
  delete() async {
    await api.deleteUser(userId, token);
  }

  @action
  update(String email, String phoneNumber, String password) async {
    bool _resposta = true;
    try {
      Response response =
          await api.updateUser(email, phoneNumber, password, userId, token);
      changeEmail(response.data['updtedUser']['email']);
      changePhoneNumber(response.data['updtedUser']['phoneNumber']);
    } catch (err) {
      print(err.response.data);
      _resposta = false;
    }
    return _resposta;
  }

  @action
  getProfiles(String userId) async {
    Response response = await api.getProfilesByUserId(userId);
    await changeProfiles(response.data['user']['profilesIds']);
    return response.data['user']['profilesIds'];
  }

  @action
  checkToken() async {
    bool _resposta = true;
    bool hasExpired = JwtDecoder.isExpired(token);
    if (hasExpired) {
      if (!await persistLogin()) _resposta = false;
    }
    return _resposta;
  }
}
