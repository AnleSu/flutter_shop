import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_categoty.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/routers.dart';
import './routers/application.dart';
import './provide/details_info.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var goodsList = CategoryGoodsListProvide();
  var detailsInfo = DetailsInfoProvide();
  
  //新添加一个状态管理 就在下面..后面再添加一行
  providers
  ..provide(Provider<Counter>.value(counter))
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(goodsList))
  ..provide(Provider<DetailsInfoProvide>.value(detailsInfo));
  
  
  runApp(ProviderNode(child: MyApp(),providers: providers,) );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routers.configureRoutes(router);
    Application.router = router;

    return Container(//套一个灵活的widget
      child: MaterialApp(
        title: '百姓生活',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pinkAccent
        ),
        home: IndexPage(),
      ),
    );
  }
}