import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cat_test_application/elements/photo_hero.dart';
import 'package:flutter_cat_test_application/models/cat_model.dart';
import 'package:flutter_cat_test_application/pages/details_page.dart';
import 'package:flutter_cat_test_application/provider/cats_provider.dart';
import 'package:provider/provider.dart';

class CatItem extends StatelessWidget {
  CatItem({@required this.id});
  final String id;
//   @override
//   _CatItemState createState() => _CatItemState();
//
// }
//
// class _CatItemState extends State<CatItem> {
  @override
  Widget build(BuildContext context) {
    CatModel _cat = Provider.of<CatsProvider>(context).getCatByID(id);
    void _favCallback(){
      Provider.of<CatsProvider>(context,listen: false).setFavorite(id, !_cat.isFavorite);
    }
    final _wid = MediaQuery.of(context).size.width * 0.9;
    final double _height = 200.0;
    final String photo = _cat.imageUrl;
    final String fact = Provider.of<CatsProvider>(context,listen: false).randomFact;
    String _filePath = Provider.of<CatsProvider>(context, listen: false).appDirectory + '/${_cat.id}.png';
    return Card(
      color: Colors.grey,
      child: SizedBox(
        width: _wid,
        height: _height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: PhotoHero(
                photo: _cat.imageUrl,
                width: _wid,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(cat: _cat, callback: _favCallback, fact: fact, filePath: _filePath,)));
                },
                filePath: _filePath,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                      child: Icon(
                          _cat.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _cat.isFavorite ? Colors.deepOrange : Colors.grey,
                      ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
