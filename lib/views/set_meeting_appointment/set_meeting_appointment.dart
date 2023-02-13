import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/models/appointment_model.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import 'package:walkie_talkie_360/widgets/loading.dart';
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

  late int day;
  late int hour;
  late int min;
  late int when;
  late int freq;

  List<UserChannelModel> allChannels = [];
  List<UserChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  //String? selectedDayOfWeek = 'Tuesday';
  //String? selectedHourOfDay = '12';
  //String? selectedMinuteOfDay = '23';
  //String? selectedAmPmOfDay = 'pm';

  String? selectedDayOfWeek = Jiffy().format("EEEE");
  String? selectedHourOfDay = '${Jiffy().hour - 12}';
  String? selectedMinuteOfDay = Jiffy().minute.toString();
  String? selectedAmPmOfDay = Jiffy().hour >= 12 ? 'pm' : 'am';
  String? selectedPattern = 'weekly';
  String? selectedChannel;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
            child: Stack(
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
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
                              onTap: (val) {
                                setState(() {
                                  day = val['id'];
                                });
                              },
                              value: 'day',
                              selectedValue: selectedDayOfWeek,
                              onChange: (value) {
                                setState(() {
                                  selectedDayOfWeek = (value as String?)!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: customDropdown(
                              dropdownList: hoursList,
                              onTap: (val) {
                                setState(() {
                                  hour = val['id'];
                                });
                              },
                              value: 'value',
                              selectedValue: selectedHourOfDay,
                              onChange: (value) {
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
                              onTap: (val) {
                                setState(() {
                                  min = val['id'];
                                });
                              },
                              value: 'value',
                              selectedValue: selectedMinuteOfDay,
                              onChange: (value) {
                                setState(() {
                                  selectedMinuteOfDay = value as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: customDropdown(
                              onTap: (val) {
                                setState(() {
                                  when = val['id'];
                                });
                              },
                              dropdownList: amPmList,
                              value: 'value',
                              selectedValue: selectedAmPmOfDay,
                              onChange: (value) {
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  buttonPadding:
                                      EdgeInsets.only(left: AppPadding.p8),
                                  buttonHeight: AppSize.s33.h,
                                  buttonDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(AppSize.s20.r),
                                      border: Border.all(
                                        color: ColorManager.primaryColor,
                                      )),
                                  alignment: Alignment.centerLeft,
                                  buttonWidth: 120.w,
                                  dropdownPadding: EdgeInsets.zero,
                                  dropdownMaxHeight: AppSize.s200.h,
                                  dropdownDecoration: BoxDecoration(
                                      color: ColorManager.bgColor),
                                  itemPadding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.p10,
                                      vertical: AppPadding.p5),
                                  itemHeight: AppSize.s25.h,
                                  icon: SvgPicture.asset(
                                    AppImages.dropdownIcon,
                                    height: 6,
                                  ),
                                  iconSize: 15,
                                  hint: CustomText(
                                    text: authProvider
                                                .userChannelsCreated.length ==
                                            0
                                        ? 'you have not created any channel'
                                        : 'Select channel',
                                    textColor: ColorManager.primaryColor,
                                  ),
                                  items: authProvider.userChannelsCreated
                                      .map((item) => DropdownMenuItem<Object>(
                                            onTap: () {
                                              setState(() {
                                                channelName = item.channelName;
                                                channelId = item.channelId;
                                              });
                                            },
                                            value: item.channelName,
                                            child: CustomText(
                                              text: item.channelName,
                                              textColor:
                                                  ColorManager.primaryColor,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedChannel,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedChannel = value as String;
                                    });
                                  }),
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
                              onTap: (val) {
                                setState(() {
                                  freq = val['id'];
                                });
                              },
                              value: 'day',
                              selectedValue: selectedPattern,
                              onChange: (value) {
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
                          onTap: () {
                            if (selectedChannel == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: ColorManager.redColor,
                                  content: CustomText(
                                      text:
                                          "you must select a channel first!")));
                            } else {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const LoadingIndicator());

                              channelProvider
                                  .pushAppointment(
                                      channelId: channelId,
                                      day: day,
                                      hour: hour,
                                      minute: min,
                                      when: when,
                                      frequency: freq,
                                      channelName: channelName,
                                      userId: authProvider.userInfo.userID,
                                      userName: authProvider.userInfo.userName)
                                  .then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            ColorManager.greenColor,
                                        content: CustomText(
                                          text:
                                              'Appointment created successfully',
                                        )));
                                Navigator.pop(context);
                              });
                            }
                          },
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

  initializeValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthenticationProvider>(context, listen: false);
      allChannels.addAll(auth.userChannelsConnected);
      allChannels.addAll(auth.userChannelsCreated);
    });

    setState(() {
      day = Jiffy().day;
      hour = int.parse(selectedHourOfDay!);
      min = int.parse(selectedMinuteOfDay!);
      when = Jiffy().hour >= 12 ? 1 : 0;
      freq = 7;
    });
  }
}
