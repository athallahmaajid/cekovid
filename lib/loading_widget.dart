import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final callbackFunc;
  final param;
  LoadingWidget({Key? key, Function? this.callbackFunc, String? this.param}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    (param is String) ? this.callbackFunc(param) : this.callbackFunc();
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
