import 'dart:async';

import 'package:daily_news/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'images/ic_launcher.png',
              //fit: BoxFit.cover,
              width: width * .9,
              height: height * .5,
            ),
            SizedBox(height: height * .04,),
            Text(
                'Loading Daily News',
              style: GoogleFonts.anton(
                  letterSpacing: .6,
                  color:Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: height * .04,),
            const SpinKitFadingCircle(
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
