import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//获取首页主题内容
Future getHomePageContent() async {
  try {
    print('开始获取首页主题内容');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    var formData = {
      'lon': '115.02932',
      'lat': '35.78189',
    };
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('throw exception');
    }
  } catch (e) {
    return print('error $e');
  }
}

//获取首页火爆专区数据
Future getHomePageBelowConten() async {
  try {
    print('开始获取首页火爆专区数据');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'], data: page);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('throw exception');
    }
  } catch (e) {
    return print('error $e');
  }

  
}
//{formData}  加大括号变成可选参数
Future request(url, {formData}) async {
  try {
    print('开始获取数据...');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      response = await dio.post(servicePath[url ],);
    } else {
      response = await dio.post(servicePath[url ], data: formData);
    }
    
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('throw exception');
    }
  } catch (e) {
    return print('error $e');
  }
}
