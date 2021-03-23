import 'package:dio/dio.dart';
import 'package:pet_partner/models/cart_goods_query_entity.dart';
import 'package:pet_partner/models/entity_factory.dart';
import 'package:pet_partner/models/order_detail_entity.dart';
import 'package:pet_partner/models/order_entity.dart';
import 'package:pet_partner/receiver/event_bus.dart';
import 'dart:async';

import 'config.dart';

const OREDER_DETAIL_GET_URL = '$SERVER_HOST/user/order/';

class OrderDetailDao{

  static Future<OrderDetailEntry> fetch(String  orderSn,String token) async{
    try {

      Map<String,String> map={"Authorization":token};
      Options options = Options(headers:map);
      Response response = await Dio().get(OREDER_DETAIL_GET_URL+orderSn,options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<OrderDetailEntry>(response.data);
      }else{
        throw Exception("StatusCode: ${response.statusCode}");
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

}