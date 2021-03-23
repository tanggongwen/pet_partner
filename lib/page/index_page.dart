import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_partner/common.dart';
import 'package:pet_partner/dao/user_dao.dart';
import 'package:pet_partner/models/user_entity.dart';


import 'package:pet_partner/page/cart_page.dart';
import 'package:pet_partner/page/member_page.dart';

import 'package:pet_partner/page/search_page.dart';

import 'package:pet_partner/receiver/event_bus.dart';
import 'package:pet_partner/routes/routes.dart';
import 'package:pet_partner/utils/app_size.dart';

import 'package:pet_partner/utils/dialog_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home_shop_page.dart';

class IndexPage extends StatefulWidget {

  @override
  _IndexPageState createState() => _IndexPageState();
}

final List<BottomNavigationBarItem> bottomBar = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text("小铺")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), title: Text("发现")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart), title: Text("购物车")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), title: Text("我的"))
];

final List<Widget> pages = <Widget>[
  HomePage(),
  SearchPage(),
  CartPage(),
  MemberPage()
];

class _IndexPageState extends State<IndexPage>  with AutomaticKeepAliveClientMixin{

  DateTime lastPopTime;
  String token;
  int currentIndex=0;

  @override
  void initState() {
    super.initState();
//    print("--*-- _IndexPageState");
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 初始化屏幕适配包
    AppSize.init(context);

    _listen();
    return WillPopScope(

      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: this.currentIndex,
            onTap: (index) async{

              if(index==3) {
                SharedPreferences prefs = await SharedPreferences
                    .getInstance();
                if (null == prefs.getString("token")||prefs.getString("token").isEmpty) {
                  Routes.instance.navigateTo(context, Routes.login_page);
                  return;
                }
                AppConfig.token=prefs.getString("token");
                loadUserInfo();
                setState(() {
                  this.currentIndex = index;
                  pageController.jumpToPage(index);
                });

              }else{
                setState(() {
                  this.currentIndex = index;
                  pageController.jumpToPage(index);
                });
              }

            },
            items: bottomBar),
        body: _getPageBody(context),
      ) ,
        onWillPop:  ()async{
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            DialogUtil.buildToast('再按一次退出');
          } else {
            lastPopTime = DateTime.now();
            // 退出app
           return await SystemChannels.platform.invokeMethod('SystemNavigator.pop');

          }
        }
    );

  }


  final pageController = PageController();
  Widget _getPageBody(BuildContext context){

         return PageView(
            controller: pageController,
            children: pages,
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
          );


  }
  StreamSubscription _indexSubscription;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  void _listen() {
    _indexSubscription = eventBus.on<IndexInEvent>().listen((event) {
      int index = int.parse(event.index);
      this.currentIndex = index;
      pageController.jumpToPage(index);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _indexSubscription.cancel();
  }
  loadUserInfo() async {
    UserEntity entity = await UserDao.fetch(AppConfig.token);
    if (entity?.userInfoModel != null) {
      AppConfig.nickName=entity.userInfoModel.nickName;
      AppConfig.mobile=entity.userInfoModel.mobile;
      AppConfig.avatar=entity.userInfoModel.avatar;
      AppConfig.gender=entity.userInfoModel.gender;
    }else{
      SharedPreferences prefs = await SharedPreferences
          .getInstance();
      if (null == prefs.getString("token")||prefs.getString("token").isEmpty) {
        Routes.instance.navigateTo(context, Routes.login_page);
        DialogUtil.buildToast("token失效~");
        return;
      }



    }
  }
}
