import 'package:flutter/material.dart';
import 'package:flutter_cat_test_application/pages/cats_page.dart';
import 'package:flutter_cat_test_application/pages/details_page.dart';
import 'package:flutter_cat_test_application/pages/profile_page.dart';
import 'package:flutter_cat_test_application/provider/cats_provider.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => CatsProvider(),
      child: Consumer<CatsProvider>(
          builder: (context, CatsProvider notifier, child) {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Flutter Cat Test App')),
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
          }),
    );
  }
}