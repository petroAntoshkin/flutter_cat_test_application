import 'package:cat_test_app/components/net_image/net_image.dart';
import 'package:cat_test_app/managers/cash_manager.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.url, this.onTap, this.manager})
      : super(key: key);

  final String url;
  final VoidCallback onTap;
  final CashManager manager;

  Widget build(BuildContext context) {
    final bool _isCashed = manager.isFileCashed(url);
    void _callback() {
      manager.addFileToCashList(url);
    }

    return Hero(
      tag: url,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: CashableNetworkImage(
            model: NetImageDataModel(
              url: url,
              isCashed: _isCashed,
              file: manager.getCashFileFromUrl(url),
              callback: _callback,
            ),
          ),
        ),
      ),
    );
  }
}
