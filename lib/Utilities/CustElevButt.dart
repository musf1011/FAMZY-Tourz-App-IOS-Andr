import 'package:famzy_tourz_app/contstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.transGColor,
        foregroundColor: Colors.white,
        minimumSize: Size(0.75.sw, .075.sh),
        textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.sp,
            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5)),
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: child,
    );
  }
}
