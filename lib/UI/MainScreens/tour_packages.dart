import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/ai_insights.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages/package_screen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TourPackages extends StatelessWidget {
  TourPackages({super.key});

  final List imagesList = [
    'asset/images/River_Swat.jpg',
    'asset/images/met1.jpeg',
    'asset/images/met2.jpeg',
    'asset/images/met3.jpeg',
    'asset/images/met4.jpeg',
  ];
  final List destinations = ['Swat', 'Naran', 'Kaghan', 'Dir', 'Chitral'];
  final List destDetails = [
    '  Swat: Known as the "Switzerland of the\n  East," Swat is famous for itslush valleys,\n  cultural heritage, and crystal-clear rivers.',
    '  Naran: Nestled in the Kaghan Valley,\n  Naran is a scenic town renowned for\n  its stunning alpine meadows and Lake\n  Saif-ul-Malook',
    '  Kaghan: This picturesque valley \n  offers  breathtaking views, trekking\n  opportunities,  and vibrant flora and\n  fauna.',
    '  Dir: A hidden gem of the north, Dir\n  boasts serene landscapes, historical\n  forts, and captivating mountain trails.',
    '  Chitral: Home to the Kalash Valley,\n  Chitral is known for its unique culture,\n  majestic peaks, and the annual\n  Shandur Polo Festival.'
  ];
  final List Latitude = [
    35.2227,
    34.9093,
    34.7794,
    35.2012,
    35.8540,
  ];
  final List Longitude = [
    72.4258,
    73.6507,
    73.5270,
    71.8755,
    71.7866,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 5,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imagesList[index]), fit: BoxFit.cover)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      destDetails[index],
                      style: TextStyle(
                          fontSize: 16.sp,
                          backgroundColor: Color.fromARGB(150, 0, 30, 0)),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    SizedBox(
                      width: 0.6.sw,
                      height: .085.sh,
                      child: CustomElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              destinations[index],
                              style:
                                  GoogleFonts.playfairDisplay(fontSize: 35.sp),
                            ),
                            Icon(
                              Icons.double_arrow_sharp,
                              size: 30.h,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PackageScreen(
                                        latitude: Latitude[index],
                                        longitude: Longitude[index],
                                        bgImage: imagesList[index],
                                        destination: destinations[index],
                                      )));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    SizedBox(
                      height: 0.05.sh,
                      width: 0.35.sw,
                      child: CustomElevatedButton(
                          child: Text('AI Insights',
                              style: TextStyle(fontSize: 14.sp)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AiInsights(
                                  destination: destinations[index],
                                  bgImage: imagesList[index],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.1.sh, right: 0.05.sw),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        5,
                        (indexDots) => Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          height: index == indexDots ? 25.h : 7.h,
                          width: 7.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Color.fromARGB(255, 0, 57, 2),
                              color: index != indexDots
                                  ? Color.fromARGB(150, 0, 100, 0)
                                  : Color.fromARGB(255, 0, 57, 2)),
                        ),
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
