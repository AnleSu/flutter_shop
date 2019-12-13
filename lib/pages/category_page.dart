import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:provide/provide.dart';
import '../provide/child_categoty.dart';
import '../model/category_goods_list.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CategoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

//左侧导航
class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<Data> list = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(150),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(index) {
    bool isClick = false;
    isClick = (index == listIndex);
    return InkWell(
      onTap: () {
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;

        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        setState(() {
          listIndex = index;
        });

        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(90),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      // list.data.forEach((item) => print('${item.mallCategoryName}'));
      setState(() {
        list = category.data;
      });
      //默认选中第一个
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      //先请求category 然后用第一个categoryId 请求goodsList
      _getGoodsList();
    });
  }

  void _getGoodsList({String categoryId, String categorySubId}) async {
    var data = {
      'categoryId':
          Provide.value<ChildCategory>(context).selectCategoryId == null
              ? '4'
              : categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var response = json.decode(val.toString());
      CategoryGoodsListModel model = CategoryGoodsListModel.fromJson(response);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(model.data);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List list = ['全部', '名酒', '北京二锅头', '五粮液', '五粮液', '五粮液', '五粮液', '五粮液'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {

        return Container(
          //横向滚动的listview 必须设置宽高
          height: ScreenUtil().setHeight(70),
          width: ScreenUtil().setWidth(600),
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategorylist.length,
            itemBuilder: (BuildContext context, int index) {
              return _rightInkWell(
                  index, childCategory.childCategorylist[index]);
            },
          ),
        );
      },
    );
  }

  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).selectCategoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var response = json.decode(val.toString());
      CategoryGoodsListModel model = CategoryGoodsListModel.fromJson(response);
      //处理数据为空的情况
      if (model.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(model.data);
      }
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = index == (Provide.value<ChildCategory>(context).childIndex);
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pinkAccent : Colors.black),
        ),
      ),
    );
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footekey = new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {//切换大类或者小类
            scrollController.jumpTo(0.0);
          } else {
          }
        } catch (e) {
          print('第一次进入页面 $e');
        }

        if (data.goodsList.length == 0) {
          return Container(
            child: Text('no data'),
          );
        } else {
          return Expanded(
              child: Container(
                  //必须设置宽高 不然会超出屏幕 报错 或者外面包一层expanded
                  width: ScreenUtil().setWidth(600),
                  // height: ScreenUtil().setHeight(980),
                  child: EasyRefresh(
                    refreshFooter: ClassicsFooter(
                      key: _footekey, //必须传一个key
                      bgColor: Colors.white,
                      textColor: Colors.pinkAccent,
                      moreInfoColor: Colors.pinkAccent,
                      showMore: false,
                      noMoreText:
                          Provide.value<ChildCategory>(context).noMoreText,
                      // moreInfo: '加载中',
                      // loadReadyText: '上拉加载',
                      // loadedText:'加载成功',
                      // loadingText: '加载中',
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: data.goodsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _goodsItem(data.goodsList, index);
                      },
                    ),
                    loadMore: () async {
                      
                      _getMoreGoodsList();
                    },
                  )));
        }
      },
    );
  }

  void _getMoreGoodsList() async {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).selectCategoryId,
      'categorySubId': Provide.value<ChildCategory>(context).selectSubId,
      'page': Provide.value<ChildCategory>(context).page
    };
    await request('getMallGoods', formData: data).then((val) {
      var response = json.decode(val.toString());
      CategoryGoodsListModel model = CategoryGoodsListModel.fromJson(response);
      //处理数据为空的情况
      if (model.data == null) {
        Fluttertoast.showToast(
          msg: '没有更多了',
          toastLength: Toast.LENGTH_LONG,//toast长度
          gravity: ToastGravity.CENTER,//toast位置
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: ScreenUtil().setSp(26),
        );
        Provide.value<ChildCategory>(context).changeNoMoreText('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreList(model.data);
      }
    });
  }

  Widget _goodsImage(List list, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodName(List list, index) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
        ),
      ),
    );
  }

  Widget _goodsPrice(List list, index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '${list[index].presentPrice}',
            style: TextStyle(
                color: Colors.pinkAccent, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '${list[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _goodsItem(List list, index) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.black12, width: 1.0))),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            _goodsImage(list, index),
            Column(
              children: <Widget>[
                _goodName(list, index),
                _goodsPrice(list, index),
              ],
            )
          ],
        ),
      ),
    );
  }
}
