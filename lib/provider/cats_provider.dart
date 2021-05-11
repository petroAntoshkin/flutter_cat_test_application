import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cat_test_application/models/cat_model.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';

class CatsProvider extends ChangeNotifier {
  Directory _appDirectory;
  List<String> _cashedImagesList;
  // final String _cashImagesJson = '/images.json';

  Map<String, CatModel> _allCats;
  List<String> _facts = [];
  bool _haveAnInternet = true;
  final Uri _catsFactsUrl =
      Uri.https('catfact.ninja', '/facts', {'limit': '3', 'max_length': '200'});

  final Uri _catsImagesUrl =
      Uri.https('api.thecatapi.com', '/v1/images/search', {
    'size': 'med',
    'mime_types': 'png',
    'limit': '5',
    'x-api-key': '24a960cb-3320-46d8-b3ef-6fb42d5e2df9'
  });

  CatsProvider() {
    _factMock();
    _checkConnection();
    // _getFacts();
  }

  void _checkConnection() async {
    _appDirectory = await getApplicationDocumentsDirectory();
    _applyCashedInfo();
    _haveAnInternet = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _haveAnInternet = false;
      _applyCashedInfo();
    } else {
      _getCatsImages();
    }
    readCashedImages();
    //print('internet connection is $_haveAnInternet');
  }

  String get noImagesText => _haveAnInternet ? 'No images' : 'No internet connection';

  Future<void> _getCatsImages() async {
    deleteCashedImages();
    _allCats = new Map();
    // _parseResponseJson(jsonDecode(_testMock));
    Response res;
    try {
      res = await get(_catsImagesUrl);
    } catch (e) {
      print(e.toString());
    }

    if (res.statusCode == 200) {
      // print('cats status ----- ${jsonDecode(res.body)}');
      _parseResponseJson(jsonDecode(res.body));
    } else {
      throw "Unable to retrieve posts.";
    }
    _getFacts();
    notifyListeners();
  }

  void _parseResponseJson(var data) {
    _allCats = new Map();
    int _len = (data as List).length;
    for (int i = 0; i < _len; i++) {
      CatModel _catCandidate = CatModel();
      _catCandidate.parseJson(data[i]);
      _allCats.putIfAbsent(_catCandidate.id, () => _catCandidate);
    }
  }

  Future<void> _getFacts() async {
    Response factRes;
    try {
      factRes = await get(_catsFactsUrl);
      // print(factRes.body);
    } catch (e) {
      print(e.toString());
    }
    _parseFacts(jsonDecode(factRes.body));
  }

  void _parseFacts(var data) {
    int _len = (data['data'] as List).length;
    if (_len > 0) {
      _facts = [];
      for (int i = 0; i < _len; i++) _facts.add(data['data'][i]['fact']);
    }
  }

  void _factMock() {
    _facts = [];
    _facts.add(
        'While many parts of Europe and North America consider the black cat a sign of bad luck, in Britain and Australia, black cats are considered lucky.');
    _facts.add(
        'When a cat chases its prey, it keeps its head level. Dogs and humans bob their heads up and down.');
  }

  Map<String, CatModel> get allCats {
    Map<String, CatModel> _res = new Map();
    if (_allCats != null)
      _allCats.forEach((key, value) {
        _res.putIfAbsent(key, () => value);
      });
    return _res;
  }

  Map<String, CatModel> get favoriteCats {
    Map<String, CatModel> _res = new Map();
    if (_allCats != null)
      _allCats.forEach((key, value) {
        if (value.isFavorite) _res.putIfAbsent(key, () => value);
      });
    return _res;
  }

  CatModel getCatByIndex(int index) {
    return _allCats[index];
  }

  CatModel getCatByID(String id) {
    return _allCats[id];
  }

  void setFavorite(String id, bool value) {
    _allCats[id].isFavorite = value;
  }

  String get randomFact => _facts.length > 1
        ? _facts[Random().nextInt(_facts.length)]
        : _facts[0];

  bool get haveAnInternet => _haveAnInternet;

  get appDirectory => _appDirectory.path;

  ///////////// cashed images

  void _applyCashedInfo(){
    _allCats = new Map();
    readCashedImages();
    if(_cashedImagesList.isNotEmpty){
      for(int i = 0; i < _cashedImagesList.length; i++){
        CatModel _cat = CatModel();
        _cat.imageUrl = _cashedImagesList[i];
        _cat.id = _cashedImagesList[i].split('/').last;
        _allCats.putIfAbsent(_cat.id, () => _cat);
      }
    }
  }

  void readCashedImages() {
    List<FileSystemEntity> _list = _appDirectory.listSync();
    _cashedImagesList = [];
    for(int i = 0; i < _list.length; i++){
      if(_list[i].path.contains(".png")) {
        // print('read from local directory: ${_list[i].path}');
        _cashedImagesList.add(_list[i].path);
      }
    }
  }

  void deleteCashedImages(){
    readCashedImages();
    for(int i = 0; i < _cashedImagesList.length; i++)
      File(_cashedImagesList[i]).delete();
    _cashedImagesList = [];
    notifyListeners();
  }

  int get savedImagesCount => _cashedImagesList.length;
}
