import 'package:dio/dio.dart';
import 'package:pet_partner/models/details_entity.dart';
import 'package:pet_partner/models/entity_factory.dart';
import 'package:pet_partner/models/msg_entity.dart';

import 'dart:async';
import 'config.dart';
const LIKE_URL = '$SERVER_HOST/user/favorite/add/';
class AddLikeDao{

  static Future<MsgEntity> fetch(String token,String id) async {
    try {
      Options options = Options(headers: {"Authorization": token});
      Response response = await Dio().post(LIKE_URL + id, options: options);
      if (response.statusCode == 200) {
        return EntityFactory.generateOBJ<MsgEntity>(response.data);
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}