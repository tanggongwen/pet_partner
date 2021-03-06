import 'package:dio/dio.dart';
import 'package:pet_partner/models/entity_factory.dart';
import 'dart:async';
import 'package:pet_partner/models/hot_entity.dart';
import 'config.dart';
const HOT_URL = '$SERVER_HOST/goods/searchHot';
class HotGoodsDao{
  static Future<HotEntity> fetch() async{
    try {
      Response response = await Dio().get(HOT_URL);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<HotEntity>(response.data);
      }else{
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}