import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cat_test_app/managers/cash_manager.dart';
import 'package:cat_test_app/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

class CatsProvider extends ChangeNotifier {
  Directory _appDirectory;
  CashManagerImplementation _cashManager;

  Map<String, CatModel> _allCats;
  List<String> _facts = [];
  bool _haveAnInternet = true;
  bool _requestInProgress = false;
  final Uri _catsFactsUrl =
      Uri.https('catfact.ninja', '/facts', {'limit': '3', 'max_length': '200'});

  final Uri _catsImagesUrl =
      Uri.https('api.thecatapi.com', '/v1/images/search', {
    'size': 'med',
    // 'mime_types': 'png',
    'limit': '5',
    'x-api-key': '24a960cb-3320-46d8-b3ef-6fb42d5e2df9'
  });

  CatsProvider() {
    _factMock();
    _initCashFolder();
    _checkConnection();
    // _getFacts();
  }

  void _checkConnection() async {
    _haveAnInternet = false;
    try {
      _haveAnInternet = await InternetConnectionChecker().hasConnection;
    } on Exception {
      _haveAnInternet = false;
    }
    if(_haveAnInternet) _getCatsImages();
    notifyListeners();
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            _haveAnInternet = true;
            _getCatsImages();
            break;
          case InternetConnectionStatus.disconnected:
            _haveAnInternet = false;
            if(_cashManager != null) _applyCashedInfo();
            break;
        }
        notifyListeners();
      },
    );
  }

  String get noImagesText => _haveAnInternet ? 'No images' : 'No internet connection';

  Future<void> _getCatsImages() async {
    _allCats = new Map();
    _requestInProgress = true;
    Response res;
    try {
      res = await get(_catsImagesUrl);
    } catch (e) {
      print(e.toString());
    } finally{
      _requestInProgress = false;
    }

    if (res.statusCode == 200) {
      // print('cats status ----- ${jsonDecode(res.body)}');
      _cashManager.clearCash();
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
    if(_allCats != null)
      if(_allCats.isEmpty && _haveAnInternet && !_requestInProgress) _getCatsImages();
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

  //-------------------------- cash section-------------------------------

  void _initCashFolder() async{
    _appDirectory = await getApplicationDocumentsDirectory();
    _cashManager = CashManagerImplementation(cashFolderString: '${_appDirectory.path}/cash/');
    if(!_haveAnInternet) _applyCashedInfo();
  }

  CashManager get cashManager => _cashManager;

  void _applyCashedInfo(){
    _allCats = new Map();
    List<String> _all = _cashManager.getCashFiles();
    for(int i = 0; i < _all.length; i++){
      CatModel _cat = CatModel();
      _cat.imageUrl = _all[i];
      _cat.id = _cashManager.getFileNameFromUrl(_all[i]);
      _allCats.putIfAbsent(_cat.id, () => _cat);
    }
    notifyListeners();
  }

  bool isFileCashed(String url) => _cashManager.isFileCashed(url);

  void deleteCashedImages() {
    _cashManager.clearCash();
    _allCats = new Map();
  }

  int get savedImagesCount => _cashManager.cashedFilesCount;
}
