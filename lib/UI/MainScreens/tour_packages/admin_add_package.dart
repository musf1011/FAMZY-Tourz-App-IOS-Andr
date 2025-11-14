import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/tour_packages.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/contstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AdminAddPackage extends StatefulWidget {
  final String destination;
  final String bgImage;
  final String? tourID;
  final Map<String, dynamic>? existingData;

  const AdminAddPackage({
    super.key,
    required this.destination,
    required this.bgImage,
    this.tourID,
    this.existingData,
  });

  @override
  State<AdminAddPackage> createState() => _AdminAddPackageState();
}

class _AdminAddPackageState extends State<AdminAddPackage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? packageName,
      duration,
      date,
      time,
      keySpots,
      vehicle,
      description,
      price;
  bool isLoading = false;
  bool showSuccessAnimation = false;
  bool showErrorAnimation = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      packageName = widget.existingData!['packageName'];
      duration = widget.existingData!['duration'];
      date = widget.existingData!['date'];
      time = widget.existingData!['time'];
      keySpots = widget.existingData!['keySpots'];
      vehicle = widget.existingData!['vehicle'];
      description = widget.existingData!['description'];
      price = widget.existingData!['price'];
    }
  }

  String generateTourId(String packageName, String destination) {
    final cleanedPackageName = packageName.toLowerCase().replaceAll(' ', '');
    final cleanedDestination = destination.toLowerCase().replaceAll(' ', '');
    final currentDate = DateFormat('MMddyyyy').format(DateTime.now());
    return '${cleanedPackageName}_${cleanedDestination}_$currentDate';
  }

  void _clearFields() {
    setState(() {
      packageName = null;
      duration = null;
      date = null;
      time = null;
      keySpots = null;
      vehicle = null;
      description = null;
      price = null;
    });
    _formKey.currentState?.reset();
  }

  Future<bool> _onWillPop() async {
    bool leave = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(150, 0, 30, 0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: const Text('Discard Changes?',
            style: TextStyle(color: Colors.yellow)),
        content: const Text(
          'Do you want to exit without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Editing',
                style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              _clearFields();
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TourPackages()));
              leave = true;
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return leave;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await _onWillPop();
        }
      },
      child: Stack(children: [
        Scaffold(
          body: Container(
            height: 1.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.bgImage), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(.02.sw, .02.sh, .02.sw, 0.03.sh),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final shouldLeave = await _onWillPop();
                          if (shouldLeave) {
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 40.h,
                          color: const Color.fromARGB(180, 0, 30, 0),
                        ),
                      ),
                      SizedBox(width: .12.sw),
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
                  SizedBox(height: 10.h),
                  Text(
                    widget.existingData != null
                        ? "Edit Tour Package\nto ${widget.destination}"
                        : "Add Tour Package\nto ${widget.destination}",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 57, 2),
                      background: Paint()..color = Colors.white30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(150, 0, 30, 0),
                      ),
                      child: Column(
                        children: [
                          CustTextFormField(
                            label: "Package Name",
                            hint: "Swat Valley Adventure",
                            initialValue: packageName,
                            onChanged: (val) =>
                                setState(() => packageName = val),
                            onSaved: (val) => packageName = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter package name"
                                : null,
                          ),
                          if (packageName != null && packageName!.isNotEmpty)
                            Text(
                              'Tour ID: ${widget.tourID ?? generateTourId(packageName!, widget.destination)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(150, 0, 30, 0),
                              ),
                            ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Duration",
                            hint: "5 days / 4 nights",
                            initialValue: duration,
                            onSaved: (val) => duration = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter duration"
                                : null,
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Date",
                            hint: "YYYY-MM-DD",
                            initialValue: date,
                            readOnly: true,
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2050),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Color(
                                            0xFFB6921D), // Header background color
                                        onPrimary:
                                            Colors.white, // Header text color
                                        surface: Color(
                                            0xFF1F1F1F), // Background color
                                        onSurface: Colors.white, // Text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return Color(
                                                  0xFFB6921D); // OK when pressed
                                            }
                                            return null;
                                          }),
                                        ),
                                      ),
                                      datePickerTheme: DatePickerThemeData(
                                        backgroundColor:
                                            const Color.fromARGB(150, 0, 30, 0),
                                        headerForegroundColor: Colors.blue,
                                        dayForegroundColor:
                                            WidgetStateColor.resolveWith(
                                                (states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors.white;
                                          }
                                          return Colors.white;
                                        }),
                                        dayBackgroundColor:
                                            WidgetStateColor.resolveWith(
                                                (states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Color(0xFFB6921D);
                                          }
                                          return Colors.transparent;
                                        }),
                                        yearForegroundColor:
                                            WidgetStateColor.resolveWith(
                                                (states) {
                                          return Colors.white;
                                        }),
                                        confirmButtonStyle:
                                            TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.green, // OK button
                                        ),
                                        cancelButtonStyle: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.red, // Cancel button
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  date = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                });
                              }
                            },
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter date"
                                : null,
                            controller: TextEditingController(text: date),
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Time",
                            hint: "10:00 AM",
                            initialValue: time,
                            readOnly: true,
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Colors.blue,
                                        onPrimary: Colors.black,
                                        surface: Color(0xFF1F1F1F),
                                        onSurface: Colors.white,
                                      ),
                                      timePickerTheme: TimePickerThemeData(
                                        cancelButtonStyle: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        confirmButtonStyle:
                                            TextButton.styleFrom(
                                          foregroundColor: Colors.green,
                                        ),
                                        backgroundColor:
                                            AppConstants.transGColor,
                                        hourMinuteTextColor: Colors.white,
                                        hourMinuteTextStyle: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        dayPeriodTextColor: Colors.white,
                                        dayPeriodTextStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        helpTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        dialHandColor: Colors.yellow,
                                        dialBackgroundColor: Colors.white,
                                        dialTextColor: Colors.black,
                                        entryModeIconColor: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                final formattedTime =
                                    pickedTime.format(context);
                                setState(() {
                                  time = formattedTime;
                                });
                              }
                            },
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter time"
                                : null,
                            controller: TextEditingController(text: time),
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Key Spots",
                            hint: "Malam Jabba, Kalam, Fizagat",
                            initialValue: keySpots,
                            onSaved: (val) => keySpots = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter key spots"
                                : null,
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Transport Vehicle",
                            hint: "Coaster / Hiace",
                            initialValue: vehicle,
                            onSaved: (val) => vehicle = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter transport vehicle"
                                : null,
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Price",
                            hint: "20000",
                            initialValue: price,
                            onSaved: (val) => price = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter price"
                                : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          SizedBox(height: .02.sh),
                          CustTextFormField(
                            label: "Description",
                            hint:
                                "A memorable trip covering scenic valleys and activities...",
                            initialValue: description,
                            onSaved: (val) => description = val,
                            validator: (val) => val == null || val.isEmpty
                                ? "Enter description"
                                : null,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => isLoading = true);

                        try {
                          final tourID = widget.tourID ??
                              generateTourId(packageName!, widget.destination);

                          await _firestore
                              .collection('packages')
                              .doc(tourID)
                              .set({
                            'tourID': tourID,
                            'packageName': packageName,
                            'duration': duration,
                            'date': date,
                            'time': time,
                            'keySpots': keySpots,
                            'vehicle': vehicle,
                            'description': description,
                            'price': price,
                            'createdAt': FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));

                          setState(() => showSuccessAnimation = true);
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                            showErrorAnimation = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed: $e')),
                          );
                        } finally {
                          setState(() => isLoading = false);
                        }
                      }
                    },
                    child: isLoading
                        ? const SpinKitFadingCircle(
                            color: Colors.white, size: 70)
                        : Text(
                            widget.existingData != null
                                ? "Update Package"
                                : "Add Package",
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp)),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            height: 1.sh,
            width: 1.sw,
            color: AppConstants.blackColorP5,
            child: const Center(
                child: SpinKitFadingCircle(color: Colors.yellow, size: 70)),
          ),
        if (showSuccessAnimation)
          Container(
            height: 1.sh,
            width: 1.sw,
            color: AppConstants.blackColorP7,
            child: Center(
              child: Lottie.asset(
                'asset/animations/success.json',
                width: 150.w,
                height: 150.h,
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    if (mounted) {
                      setState(() => showSuccessAnimation = false);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ),
          ),
        if (showErrorAnimation)
          Container(
            height: 1.sh,
            width: 1.sw,
            color: AppConstants.blackColorP7,
            child: Center(
              child: Lottie.asset(
                'asset/animations/error.json',
                width: 150.w,
                height: 150.h,
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    if (mounted) {
                      setState(() => showErrorAnimation = false);
                    }
                  });
                },
              ),
            ),
          ),
      ]),
    );
  }
}
