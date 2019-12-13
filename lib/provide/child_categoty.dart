import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategorylist = [];
  int childIndex = 0;//右侧小类 用于做点击选中的效果
  String selectCategoryId = '4';
  String selectSubId = '';
  int page = 1; //列表页数
  String noMoreText = '';//无数据的文字

  //点击左侧大类 更新右侧小类
  getChildCategory(List<BxMallSubDto> list, String categoryId) {
    childIndex = 0;//点击左侧大类  清0
    selectCategoryId = categoryId;
    selectSubId = '';
    page = 1;
    noMoreText = '';
    BxMallSubDto all = BxMallSubDto();
    all.mallSubName = '全部';
    all.mallCategoryId = categoryId;
    all.mallSubId = '';
    all.comments = 'null';
    childCategorylist = [all];
    childCategorylist.addAll(list);
    notifyListeners();
  }

  //点击右侧小类
  changeChildIndex(index,String subId) {
    childIndex = index;
    selectSubId = subId;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  addPage() {
    page++;
    // notifyListeners();//这里改变的时候不需要刷新页面
  }

  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}