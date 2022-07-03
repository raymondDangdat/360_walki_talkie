
import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/resources/styles_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';

import 'color_manager.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      //  Main Colors of the app
      primaryColor: ColorManager.primaryColor,
      disabledColor: ColorManager.disabledButtonColor,
      splashColor: ColorManager.primaryColor,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: ColorManager.accentColor),

      //  Card Theme
      cardTheme: CardTheme(
          color: ColorManager.cardColor, elevation: AppSize.cardElevation),

      //    AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: ColorManager.whiteColor,
        elevation: AppSize.appBarElevation,
        titleTextStyle:
            getAppBarTitleStyle(textColor: ColorManager.primaryColor),
      ),

      //   Button theme
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius),
          ),
          buttonColor: ColorManager.primaryColor,
          splashColor: ColorManager.primaryColor),

      //  Elevated button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
      
          style: ElevatedButton.styleFrom(
        textStyle: getAppBarTitleStyle(textColor: ColorManager.whiteColor),
        primary: ColorManager.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius),
        ),
        
      )),

      //  Text Theme
      textTheme: TextTheme(
          headline1: getBoldStyle(
              textColor: ColorManager.primaryColor, fontSize: FontSize.s24),
          headline2: getPageSubtitleStyle(textColor: ColorManager.primaryColor),
          bodyText1: getRegularStyle(textColor: ColorManager.lightTextColor)),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.contentPadding, vertical: AppPadding.contentPaddingTop ),
        hintStyle: getHintStyle(textColor: ColorManager.hintColor),
        labelStyle: getHintStyle(textColor: ColorManager.labelColor),
        errorStyle: getHintStyle(textColor: ColorManager.errorColor),

      

        //  Enable Borders
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.hintColor,
              width: AppSize.inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.hintColor,
              width: AppSize.inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),

        //  Focus Borders
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.primaryColor,
              width: AppSize.inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),

        //  Error Border
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.errorColor,
              width: AppSize.inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),

        //  Focus Error Border
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.errorColor,
              width: AppSize.inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),
      ));
}
