import 'package:famzy_tourz_app/UI/MainScreens/chatting/gemini_ai/gemini_model.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AiInsights extends StatefulWidget {
  final String destination;
  final String bgImage;
  const AiInsights(
      {super.key, required this.destination, required this.bgImage});

  @override
  State<AiInsights> createState() => _AiInsightsState();
}

class _AiInsightsState extends State<AiInsights> {
  final GeminiAIService _aiService = GeminiAIService();
  late Future<String> _overviewFuture;
  @override
  void initState() {
    super.initState();
    _overviewFuture = _getOverview();
  }

  Future<String> _getOverview() async {
    final prompt = widget.destination == 'Dir'
        ? "Give me local Insights for Upper ${widget.destination}, Pakistan. And few lines in each language of that region in a table."
        : "Give me local Insights for ${widget.destination}, Pakistan. And few lines in each language of that region in a table avoid greeting as it is same.";

    String rawResponse = await _aiService.generateResponse(prompt);
    String cleanedResponse = rawResponse.replaceAllMapped(
        RegExp(r'```(?:[\s\S]*?)```'), (match) => '');
    return cleanedResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: 1.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.bgImage),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(.02.sw, .02.sh, .02.sw, 0),
                  child: Row(
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
                      SizedBox(
                        width: .15.sw,
                      ),
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
                ),
                Text(
                  "${widget.destination} Insights",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 57, 2),
                    background: Paint()..color = Colors.white30,
                  ),
                ),
                FutureBuilder<String>(
                  future: _overviewFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitFadingCircle(
                          color: Colors.yellow, size: 70);
                    }
                    final response = snapshot.data ?? 'No Insights available';

                    return Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(150, 0, 30, 0),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: MarkdownBody(
                          data: response,
                          styleSheet: MarkdownStyleSheet(
                            p: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.5,
                            ),
                            strong: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            em: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            h2: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            h3: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            listBullet: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            blockquote: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            code: GoogleFonts.robotoMono(
                              fontSize: 14.sp,
                              color: const Color.fromARGB(150, 0, 30, 0),
                              backgroundColor: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: .5.sw,
                  child: CustomElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Exit'),
                          Icon(
                            Icons.exit_to_app_rounded,
                            size: 30.h,
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ))));
  }
}
