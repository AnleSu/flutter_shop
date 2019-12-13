import 'package:flutter/material.dart';
import '../model/category_goods_list.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = [];

  getGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }

  getMoreList(List<CategoryListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}