import 'package:cat_test_app/elements/cat_item.dart';
import 'package:cat_test_app/models/cat_model.dart';
import 'package:cat_test_app/provider/cats_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatsPage extends StatelessWidget {
  CatsPage({@required this.favoritesOnly});

  final bool favoritesOnly;

  @override
  Widget build(BuildContext context) {
    Map<String, CatModel> _cats = favoritesOnly
        ? Provider.of<CatsProvider>(context, listen: false).favoriteCats
        : Provider.of<CatsProvider>(context, listen: false).allCats;
    List<String> keys = _cats.keys.toList();
    return Container(
      child: _cats.isNotEmpty
          ? ListView.builder(
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int index) => CatItem(
                id: _cats[keys[index]].id,
              ),
            )
          : Center(
              child: Center(
                child: Text(
                  Provider.of<CatsProvider>(context, listen: false)
                      .noImagesText,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
    );
  }
}
