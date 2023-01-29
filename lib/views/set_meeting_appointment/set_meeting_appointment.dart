import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/models/appointment_model.dart';
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
import '../../widgets/custom_dropdown.dart';
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

  String? selectedDayOfWeek = 'Monday';
  String? selectedHourOfDay = '12';
  String? selectedMinuteOfDay = '35';
  String? selectedAmPmOfDay = 'pm';
  String? selectedPattern = 'weekly';
  String? selectedChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
            child: Stack(
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.only(bottom: 20.h),
                child: SvgPicture.asset(
                  AppImages.clock,
                  color: ColorManager.whiteColor.withOpacity(.15),
                  height: AppSize.s300.h,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppSize.s20.h,
                  ),
                  NavScreen3(
                    title: AppStrings.setAppointment,
                    positionSize: AppSize.s200,
                  ),
                  SizedBox(
                    height: AppSize.s40.h,
                  ),
                  SvgPicture.asset(AppImages.clock),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p10),
                    child: CustomText(
                      text: AppStrings.setAlarm,
                      fontSize: AppSize.s30,
                      textColor: ColorManager.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s20.h,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p30),
                    child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Expanded(
                            child: customDropdown(
                              dropdownList: daysOfWeekList,
                              value: 'day',
                              selectedValue: selectedDayOfWeek,
                              onTap: (value) {
                                setState(() {
                                  selectedDayOfWeek = value as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: customDropdown(
                              dropdownList: hoursList,
                              value: 'value',
                              selectedValue: selectedHourOfDay,
                              onTap: (value) {
                                setState(() {
                                  selectedHourOfDay = value as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: customDropdown(
                              dropdownList: minutesList,
                              value: 'value',
                              selectedValue: selectedMinuteOfDay,
                              onTap: (value) {
                                setState(() {
                                  selectedMinuteOfDay = value as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: customDropdown(
                              dropdownList: amPmList,
                              value: 'value',
                              selectedValue: selectedAmPmOfDay,
                              onTap: (value) {
                                setState(() {
                                  selectedAmPmOfDay = value as String;
                                });
                              },
                            ),
                          )
                        ])),
                  ),
                  SizedBox(height: AppSize.s20.h),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p30),
                    child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Expanded(
                            child: customDropdown(
                              dropdownList: dummyChannels,
                              value: 'title',
                              selectedValue: selectedChannel,
                              onTap: (value) {
                                setState(() {
                                  selectedChannel = value as String;
                                });
                              },
                            ),
                          ),
                        ])),
                  ),
                  SizedBox(height: AppSize.s20.h),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p30),
                    child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Expanded(
                            child: customDropdown(
                              dropdownList: pattern,
                              value: 'day',
                              selectedValue: selectedPattern,
                              onTap: (value) {
                                setState(() {
                                  selectedPattern = value as String;
                                });
                              },
                            ),
                          ),
                        ])),
                  ),
                  SizedBox(
                    height: AppSize.s20.h,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p30),
                    child: Container(
                      height: AppSize.s35.h,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        border: Border.all(color: ColorManager.primaryColor),
                        borderRadius: BorderRadius.circular(AppSize.s20.r),
                      ),
                      child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: CustomText(
                              text: AppStrings.bookAppointment,
                              fontSize: FontSize.s14,
                              textColor: ColorManager.blackTextColor,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
