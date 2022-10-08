
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';

import '../resources/value_manager.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s4.r),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(AppSize.s5.r),
        width: AppSize.s100.w,
        height: AppSize.s100.h,
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: BorderRadius.circular(AppSize.s4.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSize.s30.h,),
            SizedBox(
              height: AppSize.s50.h,
              width: AppSize.s50.w,
              child: const CupertinoActivityIndicator(
                color: Colors.black,
              ),
            ),
            SizedBox(height: AppSize.s10.h,),


          ],
        ),
      ),
    );

  }
}