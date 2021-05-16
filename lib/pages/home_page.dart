import 'package:cat_test_app/elements/my_app_title.dart';
import 'package:flutter/material.dart';

import 'cats_page.dart';
import 'profile_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        title: MyAppTitle(),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Cats',),
            Tab(text: 'Favorites',),
            Tab(text: 'Profile',),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CatsPage(favoritesOnly: false,),
          CatsPage(favoritesOnly: true,),
          ProfilePage(),
        ],
      ),
    );
   }
}