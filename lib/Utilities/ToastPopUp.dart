import 'package:fluttertoast/fluttertoast.dart';

class ToastPopUp {
  void toastPopUp(message, clr) {
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 30,
        gravity: ToastGravity.BOTTOM_RIGHT,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: clr);
  }
}
