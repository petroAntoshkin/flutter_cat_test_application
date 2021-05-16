import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
part 'net_image_data_model.dart';

// ignore: must_be_immutable
class CashableNetworkImage extends StatelessWidget {

  CashableNetworkImage({@required this.model});
  final NetImageDataModel model;
  VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: model.isCashed
          ? Image.file(model.file)
          : Image(
        image: NetworkToFileImage(
            url: model.url,
            file: model.file,
            debug: false),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null)
            return child;
          else if (model.callback != null &&
              loadingProgress.cumulativeBytesLoaded ==
                  loadingProgress.expectedTotalBytes)
            model.callback();
          return Center(
            child: LinearProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}
