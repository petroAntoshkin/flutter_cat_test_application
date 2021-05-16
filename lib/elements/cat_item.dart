import 'package:cat_test_app/elements/photo_hero.dart';
import 'package:cat_test_app/managers/cash_manager.dart';
import 'package:cat_test_app/models/cat_model.dart';
import 'package:cat_test_app/pages/details_page.dart';
import 'package:cat_test_app/provider/cats_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    void _favCallback() {
      Provider.of<CatsProvider>(context, listen: false)
          .setFavorite(id, !_cat.isFavorite);
    }

    final _wid = MediaQuery.of(context).size.width * 0.9;
    final double _height = 200.0;
    final String fact =
        Provider.of<CatsProvider>(context, listen: false).randomFact;
    // String _filePath =
    //     Provider.of<CatsProvider>(context, listen: false).appDirectory +
    //         '/${_cat.id}.png';
    final CashManager _manager = Provider.of<CatsProvider>(context).cashManager;
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
                url: _cat.imageUrl,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(
                            cat: _cat,
                            callback: _favCallback,
                            fact: fact,
                            manager: _manager,
                          )));
                },
                manager: _manager,
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
