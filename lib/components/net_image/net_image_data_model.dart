part of 'net_image.dart';

class NetImageDataModel{
  NetImageDataModel({@required this.url, @required this.isCashed, @required this.file, @required this.callback});
  final String url;
  final bool isCashed;
  final File file;
  VoidCallback callback;
}