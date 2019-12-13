import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provide/provide.dart';
import '../../model/details_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {
  const DetailsTabbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val) {
        var isSelectLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isSelectRight= Provide.value<DetailsInfoProvide>(context).isRight;
        return Container(
          margin: EdgeInsets.only(top: 15),
          
        );
      },
    );
  }
}

Widget _myTabbar(BuildContext context, bool isLeft , bool isSelectLeft) {
  return InkWell(
    onTap: () {
      Provide.value<DetailsInfoProvide>(context).changeLeftOrRight(isLeft ? 'left' : 'right');
    },
    child: Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      width: ScreenUtil().setWidth(375),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1,color: isSelectLeft ? Colors.pinkAccent : Colors.black12))
      ),
      child: Text(
        isLeft ? '详情' : '评论',
        style: TextStyle(
          color: isSelectLeft ? Colors.pinkAccent : Colors.black12
        ),
      ),
    ),
  );
}