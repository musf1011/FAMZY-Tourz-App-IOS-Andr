import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget profileImage({required String profilePic, required double size}) {
  return profilePic.isNotEmpty
      ? ClipOval(
          child: Image.network(
            profilePic,
            fit: BoxFit.cover,
            width: size.r,
            height: size.r,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.error,
                size: size * 0.48.sp,
                color: Colors.red,
              );
            },
          ),
        )
      : Icon(
          Icons.person_4,
          size: size * 0.48.sp,
          color: Colors.grey,
        );
}
