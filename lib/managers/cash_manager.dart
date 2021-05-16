import 'package:flutter/material.dart';
import 'dart:io';

abstract class UrlManipulator {
  String getFileNameFromUrl(String url);

  String getCashedFilePathFromUrl(String url);
}

abstract class CashManager extends UrlManipulator {
  bool isFileExist(String url);

  void addFileToCashList(String url);

  File getCashFileFromUrl(String url);

  bool isFileCashed(String url);
}

class CashManagerImplementation implements CashManager {
  final String cashFolderString;
  Directory _cashFolder;
  List<String> _cashedFiles;

  CashManagerImplementation({@required this.cashFolderString}) {
    _cashFolder = Directory(this.cashFolderString);
    if (!_cashFolder.existsSync())
      _cashFolder.create();
    else
      _readCash();
  }

  @override
  bool isFileExist(String url) {
    String _candidate = '${_cashFolder.path}${getFileNameFromUrl(url)}';
    for (int i = 0; i < _cashedFiles.length; i++) {
      if (_candidate == _cashedFiles[i]) return true;
    }
    return false;
  }

  @override
  String getFileNameFromUrl(String url) => url.split('/').last;

  @override
  String getCashedFilePathFromUrl(String url) =>
      '${_cashFolder.path}${getFileNameFromUrl(url)}';

  int get cashedFilesCount => _cashFolder.listSync().length;

  @override
  File getCashFileFromUrl(String url) => File(getCashedFilePathFromUrl(url));

  @override
  void addFileToCashList(String url) {
    String _path = getCashedFilePathFromUrl(url);
    _cashedFiles.add(_path);
  }

  List<String> getCashFiles() {
    List<String> _res = [];
    if (_cashedFiles != null)
      for (int i = 0; i < _cashedFiles.length; i++) _res.add(_cashedFiles[i]);
    return _res;
  }

  void clearCash() {
    _cashedFiles = [];
    List<FileSystemEntity> _list = _cashFolder.listSync();
    for (int i = 0; i < _list.length; i++) File(_list[i].path).delete();
  }

  void _readCash() {
    _cashedFiles = [];
    List<FileSystemEntity> _files = _cashFolder.listSync();
    for (int i = 0; i < _files.length; i++) _cashedFiles.add(_files[i].path);
  }

  @override
  bool isFileCashed(String url) => _cashedFiles.indexOf(url) >= 0;
}
