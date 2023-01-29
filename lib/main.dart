import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/theme_manager.dart';

import 'provider/channel_provider.dart';
import 'provider/chat_provider.dart';
import 'resources/color_manager.dart';
import 'resources/value_manager.dart';
import 'resources/routes_manager.dart';
import 'package:provider/provider.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    systemNavigationBarColor: ColorManager.bgColor, // navigation bar color
    statusBarColor: ColorManager.bgColor, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (_) => ChannelProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(AppSize.designWidth, AppSize.designHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: RouteGenerator.navigatorKey,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: Routes.initialRoute,
          theme: getApplicationTheme(),
        ));
  }
}
