import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat_test_application/bloc/auth_bloc.dart';
import 'package:flutter_cat_test_application/provider/cats_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _user = context.read<AuthBloc>().currentUser;
    Provider.of<CatsProvider>(context).readCashedImages();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 140.0,
              height: 140.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Image.network(_user.photoURL),
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
            child: Card(
              color: Colors.white70,
              child: GestureDetector(
                onTap: () => context.read<AuthBloc>().add(LogOut()),
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
          ),
          ElevatedButton(
            onPressed: Provider.of<CatsProvider>(context, listen: false).savedImagesCount > 0
                ?() => Provider.of<CatsProvider>(context, listen: false).deleteCashedImages()
            : null,
            child: Text('Clear cash'),
          ),
        ],
      ),
    );
  }
}
