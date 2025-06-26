import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famzy_tourz_app/UI/MainScreens/MainScreen.dart';
import 'package:famzy_tourz_app/Utilities/CustElevButt.dart';
import 'package:famzy_tourz_app/Utilities/CustTFField.dart';
import 'package:famzy_tourz_app/Utilities/ToastPopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditionalInfoScreen extends StatefulWidget {
  final User user;

  const AdditionalInfoScreen({super.key, required this.user});

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  int? _age;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: 1.sh,
      width: 1.sw,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'asset/images/elianna-gill-AnqA_W26zEM-unsplash.jpg'),
            fit: BoxFit.fill),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
            child: Image.asset(
              "asset/images/FAMZYLogo.png",
              width: .8.sw,
              height: .2.sh,
            ),
          ),
          Text(
            "Additional Information",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 57, 2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(.03.sw),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: .05.sh,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(50, 0, 30, 0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: .02.sw),
                        child: Column(children: [
                          CustTextFormField(
                            label: 'Age',
                            hint: '18',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              _age = int.tryParse(value);
                              if (_age == null || _age! <= 0 || _age! > 130) {
                                return 'Invalid age, it should be between 13 and 130';
                              }
                              if (_age! < 13) {
                                return 'You are underage'; // Not eligible
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _age = int.tryParse(value!) ??
                                  0; // Parse and set 0 if invalid
                              if (_age! < 1 || _age! > 130) {
                                _age = 0; // Enforce 0 for invalid ranges
                              }
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: .05.sh,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              label: Text(
                                'Gender',
                                style: TextStyle(color: Colors.white),
                              ),
                              fillColor: Colors
                                  .black, // Background color of the dropdown
                              hintText: 'Not Selected',
                              hintStyle: const TextStyle(color: Colors.grey),

                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors
                                      .grey, // Underline color when enabled
                                  width: 1.0, // Underline width
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 123, 100,
                                      22), // Underline color when focused
                                  width: 2.0, // Underline width
                                ),
                              ),
                            ),
                            dropdownColor: Color.fromARGB(180, 0, 30, 0),
                            items: [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 176, 241)),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 109, 157)),
                                ),
                              ),
                              DropdownMenuItem(
                                  value: 'other',
                                  child: Text(
                                    'Other',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                    ),
                                  ))
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select a gender' : null,
                          ),
                        ]),
                      )),
                  SizedBox(height: .1.sh),
                  CustomElevatedButton(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Submit'),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('UserDetails')
                              .doc(widget.user.uid)
                              .set({
                            'gender': _gender,
                            'age': _age,
                          }, SetOptions(merge: true));
                          ToastPopUp()
                              .toastPopUp('Sign Up Successful', Colors.black);

                          // move to  main scree
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                          setState(() {
                            isLoading = false;
                          });
                          _formKey.currentState!.reset();
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
