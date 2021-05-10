import 'dart:convert';

class CatModel {
  String id;
  String imageUrl;
  int imageWidth;
  int imageHeight;
  bool isFavorite = false;

  CatModel({this.id, this.imageUrl, this.imageWidth, this.imageHeight, this.isFavorite});

  void parseJson(var contents){
    this.id = contents['id'];
    this.imageUrl = contents['url'];
    this.imageWidth = int.parse(contents['width'].toString());
    this.imageHeight = int.parse(contents['height'].toString());
    this.isFavorite = false;
  }
}
