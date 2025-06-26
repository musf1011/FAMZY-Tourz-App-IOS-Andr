// // Created by: Famzy Tourz
// import 'package:famzy_tourz_app/UI/MainScreens/tour_packages.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/admin_add_package.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/ai_insights.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/weather_api/open_meteo_model.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/weather_api/weather_services.dart';
// import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:famzy_tourz_app/UI/MainScreens/chatting/gemini_ai/gemini_model.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class PackageScreen extends StatefulWidget {
//   final String destination;
//   final String bgImage;
//   final double latitude;
//   final double longitude;

//   const PackageScreen({
//     super.key,
//     required this.destination,
//     required this.bgImage,
//     required this.latitude,
//     required this.longitude,
//   });

//   @override
//   State<PackageScreen> createState() => _PackageScreenState();
// }

// class _PackageScreenState extends State<PackageScreen> {
//   final GeminiAIService _aiService = GeminiAIService();
//   final OpenMeteoService _weatherService = OpenMeteoService();

//   late Future<String> _overviewFuture;
//   late Future<WeatherData> _weatherFuture;
//   DateTime now = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _overviewFuture = _getOverview();
//     _weatherFuture =
//         _weatherService.getWeather(widget.latitude, widget.longitude);
//   }

//   Future<String> _getOverview() async {
//     final prompt =
//         "Give me a two-line overview for tourists about ${widget.destination}";
//     return await _aiService.generateResponse(prompt);
//   }

//   Widget _buildWeatherInfo(WeatherData weather) {
//     final currentHour = DateTime.now().hour;
//     String formattedDate = DateFormat('MMMM d, yyyy').format(now);
//     return Column(
//       children: [
//         _WeatherRow(
//           icon: Icons.thermostat,
//           value: '${weather.hourly.temperature[currentHour].round()}°C',
//           label: 'Temperature',
//         ),
//         _WeatherRow(
//           icon: Icons.water_drop,
//           value: '${weather.hourly.rain[currentHour]} mm',
//           label: 'Precipitation',
//         ),
//         _WeatherRow(
//           icon: Icons.light_mode,
//           value: 'UV ${weather.hourly.uvIndex[currentHour].round()}',
//           label: 'Index',
//         ),
//         _WeatherRow(
//           icon: Icons.wb_sunny,
//           value: 'Sunrise: ${weather.daily.sunrise[0].substring(11)}',
//           label: formattedDate,
//         ),
//         _WeatherRow(
//           icon: Icons.wb_twilight,
//           value: 'Sunset: ${weather.daily.sunset[0].substring(11)}',
//           label: formattedDate,
//         ),
//       ],
//     );
//   }

// // Map Section
// // This widget displays a Google Map with a marker at the specified latitude and longitude.
//   // Widget _buildMapSection() {
//   //   return Container(
//   //     height: 250.h,
//   //     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(15),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.3),
//   //           blurRadius: 10,
//   //           spreadRadius: 2,
//   //         ),
//   //       ],
//   //     ),
//   //     child: ClipRRect(
//   //       borderRadius: BorderRadius.circular(15),
//   //       child: GoogleMap(
//   //         initialCameraPosition: CameraPosition(
//   //           target: LatLng(widget.latitude, widget.longitude),
//   //           zoom: 12,
//   //         ),
//   //         markers: {
//   //           Marker(
//   //             markerId: MarkerId(widget.destination),
//   //             position: LatLng(widget.latitude, widget.longitude),
//   //             infoWindow: InfoWindow(title: widget.destination),
//   //           ),
//   //         },
//   //         mapType: MapType.terrain,
//   //         myLocationEnabled: true,
//   //         zoomControlsEnabled: false,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // _buildMapSection(),

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(widget.bgImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(.02.sw, .02.sh, .02.sw, 0),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => TourPackages()));
//                       },
//                       child: Icon(
//                         Icons.arrow_circle_left_outlined,
//                         size: 40.h,
//                         color: const Color.fromARGB(180, 0, 30, 0),
//                       ),
//                     ),
//                     const Spacer(),
//                     //Add package buton for admin only
//                     if (FirebaseAuth.instance.currentUser?.email ==
//                         "famzytourz@gmail.com")
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AdminAddPackage(
//                                 destination: widget.destination,
//                                 bgImage: widget.bgImage,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Icon(Icons.add_circle_outline,
//                             size: 40.h,
//                             color: const Color.fromARGB(180, 0, 30, 0)),
//                       )
//                   ],
//                 ),
//               ),
// Text(
//   widget.destination,
//   textAlign: TextAlign.center,
//   style: GoogleFonts.playfairDisplay(
//     fontSize: 40.sp,
//     fontWeight: FontWeight.bold,
//     color: Color.fromARGB(255, 0, 57, 2),
//     background: Paint()..color = Colors.white30,
//   ),
// ),
//               // AI Overview
//               FutureBuilder<String>(
//                 future: _overviewFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator(color: Colors.white);
//                   }
//                   return Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Text(
//                       snapshot.data ?? 'No overview available',
//                       style: GoogleFonts.poppins(
//                         // Try: .nunito, .openSans, .roboto
//                         fontSize: 16.sp,
//                         color: Colors.white.withOpacity(0.9),
//                         fontWeight: FontWeight.w400,
//                         height: 1.4,
//                         backgroundColor: const Color.fromARGB(150, 0, 30, 0),
//                         shadows: [
//                           Shadow(
//                             color: Colors.black54,
//                             blurRadius: 4,
//                             offset: Offset(3, 3),
//                           )
//                         ],
//                       ),
//                       textAlign: TextAlign.justify,
//                     ),
//                   );
//                 },
//               ),
//               Text(
//                 'Weather Update',
//                 style: GoogleFonts.roboto(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white.withOpacity(0.9),
//                   backgroundColor: const Color.fromARGB(150, 0, 30, 0),
//                 ),
//               ),
//               // Weather Information
//               FutureBuilder<WeatherData>(
//                 future: _weatherFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator(color: Colors.white);
//                   }
//                   if (snapshot.hasError) {
//                     return Text('Weather data unavailable',
//                         style: TextStyle(color: Colors.white));
//                   }
//                   return Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Container(
//                       padding: EdgeInsets.all(16.w),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           // color: Colors.black.withOpacity(0.5),
//                           color: const Color.fromARGB(150, 0, 30, 0)),
//                       child: _buildWeatherInfo(snapshot.data!),
//                     ),
//                   );
//                 },
//               ),

//               Text(
//                 'Local Insights\n',
//                 style: GoogleFonts.roboto(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white.withOpacity(0.9),
//                   backgroundColor: const Color.fromARGB(150, 0, 30, 0),
//                 ),
//               ),
//               CustomElevatedButton(
//                   child: Text('AI Insights'),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AiInsights(
//                           destination: widget.destination,
//                           bgImage: widget.bgImage,
//                         ),
//                       ),
//                     );
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _WeatherRow extends StatelessWidget {
//   final IconData icon;
//   final String value;
//   final String label;

//   const _WeatherRow({
//     required this.icon,
//     required this.value,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: Colors.white, size: 24.sp),
//           SizedBox(width: 10.w),
//           Text(value,
//               style: TextStyle(
//                   fontSize: 18.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500)),
//           SizedBox(width: 10.w),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.white70,
//                   fontStyle: FontStyle.italic)),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/admin_add_package.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/ai_insights.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/booking_screen.dart';
import 'package:famzy_tourz_app/UI/MainScreens/weather_api/open_meteo_model.dart';
import 'package:famzy_tourz_app/UI/MainScreens/weather_api/weather_services.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/info_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famzy_tourz_app/UI/MainScreens/chatting/gemini_ai/gemini_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class PackageScreen extends StatefulWidget {
  final String destination;
  final String bgImage;
  final double latitude;
  final double longitude;

  const PackageScreen({
    super.key,
    required this.destination,
    required this.bgImage,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  final GeminiAIService _aiService = GeminiAIService();
  final OpenMeteoService _weatherService = OpenMeteoService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<String> _overviewFuture;
  late Future<WeatherData> _weatherFuture;
  late Future<List<Map<String, dynamic>>> _packagesFuture;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _overviewFuture = _getOverview();
    _weatherFuture =
        _weatherService.getWeather(widget.latitude, widget.longitude);
    _packagesFuture = _fetchPackages();
  }

  Future<String> _getOverview() async {
    final prompt =
        "Give me a two-line overview for tourists about ${widget.destination}";
    return await _aiService.generateResponse(prompt);
  }

  Future<List<Map<String, dynamic>>> _fetchPackages() async {
    final snapshot = await _firestore.collection('packages').get();
    return snapshot.docs
        .where((doc) => doc['tourID']
            .toString()
            .toLowerCase()
            .contains(widget.destination.toLowerCase().replaceAll(' ', '')))
        .map((doc) => doc.data())
        .toList();
  }

  Widget _buildPackageCard(Map<String, dynamic> data) {
    final isAdmin =
        FirebaseAuth.instance.currentUser?.email == "famzytourz@gmail.com";

    return Card(
      color: Color.fromARGB(150, 0, 30, 0),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      borderOnForeground: true,
      elevation: 100,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: Colors.white, width: 1)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['packageName'] ?? '',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 5.h),
            infoRow("⛳ Duration", data['duration']),
            infoRow("📅  Date", data['date']),
            infoRow("⏰ Time", data['time']),
            infoRow("📍Key Spots", data['keySpots']),
            infoRow("🚗 Vehicle", data['vehicle']),
            Text("Description",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 8.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final fullText = data['description'] ?? '';
                final textSpan = TextSpan(
                  text: ' s$fullText',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                );
                final tp = TextPainter(
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  textDirection: Directionality.of(context),
                  text: textSpan,
                );

                tp.layout(maxWidth: constraints.maxWidth);
                final didOverflow = tp.didExceedMaxLines;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                    if (didOverflow)
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                destination: widget.destination,
                                bgImage: widget.bgImage,
                                packageDetails: data,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'See more',
                          style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 8.h),
            CustomElevatedButton(
                child: Text("${data['price']} PKR per Person",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        destination: widget.destination,
                        bgImage: widget.bgImage,
                        packageDetails: data,
                      ),
                    ),
                  );
                }),
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAddPackage(
                            destination: widget.destination,
                            bgImage: widget.bgImage,
                            tourID: data['tourID'],
                            existingData: data,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: const Color.fromARGB(150, 0, 30, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(color: Colors.white, width: 1),
                          ),
                          title: Text("Delete Package",
                              style: TextStyle(color: Colors.yellow)),
                          content: Text(
                            "Are you sure you want to delete this package?",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.green),
                                )),
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await _firestore
                            .collection('packages')
                            .doc(data['tourID'])
                            .delete();
                        _packagesFuture = _fetchPackages();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Package deleted")));
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(WeatherData weather) {
    final currentHour = DateTime.now().hour;
    String formattedDate = DateFormat('MMMM d, yyyy').format(now);
    return Column(
      children: [
        _WeatherRow(
            icon: Icons.thermostat,
            value: '${weather.hourly.temperature[currentHour].round()}°C',
            label: 'Temperature'),
        _WeatherRow(
            icon: Icons.water_drop,
            value: '${weather.hourly.rain[currentHour]} mm',
            label: 'Precipitation'),
        _WeatherRow(
            icon: Icons.light_mode,
            value: 'UV ${weather.hourly.uvIndex[currentHour].round()}',
            label: 'Index'),
        _WeatherRow(
            icon: Icons.wb_sunny,
            value: 'Sunrise: ${weather.daily.sunrise[0].substring(11)}',
            label: formattedDate),
        _WeatherRow(
            icon: Icons.wb_twilight,
            value: 'Sunset: ${weather.daily.sunset[0].substring(11)}',
            label: formattedDate),
      ],
    );
  }

// // Map Section
// // This widget displays a Google Map with a marker at the specified latitude and longitude.
//   Widget _buildMapSection() {
//     return Container(
//       height: 550.h,
//       // margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15),
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(widget.latitude, widget.longitude),
//             zoom: 12,
//           ),
//           markers: {
//             Marker(
//               markerId: MarkerId(widget.destination),
//               position: LatLng(widget.latitude, widget.longitude),
//               infoWindow: InfoWindow(title: widget.destination),
//             ),
//           },
//           mapType: MapType.terrain,
//           myLocationEnabled: false,
//           zoomControlsEnabled: false,
//         ),
//       ),
//     );
//   }

  Widget _buildMapSection() {
    return Container(
      height: 400.h, // Fixed height for proper layout
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 12,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.destination),
              position: LatLng(widget.latitude, widget.longitude),
              infoWindow: InfoWindow(title: widget.destination),
            ),
          },
          mapType: MapType.terrain,
          zoomControlsEnabled: true,
          myLocationEnabled: false, // Disabled unless you're using location
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.bgImage), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_circle_left_outlined,
                      size: 40.h, color: const Color.fromARGB(180, 0, 30, 0)),
                ),
                const Spacer(),
                if (FirebaseAuth.instance.currentUser?.email ==
                    "famzytourz@gmail.com")
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAddPackage(
                            destination: widget.destination,
                            bgImage: widget.bgImage,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.add_circle_outline,
                        size: 40.h, color: const Color.fromARGB(180, 0, 30, 0)),
                  )
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

            // AI Overview
            FutureBuilder<String>(
              future: _overviewFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(color: Colors.yellow, size: 70);
                }
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    snapshot.data ?? 'No overview available',
                    style: GoogleFonts.poppins(
                      // Try: .nunito, .openSans, .roboto
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      backgroundColor: const Color.fromARGB(150, 0, 30, 0),
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(3, 3),
                        )
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                );
              },
            ),
            CustomElevatedButton(
              child: Text('See AI Insights'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AiInsights(
                      destination: widget.destination,
                      bgImage: widget.bgImage,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),

            // Insert TabController here
            SizedBox(
              height: 0.88.sh, // Ensures bounded height for TabBarView
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.yellow,
                      labelColor: Colors.lightBlueAccent,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          child: Text(
                            'Weather/Map',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              backgroundColor:
                                  const Color.fromARGB(150, 0, 30, 0),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Packages',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              backgroundColor:
                                  const Color.fromARGB(150, 0, 30, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab 1: Weather & Map
                          SingleChildScrollView(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                Text(
                                  'Weather Update\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                    backgroundColor:
                                        const Color.fromARGB(150, 0, 30, 0),
                                  ),
                                ),
                                FutureBuilder<WeatherData>(
                                  future: _weatherFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SpinKitFadingCircle(
                                          color: Colors.yellow, size: 70);
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Weather data unavailable',
                                          style:
                                              TextStyle(color: Colors.white));
                                    }
                                    return Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            const Color.fromARGB(150, 0, 30, 0),
                                      ),
                                      child: _buildWeatherInfo(snapshot.data!),
                                    );
                                  },
                                ),
                                Text(
                                  '\nGoogle Map\n',
                                  style: GoogleFonts.roboto(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                    backgroundColor:
                                        const Color.fromARGB(150, 0, 30, 0),
                                  ),
                                ),
                                _buildMapSection(),
                                SizedBox(height: 5.h),
                              ],
                            ),
                          ),

                          // Tab 2: Tour Packages
                          SingleChildScrollView(
                            // padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                Text(
                                  'Tour Packages',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                    backgroundColor:
                                        const Color.fromARGB(150, 0, 30, 0),
                                  ),
                                ),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: _packagesFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SpinKitFadingCircle(
                                          color: Colors.yellow, size: 70);
                                    }
                                    if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.all(20.h),
                                        child: Text("No packages found.",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    }
                                    return Column(
                                      children: snapshot.data!
                                          .map(
                                              (data) => _buildPackageCard(data))
                                          .toList(),
                                    );
                                  },
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )

            //  Column(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.fromLTRB(.02.sw, .02.sh, .02.sw, 0),
            //       child:
            // Row(
            //         children: [
            //           GestureDetector(
            //             onTap: () => Navigator.pop(context),
            //             child: Icon(Icons.arrow_circle_left_outlined,
            //                 size: 40.h,
            //                 color: const Color.fromARGB(180, 0, 30, 0)),
            //           ),
            //           const Spacer(),
            //           if (FirebaseAuth.instance.currentUser?.email ==
            //               "famzytourz@gmail.com")
            //             GestureDetector(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => AdminAddPackage(
            //                       destination: widget.destination,
            //                       bgImage: widget.bgImage,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child: Icon(Icons.add_circle_outline,
            //                   size: 40.h,
            //                   color: const Color.fromARGB(180, 0, 30, 0)),
            //             )
            //         ],
            //       ),
            //     ),
            //     Text(
            //       widget.destination,
            //       style: GoogleFonts.playfairDisplay(
            //           fontSize: 40.sp,
            //           fontWeight: FontWeight.bold,
            //           color: Color.fromARGB(255, 0, 57, 2),
            //           background: Paint()..color = Colors.white30),
            //     ),

            //     // AI Overview
            //     FutureBuilder<String>(
            //       future: _overviewFuture,
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return SpinKitFadingCircle(color: Colors.yellow, size: 70);
            //         }
            //         return Padding(
            //           padding: EdgeInsets.all(16.w),
            //           child: Text(
            //             snapshot.data ?? 'No overview available',
            //             style: GoogleFonts.poppins(
            //               // Try: .nunito, .openSans, .roboto
            //               fontSize: 16.sp,
            //               color: Colors.white.withOpacity(0.9),
            //               fontWeight: FontWeight.w400,
            //               height: 1.4,
            //               backgroundColor: const Color.fromARGB(150, 0, 30, 0),
            //               shadows: [
            //                 Shadow(
            //                   color: Colors.black54,
            //                   blurRadius: 4,
            //                   offset: Offset(3, 3),
            //                 )
            //               ],
            //             ),
            //             textAlign: TextAlign.justify,
            //           ),
            //         );
            //       },
            //     ),

            //     CustomElevatedButton(
            //       child: Text('See AI Insights'),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => AiInsights(
            //               destination: widget.destination,
            //               bgImage: widget.bgImage,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //     SizedBox(height: 20.h),
            //     //I want that weather update and google map in one tab and tour package in second tab
            //     //tab 1 named 'Weather/Map'
            //     Text(
            //       'Weather Update',
            //       style: GoogleFonts.roboto(
            //         fontSize: 20.sp,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white.withOpacity(0.9),
            //         backgroundColor: const Color.fromARGB(150, 0, 30, 0),
            //       ),
            //     ),
            //     FutureBuilder<WeatherData>(
            //       future: _weatherFuture,
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return SpinKitFadingCircle(color: Colors.yellow, size: 70);
            //         }
            //         if (snapshot.hasError) {
            //           return Text('Weather data unavailable',
            //               style: TextStyle(color: Colors.white));
            //         }
            //         return Padding(
            //           padding: EdgeInsets.all(16.w),
            //           child: Container(
            //             padding: EdgeInsets.all(16.w),
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(50),
            //                 color: const Color.fromARGB(150, 0, 30, 0)),
            //             child: _buildWeatherInfo(snapshot.data!),
            //           ),
            //         );
            //       },
            //     ),
            //     _buildMapSection(),
            //     SizedBox(height: 20.h),
            //     // tab2 named 'Packages'
            // Text(
            //   'Tour Packages',
            //   style: GoogleFonts.roboto(
            //     fontSize: 20.sp,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white.withOpacity(0.9),
            //     backgroundColor: const Color.fromARGB(150, 0, 30, 0),
            //   ),
            // ),
            // FutureBuilder<List<Map<String, dynamic>>>(
            //   future: _packagesFuture,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return SpinKitFadingCircle(color: Colors.yellow, size: 70);
            //     }
            //     if (snapshot.hasError ||
            //         !snapshot.hasData ||
            //         snapshot.data!.isEmpty) {
            //       return Padding(
            //         padding: EdgeInsets.all(20.h),
            //         child: Text("No packages found.",
            //             style: TextStyle(color: Colors.white)),
            //       );
            //     }
            //     return Column(
            //       children: snapshot.data!
            //           .map((data) => _buildPackageCard(data))
            //           .toList(),
            //     );
            //   },
            // ),

            // SizedBox(height: 30.h),
            //   ],
            // ),
            ),
      ),
    );
  }
}

class _WeatherRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WeatherRow(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(width: 10.w),
          Text(value,
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
          SizedBox(width: 10.w),
          Text(label,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
