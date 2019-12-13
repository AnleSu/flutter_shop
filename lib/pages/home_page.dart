import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'httpHeaders.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController typeController = TextEditingController();
  String homePageContent = 'loading....';
  int page = 1;
  List<Map> hotGoodsList = [];
  GlobalKey<RefreshFooterState> _footekey = new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    getHomePageContent().then((val) {
      setState(() {
        homePageContent = val;
      });
    });
    _getHotGoods();
  }

  void _getHotGoods() {
    var formPage = {"page": page};
    request('homePageBelowConten', formData: formPage).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    height: 30,
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent, //透明色
    child: Text(
      '火爆专区',
      textAlign: TextAlign.center,
    ),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        //map  遍历
        return InkWell(
          onTap: () {
            Application.router.navigateTo(context, 'detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372), //内部组件的宽度不要超过372
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: 370),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2, //2列
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage build');
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body:
              // SingleChildScrollView(//跟listview冲突
              //   child: Container(
              //     child: Column(
              //       children: <Widget>[
              //         Text(
              //           homePageContent,
              //           // overflow: TextOverflow.ellipsis,
              //           // maxLines: 1,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              FutureBuilder(
            future: request('homePageContent', formData: {
              'lon': '115.02932',
              'lat': '35.78189',
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();
                List<Map> navigatorList =
                    (data['data']['category'] as List).cast();
                String leaderImage = data['data']['shopInfo']['leaderImage'];
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                String adPicture =
                    data['data']['advertesPicture']['PICTURE_ADDRESS'];
                List<Map> recommendList =
                    (data['data']['recommend'] as List).cast();
                String floor1Title =
                    data['data']['floor1Pic']['PICTURE_ADDRESS'];
                List<Map> floor1 = (data['data']['floor1'] as List).cast();
                String floor2Title =
                    data['data']['floor2Pic']['PICTURE_ADDRESS'];
                List<Map> floor2 = (data['data']['floor2'] as List).cast();
                String floor3Title =
                    data['data']['floor3Pic']['PICTURE_ADDRESS'];
                List<Map> floor3 = (data['data']['floor3'] as List).cast();
                return EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key: _footekey,//必须传一个key
                    bgColor: Colors.white,
                    textColor: Colors.pinkAccent,
                    moreInfoColor: Colors.pinkAccent,
                    showMore: false,
                    noMoreText: '',
                    // moreInfo: '加载中',
                    // loadReadyText: '上拉加载',
                    // loadedText:'加载成功',
                    // loadingText: '加载中',
                  ),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(
                        swiperDataList: swiper,
                      ),
                      TopNavigator(
                        navigatorList: navigatorList,
                      ),
                      AdBanner(
                        adPicture: adPicture,
                      ),
                      LeaderPhone(
                        leaderImage: leaderImage,
                        leaderPhone: leaderPhone,
                      ),
                      Recommend(
                        recommendList: recommendList,
                      ),
                      FloorTitle(
                        pictureAddress: floor1Title,
                      ),
                      FloorContent(
                        floorGoodsList: floor1,
                      ),
                      FloorTitle(
                        pictureAddress: floor2Title,
                      ),
                      FloorContent(
                        floorGoodsList: floor2,
                      ),
                      FloorTitle(
                        pictureAddress: floor3Title,
                      ),
                      FloorContent(
                        floorGoodsList: floor3,
                      ),
                      _hotGoods(),
                    ],
                  ),
                  loadMore: () async {
                    var formPage = {"page": page};
                    request('homePageBelowConten', formData: formPage)
                        .then((val) {
                      var data = json.decode(val.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                  },
                );
              } else {
                return Center(
                  child: Center(
                    child: Text('loading...',
                        style: TextStyle(fontSize: ScreenUtil().setSp(18))),
                  ),
                );
              }
            },
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(250),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, 'detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network(
            '${swiperDataList[index]['image']}',
            fit: BoxFit.fill,
          )
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(), //banner  下面的几个圆点儿
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('click gridviewitem');
        Application.router.navigateTo(context, 'detail?id=${item['goodsId']}');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(260),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),//禁止滚动
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//拨打店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  //ios  模拟器不支持打电话 会直接进入else  真机测试没问题
  void _launcherURL() async {
    String url = 'tel:' + leaderPhone;
    // url = 'http://www.baidu.com'; 打开网页OK
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url can`t launch';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      height: ScreenUtil().setHeight(50),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(
          color: Colors.pinkAccent,
        ),
      ),
    );
  }

  Widget _item(index,context) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, 'detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        // height: ScreenUtil().setHeight(300),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 0.5, color: Colors.black12),
            )),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough, //文字中间 加一个横杠
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(280),
      // margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (BuildContext context, int index) {
          return _item(index,context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String pictureAddress;

  const FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0],context),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1],context),
            _goodsItem(floorGoodsList[2],context),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3],context),
        _goodsItem(floorGoodsList[4],context),
      ],
    );
  }

  Widget _goodsItem(Map goods,context) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          Application.router.navigateTo(context, 'detail?id=${goods['goodsId']}');

        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
    request('homePageBelowConten', formData: 1).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
// TextEditingController typeController = TextEditingController();
// String showText = 'welcome to ...';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Home'),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//           child: Column(
//             children: <Widget>[
//               TextField(
//                 controller: typeController,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(10.0),
//                   labelText: 'select type',
//                   helperText: 'place enter type',
//                 ),
//                 autofocus: false,//自动获取焦点

//               ),
//               RaisedButton(
//                 onPressed: _clickAction,
//                 child: Text('select complate'),
//               ),
//               Text(
//                 showText,
//                 // overflow: TextOverflow.ellipsis,
//                 // maxLines: 1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//     );

//   }

//   void _clickAction() {
//     print('select ...');
//     if (typeController.text.toString() == '') {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('empty'),
//         )
//       );
//     } else {
//       getHttp(typeController.text.toString()).then(
//         (value) {
//           setState(() {
//             showText = value['data'].toString();
//           });
//         }
//       );

//     //   postHttp(typeController.text.toString()).then(
//     //     (value) {
//     //       setState(() {
//     //         if (value) {
//     //           showText = value;
//     //         }

//     //       });
//     //     }
//     //   );
//     }
//   }

//   //伪造请求头
//   Future getHttp(String TypeText)async{
//     try{
//       Response response;
//       var data={'name':TypeText};
//       Dio dio = new Dio();
//       dio.options.headers = HttpHeaders;
//       response = await dio.get(
//         "https://time.geekbang.org/serv/v1/column/newAll",
//           queryParameters:data
//       );
//       return response.data;
//     }catch(e){
//       return print(e);
//     }
//   }

//    Future postHttp(String TypeText)async{
//     try{
//       Response response;
//       var data={'name':TypeText};
//       response = await Dio().post(
//         "https://www.easy-mock.com/mock/5dc8d77365dec35bd6e86149/example_copy/selectType",
//           queryParameters:data
//       );
//       return response.data;
//     }catch(e){
//       return print(e);
//     }
//   }
// }
