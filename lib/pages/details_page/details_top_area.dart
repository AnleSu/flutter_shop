import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provide/provide.dart';
import '../../model/details_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  const DetailsTopArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val) {
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if (goodsInfo != null) {
          return Container(
            color: Colors.white,
            child: Column( 
              children: <Widget>[
                _goodsImage(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNumber(goodsInfo.goodsSerialNumber),
                _goodsPrice(goodsInfo.oriPrice,goodsInfo.oriPrice)
              ],
            ),
          );
        } else {
          return Text(
            'Loading ....'
          );
        }
      },
    );
  }
}

Widget _goodsImage(url) {
  return Image.network(
    url,
    width: ScreenUtil().setWidth(740),
  );
}

Widget _goodsName(name) {
  return Container(
    height: ScreenUtil().setHeight(45),
    width: ScreenUtil().setWidth(740),
    padding: EdgeInsets.only(left: 15),
    alignment: Alignment.centerLeft ,
    child: Text(
      name,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(30),
        
      ),
    ),
  );
}

Widget _goodsNumber(num) {
  return Container(
    width: ScreenUtil().setWidth(740),
    padding: EdgeInsets.only(left: 15),
    margin: EdgeInsets.only(top: 8),
    child: Text(
      '编号：$num',
      style: TextStyle(
        fontSize: ScreenUtil().setSp(25)
      ),
    ),
  );
}

Widget _goodsPrice(oriPrice,price) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.only(left: 15),
    margin: EdgeInsets.only(top: 8),
    child: Row(
      children: <Widget>[
        Text(
          '￥${price}',
        ),
        Container(
          width: 50,
        ),
        Text(
          '市场价：￥${oriPrice}',
          style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black26,decoration: TextDecoration.lineThrough),
          
            
          
        )
      ],
    ),
  );
}