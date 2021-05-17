import 'package:cat_test_app/bloc/auth_bloc.dart';
// import 'package:cat_test_app/components/net_image/net_image.dart';
import 'package:cat_test_app/provider/cats_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _user = context.read<AuthBloc>().currentUser;
    final int _count = Provider.of<CatsProvider>(context).savedImagesCount;
    final bool _connection = Provider.of<CatsProvider>(context).haveAnInternet;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 120.0,
              height: 120.0,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),

                child: _connection
                    ? Image.network(
                    _user.photoURL,
                  fit: BoxFit.fill,
                )
                    : Center(
                        child: Text(
                          'No internet connection',
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _user.displayName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _user.email,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => context.read<AuthBloc>().add(LogOut()),
              child: Container(
                color: Color(0x00ff00ff),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.logout),
                      Text('Logout'),
                      Icon(Icons.logout),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _count > 0
                ? () {
                    Provider.of<CatsProvider>(context, listen: false)
                        .deleteCashedImages();
                    setState(() {});
                  }
                : null,
            child: Text('Clear cash'),
          ),
        ],
      ),
    );
  }
}
