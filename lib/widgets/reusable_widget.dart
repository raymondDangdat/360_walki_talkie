import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class WalkieButton extends StatelessWidget {
   BuildContext context;
   VoidCallback onTap;
   String title;
   WalkieButton({Key? key, required this.context, required this.onTap, required this.title}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return InkWell(
       splashColor: Colors.transparent,
       highlightColor: Colors.transparent,
       onTap: onTap,
       child: Container(
         height: AppSize.s51.h,
         width: AppSize.s255.w,
         decoration: BoxDecoration(
           color: ColorManager.textColor,
           borderRadius: BorderRadius.circular(AppSize.s23.r),
           gradient: const LinearGradient(
               colors: [
                 Color.fromRGBO(255, 213, 79, 1),
                 Color.fromRGBO(255, 213, 79, 0),
               ],
               begin: FractionalOffset(0.0, 0.3),
               end: FractionalOffset(0.0, 1.0),
               // stops: [0.2, 1.0],
               ),

         ),
         alignment: Alignment.center,
         child: CustomText(text: title, textColor: const Color.fromRGBO(7, 7, 7, 1), fontSize: FontSize.s26,),

       ),
     );
   }
 }

class WalkieButtonBordered extends StatelessWidget {
  BuildContext context;
  VoidCallback onTap;
  String title;
  Color borderColor;
  Color textColor;
  WalkieButtonBordered({Key? key,
    required this.context,
    required this.onTap,
    required this.title,
    required this.textColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: AppSize.s51.h,
        width: AppSize.s255.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s23.r),
          border: Border.all(color: borderColor)

        ),
        alignment: Alignment.center,
        child: CustomText(text: title, textColor: textColor, fontSize: FontSize.s26,),

      ),
    );
  }



}


