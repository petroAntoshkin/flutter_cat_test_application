import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cat_test_application/provider/cats_provider.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width, this.filePath})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  final String filePath;

  Widget build(BuildContext context) {
    final bool _netFlag = photo.contains('http');
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: _netFlag 
                ? Image(image:
            NetworkToFileImage(
                url: photo,
                file: File(filePath),
                debug: false),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: LinearProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            )
            : Image.file(File(photo)),
          ),
        ),
      ),
    );
  }
}
