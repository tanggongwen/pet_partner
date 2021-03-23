import 'package:pet_partner/models/goods_entity.dart';

class HotEntity {
  List<GoodsModel> goods;
  HotEntity({this.goods});
  HotEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      goods = new List<GoodsModel>();
//			print(goods.runtimeType);
      List<Map> dataList= (json['data'] as List).cast();
      dataList.forEach((v) {
        goods.add(new GoodsModel.fromJson(v));
//				print(goods.length);
      }
      );
    }
  }
}
