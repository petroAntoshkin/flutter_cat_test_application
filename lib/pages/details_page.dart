import 'package:flutter/material.dart';
import 'package:flutter_cat_test_application/elements/photo_hero.dart';
import 'package:flutter_cat_test_application/models/cat_model.dart';
import 'package:flutter_cat_test_application/provider/cats_provider.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {@required this.cat, @required this.callback, @required this.fact, @required this.filePath});

  final CatModel cat;
  final String fact;
  final VoidCallback callback;
  final String filePath;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Details')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              PhotoHero(
                photo: widget.cat.imageUrl,
                width: MediaQuery.of(context).size.width * 0.8,
                onTap: () => Navigator.of(context).pop(),
                filePath: widget.filePath,
              ),
              Text(widget.fact),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50.0,
        width: Size.infinite.width,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
          child: Row(
            children: [
              SizedBox(width: 60),
              Expanded(
                  child: Container(child: Center(child: Text(widget.cat.id)))),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Tooltip(
                  message: widget.cat.isFavorite
                      ? 'remove from favorite'
                      : 'add to favourite',
                  child: SizedBox(
                    width: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.callback();
                        setState(() {});
                      },
                      child: Center(
                        child: Icon(
                          widget.cat.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.cat.isFavorite
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
