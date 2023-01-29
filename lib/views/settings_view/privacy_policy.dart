import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'terms_conditions.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: AppSize.s20.h),
          NavScreen3(
            title: AppStrings.privacyPolicy,
            positionSize: AppSize.s200,
          ),
          SizedBox(height: AppSize.s10),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    child: CustomTextNoOverFlow(
                      text: '360° Walkie Talkie Privacy Policy',
                      fontSize: FontSize.s16,
                      fontWeight: FontWeightManager.medium,
                      textColor: ColorManager.whiteColor,
                    ),
                  ),
                ),

                termsWidget2(
                    title:
                        'Our Privacy Policy ("Privacy Policy") helps explain our data practices, including the information we process to provide our Services.'),
                termsWidget2(
                    title:
                        'For example, our Privacy Policy talks about what information we collect and how this affects you. It also explains the steps we take to protect your privacy, like building our Services so delivered messages aren’t stored by us and giving you control over who you communicate with on our Services.'),
                termsWidget2(
                    title:
                        'This Privacy Policy applies to all of our Services unless specified otherwise.'),
                termsWidget2(
                    title:
                        'Please also read 360° Walkie Talkie’s Terms of Service , which describe the terms under which you use and we provide our Services.'),
                termsWidget2(
                    title: 'Information We Collect',
                    color: ColorManager.primaryColor,
                    isBold: true),
                termsWidget2(
                    title:
                        '360° Walkie Talkie must receive or collect some information to operate, provide, improve, understand, customize, support, and market our Services, including when you install, access, or use our Services.'),
                termsWidget2(
                    title:
                        "The types of information we receive and collect depend on how you use our Services. We require certain information to deliver our Services and without this we will not be able to provide our Services to you. For example, you must provide your mobile phone number to create an account to use our Services."),
                termsWidget2(
                    title:
                        'Our Services have optional features which, if used by you, require us to collect additional information to provide such features. You will be notified of such collection, as appropriate. If you choose not to provide the information needed to use a feature, you will be unable to use the feature. For example, you cannot share your location with your contacts if you do not permit us to collect your location data from your device. Permissions can be managed through your Settings menu on both Android and iOS devices.'),
                termsWidget2(
                    title: 'Information You Provide',
                    color: ColorManager.primaryColor,
                    isBold: true),
                termsWidget(
                    title: 'Your Account Information',
                    description:
                        'You must provide your mobile phone number, email address and basic information (including a username of your choice) to create a 360° Walkie Talkie account. If you don’t provide us with this information, you will not be able to create an account to use our Services. You can add other information to your account, such as a profile picture and "about" information.'),
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          child: termsWidget(
                              title: 'Your Messages.',
                              description:
                                  'We do not retain your messages in the ordinary course of providing our Services to you. Instead, your messages are stored on your device and not typically stored on our servers. Once your messages are delivered, they are deleted from our servers. The following scenarios describe circumstances where we may store your messages in the course of delivering them:')),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: termsWidget(
                              title: 'Undelivered Messages',
                              description:
                                  'If a message cannot be delivered immediately (for example, if the recipient is offline), we keep it in encrypted form on our servers for up to 30 days as we try to deliver it. If a message is still undelivered after 30 days, we delete it.'),
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: termsWidget(
                                title: 'Media Forwarding',
                                description:
                                    'When a user forwards media within a message, we store that media temporarily in encrypted form on our servers to aid in more efficient delivery of additional forwards. '),
                          )),
                    ],
                  ),
                ),
                termsWidget(
                title: 'Your Connections.',
                description:
                    'You can use the contact upload feature and provide us, if permitted by applicable laws, with the phone numbers in your address book on a regular basis, including those of users of our Services and your other contacts. If any of your contacts aren’t yet using our Services, we’ll manage this information for you in a way that ensures those contacts cannot be identified by us. You can create, join, or get added to a channel and broadcast lists, and such groups and lists get associated with your account information. You give your channel a name. You can provide a channel profile picture or description.'),
                termsWidget(
                title: 'Status Information.',
                description:
                    'You may provide us your status if you choose to include one on your account. Learn how to use status on Android, iPhone, or KaiOS.'),
                termsWidget(
                title: 'Customer Support And Other Communications',
                description:
                    'When you contact us for customer support or otherwise communicate with us, you may provide us with information related to your use of our Services, including copies of your messages, any other information you deem helpful, and how to contact you (e.g., an email address). For example, you may send us an email with information relating to app performance or other issues.'),
                termsWidget2(
                title: 'Automatically Collected Information',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget(
                title: 'Usage And Log Information',
                description:
                    'We collect information about your activity on our Services, like service-related, diagnostic, and performance information. This includes information about your activity (including how you use our Services, your Services settings, how you interact with others using our Services (including when you interact with a business), and the time, frequency, and duration of your activities and interactions), log files, and diagnostic, crash, website, and performance logs and reports. This also includes information about when you registered to use our Services; the features you use like our messaging, calling, Status, groups (including group name, group picture, group description), payments or business features; profile photo, "about" information; whether you are online, when you last used our Services (your "last seen"); and when you last updated your "about" information.'),
                termsWidget(
                title: 'Device And Connection Information',
                description:
                    'We collect device and connection-specific information when you install, access, or use our Services. This includes information such as hardware model, operating system information, battery level, signal strength, app version, browser information, mobile network, connection information (including phone number, mobile operator or ISP), language and time zone, IP address, and device operations information.'),
                termsWidget(
                title: 'Location Information.',
                description:
                    'We collect and use precise location information from your device with your permission when you choose to use location-related features, like when you decide to share your location with your contacts or view locations nearby or locations others have shared with you. There are certain settings relating to location-related information which you can find in your device settings or the in-app settings, such as location sharing. Even if you do not use our location-related features, we use IP addresses and other information like phone number area codes to estimate your general location (e.g., city and country). We also use your location information for diagnostics and troubleshooting purposes.'),
                termsWidget(
                title: 'Cookies',
                description:
                    'We use cookies to operate and provide our Services, including to provide our Services that are web-based, improve your experiences, understand how our Services are being used, and customize them. For example, we use cookies to provide our Services for web-based services. We may also use cookies to understand which of our Help Center articles are most popular and to show you relevant content related to our Services. Additionally, we may use cookies to remember your choices, like your language preferences, to provide a safer experience, and otherwise to customize our Services for you. '),
                termsWidget2(
                title: 'Third-Party Information',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget(
                title: 'Information Others Provide About You.',
                description:
                    'We receive information about you from other users. For example, when other users you know use our Services, they may provide your phone number, name, and other information (like information from their mobile address book) just as you may provide theirs. They may also send you messages, send messages to channels to which you belong, or call you. We require each of these users to have lawful rights to collect, use, and share your information before providing any information to us.You should keep in mind that in general, any user can capture screenshots of your chats or messages or make recordings of your calls with them and send them to 360° Walkie Talkie or anyone else, or post them on another platform.'),
                termsWidget(
                title: 'User Reports',
                description:
                    'Just as you can report other users, other users or third parties may also choose to report to us your interactions and your messages with them or others on our Services; for example, to report possible violations of our Terms or policies. When a report is made, we collect information on both the reporting user and reported user. To find out more about what happens when a user report is made, please see Advanced Safety and Security Features.'),
                termsWidget(
                title: 'Businesses On 360° Walkie Talkie.',
                description:
                    'Businesses you interact with using our Services may provide us with information about their interactions with you. We require each of these businesses to act in accordance with applicable law when providing any information to us.When you message with a business on 360° Walkie Talkie, keep in mind that the content you share may be visible to several people in that business. In addition, some businesses might be working with third-party service providers to help manage their communications with their customers. For example, a business may give such third-party service provider access to its communications to send, store, read, manage, or otherwise process them for the business. To understand how a business processes your information, including how it might share your information with third parties or 360\° Walkie Talkie, you should review that business\’ privacy policy or contact the business directly.'),
                termsWidget(
                title: 'Third-Party Service Providers',
                description:
                    'We work with third-party service providers to help us operate, provide, improve, understand, customize, support, and market our Services. For example, we work with them to distribute our apps; provide our technical and physical infrastructure, delivery, and other systems; provide engineering support, cybersecurity support, and operational support; supply location, map, and places information; process payments; help us understand how people use our Services; market our Services; help you connect with businesses using our Services; conduct surveys and research for us; ensure safety, security, and integrity; and help with customer service. These companies may provide us with information about you in certain circumstances; for example, app stores may provide us with reports to help us diagnose and fix service issues.'),
                termsWidget2(
                title: 'How We Use Information',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget2(
                title:
                    'We use information we have (subject to choices you make and applicable law) to operate, provide, improve, understand, customize, support, and market our Services. Here\'s how:'),
                termsWidget(
                title: 'Our Services.',
                description:
                    'We use information we have to operate and provide our Services, including providing customer support; improving, fixing, and customizing our Services; and connecting our Services with 360° Walkie Talkie products that you may use. We also use information we have to understand how people use our Services; evaluate and improve our Services; research, develop, and test new services and features; and conduct troubleshooting activities. We also use your information to respond to you when you contact us.'),
                termsWidget(
                title: 'Safety, Security, And Integrity.',
                description:
                    'Safety, security, and integrity are an integral part of our Services. We use information we have to verify accounts and activity; combat harmful conduct; protect users against bad experiences and spam; and promote safety, security, and integrity on and off our Services, such as by investigating suspicious activity or violations of our Terms and policies, and to ensure our Services are being used legally. Please see the Law, Our Rights and Protection section below for more information.'),
                termsWidget(
                title: 'No Third-Party Banner Ads',
                description:
                    'We still do not allow third-party banner ads on our Services. We have no intention to introduce them, but if we ever do, we will update this Privacy Policy.'),
                termsWidget2(
                title: 'Information You And We Share',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget2(
                title:
                    'You share your information as you use and communicate through our Services, and we share your information to help us operate, provide, improve, understand, customize, support, and market our Services.'),
                termsWidget(
                title:
                    'Send Your Information To Those With Whom You Choose To Communicate.',
                description:
                    'You share your information (calls and messages) as you use and communicate through our Services.'),
                termsWidget(
                title: 'Information Associated With Your Account. ',
                description:
                    'Your phone number, email address, profile name and photo, "about" information, last seen information, call, and message receipts are available to anyone who uses our Services, although you can configure your Services settings to manage certain information available to other users, including businesses, with whom you communicate.'),
                termsWidget(
                title: 'Your Contacts And Others.',
                description:
                    'Users, including businesses, with whom you communicate can store or reshare your information (including your phone number or messages) with others on and off our Services. You can use your Services settings and the “block” feature in our Services to manage who you communicate with on our Services and certain information you share.'),
                termsWidget(
                title: 'Third-Party Services.',
                description:
                    'When you or others use third-party services that are integrated with our Services, those third-party services may receive information about what you or others share with them. For example, if you use a data backup service integrated with our Services (like iCloud or Google Drive), they will receive information you share with them, such as your 360° Walkie Talkie messages. If you interact with a third-party service linked through our Services, information about you, like your IP address and the fact that you are a 360° Walkie Talkie user, may be provided to such third party. Please note that when you use third-party services, their own terms and privacy policies will govern your use of those services and products.'),
                termsWidget2(
                title: 'Assignment, Change Of Control, And Transfer',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget2(
                title:
                    'In the event that we are involved in a merger, acquisition, restructuring, bankruptcy, or sale of all or some of our assets, we will share your information with the successor entities or new owners in connection with the transaction in accordance with applicable data protection laws.'),
                termsWidget2(
                title: 'Managing And Retaining Your Information',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget2(
                title:
                    'You can access or port your information using our in-app Request Account Info feature (available under Settings > Account). For iPhone users, you can learn how to access, manage, and delete your information through our iPhone Help Center articles. For Android users, you can learn how to access, manage, and delete your information through our Android Help Center articles.'),
                termsWidget2(
                title:
                    'We store information for as long as necessary for the purposes identified in this Privacy Policy, including to provide our Services or for other legitimate purposes, such as complying with legal obligations, enforcing and preventing violations of our Terms, or protecting or defending our rights, property, and users. The storage periods are determined on a case-by-case basis that depends on factors like the nature of the information, why it is collected and processed, relevant legal or operational retention needs, and legal obligations.'),
                termsWidget2(
                title:
                    'If you would like to further manage, change, limit, or delete your information , you can do that through the following tools:',
                isBold: true),
                termsWidget(
                title: 'Services Settings',
                description:
                    'You can change your Services settings to manage certain information available to other users. You can manage your contacts and channels, or use our “block” feature to manage the users with whom you communicate.'),
                termsWidget(
                title:
                    'Changing Your Mobile Phone Number, Profile Name And Picture, And “About” Information.',
                description:
                    'If you change your mobile phone number, you must update it using our in-app change number feature and transfer your account to your new mobile phone number. You can also change your profile name, profile picture, and "about" information at any time.'),
                termsWidget(
                title: 'Deleting Your 360° Walkie Talkie Account.',
                description:
                    'You can delete your 360° Walkie Talkie account at any time (including if you want to revoke your consent to our use of your information pursuant to applicable law) using our in-app delete my account feature. When you delete your 360° Walkie Talkie account, your undelivered messages are deleted from our servers as well as any of your other information we no longer need to operate and provide our Services. Deleting your account will, for example, delete your account info and profile photo, delete you from all 360° Walkie Talkie channels, and delete your 360° Walkie Talkie message history. Be mindful that if you only delete 360° Walkie Talkie from your device without using our in-app delete my account feature, your information will be stored with us for a longer period. Please remember that when you delete your account, it does not affect your information related to the channels you created or the information other users have relating to you, such as their copy of the messages you sent them.'),
                termsWidget2(
                title:
                    'You can learn more here about our data deletion and retention practices and about how to delete your account.'),
                termsWidget2(
                title: 'Law, Our Rights, And Protection',
                isBold: true,
                color: ColorManager.primaryColor),
                termsWidget2(
                title:
                    'We access, preserve, and share your information described in the "Information We Collect" section of this Privacy Policy above if we have a good-faith belief that it is necessary to: (a) respond pursuant to applicable law or regulations, legal process, or government requests; (b) enforce our Terms and any other applicable terms and policies, including for investigations of potential violations; (c) detect, investigate, prevent, or address fraud and other illegal activity or security, and technical issues; or (d) protect the rights, property, and safety of our users, 360° Walkie Talkie, or others, including to prevent death or imminent bodily harm.'),
                termsWidget2(
                title: 'Updates To Our Policy',
                color: ColorManager.primaryColor,
                isBold: true),
                termsWidget2(
                title:
                    'We may amend or update our Privacy Policy. We will provide you notice of amendments to this Privacy Policy, as appropriate, and update the “Last modified” date at the top of this Privacy Policy. Please review our Privacy Policy from time to time.'),
                termsWidget2(
                title: 'Contact Us',
                isBold: true,
                color: ColorManager.primaryColor),
                termsWidget2(
                title:
                    'If you have questions or issues about our Privacy Policy, please contact us on our official email address - reyzortechnologies@gmail.com')
              ],
            ),
          ))
        ],
      )),
    );
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
