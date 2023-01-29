import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../models/channel_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/customDrawer.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class SetMeetingAppointment extends StatefulWidget {
  const SetMeetingAppointment({Key? key}) : super(key: key);

  @override
  State<SetMeetingAppointment> createState() => _SetMeetingAppointmentState();
}

class _SetMeetingAppointmentState extends State<SetMeetingAppointment> {
  final channelNameController = TextEditingController();

  bool channelNameFound = false;
  bool isSearching = false;
  String channelName = "";
  String channelId = "";

  List<UserChannelModel> allChannels = [];
  List<UserChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  // void getAllChannels() async {
  //
  //
  //   await getChannels().then((value) {
  //     channelSnapshot = value;
  //     allChannels = channelSnapshot!.docs
  //         .map((doc) => SearchChannelModel.fromSnapshot(doc))
  //         .toList();
  //     print("Channels length: ${allChannels.length}");
  //     isSearching = false;
  //     setState(() {});
  //   });
  // }

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthenticationProvider>(context, listen: false);

      allChannels.addAll(auth.userChannelsConnected);
      allChannels.addAll(auth.userChannelsCreated);
    });
    setState(() {});
    super.initState();
  }

  String selectedDay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: AppSize.s20.h,
              ),
              NavScreen3(
                title: AppStrings.setAppointment,
                positionSize: AppSize.s200,
              ),
              SizedBox(
                height: AppSize.s80.h,
              ),
              SvgPicture.asset(AppImages.clock),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                child: CustomText(
                  text: AppStrings.setAlarm,
                  fontSize: AppSize.s30,
                  textColor: ColorManager.primaryColor,
                ),
              ),
              SizedBox(
                height: AppSize.s25.h,
              ),
             
              SizedBox(
                  child: Row(children: [
                // DropdownButtonHideUnderline(
                //   child: DropdownButton2(
                //     isExpanded: true,
                //     hint: Row(
                //       children: const [
                //         Expanded(
                //             child: DropdownButtonHint(
                //               hint: AppStrings.channelType,)),
                //       ],
                //     ),
                //     items: daysOfWeekList
                //         .map((item) => DropdownMenuItem<Object>(
                //         value: item,
                //         child: Row(
                //           mainAxisAlignment:
                //           MainAxisAlignment.spaceBetween,
                //           children: [
                //             DropdownButtonText(
                //                 text: item['day']),
                //           ],
                //         )))
                //         .toList(),
                //     value: selectedDay,
                //     onChanged: (value) {
                //       setState(() {
                //         selectedDay = value as String;
                //       });
                //     },
                //     icon: SvgPicture.asset(AppImages.dropdownIcon),
                //     iconSize: 14,
                //     buttonHeight: 50,
                //     buttonPadding:
                //     const EdgeInsets.only(left: 14, right: 14),
                //     buttonDecoration: BoxDecoration(
                //       borderRadius:
                //       BorderRadius.circular(AppSize.s6.r),
                //       border: Border.all(
                //         color: ColorManager.textColor,
                //       ),
                //       color: ColorManager.bgColor,
                //     ),
                //     itemHeight: 40,
                //     dropdownPadding: null,
                //     dropdownDecoration: BoxDecoration(
                //       borderRadius:
                //       BorderRadius.circular(AppSize.s4.r),
                //       color: ColorManager.deepOrange,
                //     ),
                //     dropdownElevation: 8,
                //     selectedItemHighlightColor:
                //     ColorManager.bgColor,
                //     scrollbarAlwaysShow: false,
                //     offset: const Offset(0, 0),
                //   ),
                // )
              ])),
              SizedBox(
                height: AppSize.s20.h,
              )
            ],
          ),
        )));
  }

  void searchUserName(BuildContext context, String value) async {
    try {
      DocumentSnapshot doc =
          await channelNamesCollection.doc(value.toLowerCase()).get();
      setState(() {
        // print("Docs: $doc");
      });

      if (doc.exists) {
        print("Username exist");
        setState(() {
          channelNameFound = true;
          isSearching = false;
          channelId = doc['channelId'];
          channelName = doc['channelName'];
        });
      } else {
        setState(() {
          channelNameFound = false;
          isSearching = false;
        });
        // print("Username not taken");
      }
    } catch (e) {
      // print("Error: ${e.toString()}");

    }

    setState(() {
      isSearching = false;
    });
  }
}
