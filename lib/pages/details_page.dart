import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
class DetailsPage extends StatelessWidget {
  final String goodsId;

  const DetailsPage({Key key,this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情'),
      ),
      body: FutureBuilder(
        future: _requestDetailsInfo(context),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsExplain(),
                ],
              ),
            );
          } else {
            return Text('loading');
          }
        },
      ),
     
    );
  }

  Future _requestDetailsInfo(BuildContext context) async {
    Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return 'load complate';
  }
}