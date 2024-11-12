import 'package:flutter/material.dart';

import '/design/components/components.dart';
import '/utils/utils.dart';

class Unknown404View extends StatelessWidget {
  const Unknown404View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPrimaryColor,
      body: Center(
        child: CText(
          '404',
          style: TextThemeX.text18.copyWith(color: getColorWhiteBlack),
        ),
      ),
    );
  }
}
