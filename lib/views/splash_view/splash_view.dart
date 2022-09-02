import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/image_manager.dart';
import '../../resources/routes_manager.dart';

import '../../resources/value_manager.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    final ref = await SharedPreferences.getInstance();
    if(ref.getBool(showOnBoarding) == null || ref.getBool(showOnBoarding) == true){
      Navigator.pushReplacementNamed(context, Routes.onBoarding);
    }else{
      Navigator.pushReplacementNamed(context, Routes.newGetStartedScreen);
    }

  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: AppSize.s450.h,
            width: double.infinity,
            child: Image.asset(AppImages.three60Circle),
          ),
        ),
      ),
    );
  }
}
