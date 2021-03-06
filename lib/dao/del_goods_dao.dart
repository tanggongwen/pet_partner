import 'package:dio/dio.dart';

import 'package:pet_partner/models/entity_factory.dart';
import 'package:pet_partner/models/msg_entity.dart';
import 'dart:async';
import 'config.dart';
const DEL_URL = '$SERVER_HOST/user/cart/update';

class DelDao{

  static Future<MsgEntity> fetch(String id,int count,String token) async{
    try {
      Options options = Options(headers: {"Authorization":token});
      Response response = await Dio().post(DEL_URL+"/"+id+"/"+count.toString(),
          options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<MsgEntity>(response.data);
      }else{
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




