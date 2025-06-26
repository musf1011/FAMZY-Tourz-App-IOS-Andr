import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/passenger_info.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingScreen extends StatefulWidget {
  final String destination;
  final String bgImage;
  final Map<String, dynamic> packageDetails;

  const BookingScreen({
    super.key,
    required this.destination,
    required this.bgImage,
    required this.packageDetails,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int seatCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: .02.sh),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 40.h,
                      color: const Color.fromARGB(180, 0, 30, 0),
                    ),
                  ),
                  SizedBox(width: .15.sw),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                    child: Image.asset(
                      "asset/images/FAMZYLogo.png",
                      width: .4.sw,
                      height: .1.sh,
                    ),
                  ),
                ],
              ),
              Text(
                widget.destination,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 57, 2),
                    background: Paint()..color = Colors.white30),
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 0, 30, 0),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.packageDetails['packageName'] ?? 'Package Details',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    infoRow("📅 Date", widget.packageDetails['date']),
                    infoRow("⏰ Time", widget.packageDetails['time']),
                    infoRow("⛳ Duration", widget.packageDetails['duration']),
                    infoRow("📍 Key Spots", widget.packageDetails['keySpots']),
                    infoRow("🚗 Vehicle", widget.packageDetails['vehicle']),
                    SizedBox(height: 20.h),
                    Text(
                      "📝 Description",
                      style: GoogleFonts.roboto(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.packageDetails['description'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "📜 Terms & Conditions",
                      style: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "• Booking is confirmed after full payment.\n"
                      "• To cancel a booking, inform at least 48 hours in advance.\n"
                      "• 50% cancellation fee applies on confirmed bookings.\n"
                      "• No refund for cancellations within 48 hours of the tour.\n"
                      "• Refunds are processed within 5–7 business days.\n"
                      "• Famzy Tourz may cancel/reschedule tours due to unforeseen issues.\n"
                      "• You must follow all safety guidelines during the tour.",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 0.5.sw,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 0, 30, 0),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Seats:",
                        style: GoogleFonts.roboto(
                            fontSize: 18.sp, color: Colors.white)),
                    SizedBox(width: 10.w),
                    IconButton(
                      onPressed: () {
                        if (seatCount > 1) {
                          setState(() => seatCount--);
                        }
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.redAccent),
                    ),
                    Text('$seatCount',
                        style: GoogleFonts.roboto(
                            fontSize: 20.sp, color: Colors.white)),
                    IconButton(
                      onPressed: () {
                        if (seatCount < 5) {
                          setState(() => seatCount++);
                        }
                      },
                      icon: Icon(Icons.add_circle, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Price: ${widget.packageDetails['price'] * seatCount} PKR per person",
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  backgroundColor: Colors.white30,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(height: 30.h),
              CustomElevatedButton(
                child: Text("Get Tickets  🎫",
                    style: TextStyle(fontSize: 20.sp, color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PassengerInfoScreen(
                              destination: widget.destination,
                              bgImage: widget.bgImage,
                              // tourId: widget.packageDetails['tourId'],
                              seatCount: seatCount,
                              packageDetails: widget.packageDetails)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
