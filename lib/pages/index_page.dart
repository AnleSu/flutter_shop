import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),
    title: Text('首页'),
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.search),
    title: Text('分类'),
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart),
    title: Text('购物车'),
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled),
    title: Text('会员中心'),
    ),

  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage(),
  ];

  int currentIndex = 0;

  var currentPage;

  @override
  void initState() { 
    super.initState();
    currentPage = tabBodies[currentIndex];
  }

  @override
  Widget build(BuildContext context) {

    //初始化 设计稿的尺寸 放在main.dart home里面的第一个页面的build中设置
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    //打印要放在初始化后面
    print('设备尺寸：width - ${ScreenUtil.screenWidth}  height - ${ScreenUtil.screenHeight}');

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,//3个以上才有效果
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (i) {
          setState(() {
            currentIndex = i;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: IndexedStack(//保持页面状态 需要用这个  在每个子页面中混入 AutomaticKeepAliveClientMixin  重写wantKeepAlive true
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}