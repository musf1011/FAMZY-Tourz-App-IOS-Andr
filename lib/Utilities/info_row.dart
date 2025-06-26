// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// Widget _infoRow(String label, String? value) {
//   return Padding(
//     padding: EdgeInsets.only(bottom: 8.h),
//     child: Row(
//       children: [
//         Text(
//           "$label: ",
//           style: GoogleFonts.roboto(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.white70,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value ?? 'N/A',
//             style: GoogleFonts.roboto(
//               fontSize: 16.sp,
//               color: Colors.white.withOpacity(0.9),
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable row widget for displaying labeled info (e.g. key-value pairs).
Widget infoRow(String label, String? value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.yellow,
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
