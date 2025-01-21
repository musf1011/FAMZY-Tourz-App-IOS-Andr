import 'package:fluttertoast/fluttertoast.dart';

class ToastPopUp {
  void toastPopUp(message, clr) {
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.BOTTOM_RIGHT,
        backgroundColor: clr);
  }
}
