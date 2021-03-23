import 'package:dio/dio.dart';
import 'package:pet_partner/models/cart_goods_query_entity.dart';
import 'package:pet_partner/models/entity_factory.dart';

import 'dart:async';

import '../common.dart';
import 'config.dart';

const CART_URL = '$SERVER_HOST/user/cart/queryByUser';
class CartQueryDao{

  static Future<CartGoodsQueryEntity> fetch(String token) async{
    try {
      Options options = Options(headers: {"Authorization":token});
      Response response = await Dio().get(CART_URL,options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<CartGoodsQueryEntity>(response.data);
      }else if(response.statusCode == 401){
        AppConfig.token  = '';
      }else{
        throw Exception("StatusCode: ${response.statusCode}");
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

}