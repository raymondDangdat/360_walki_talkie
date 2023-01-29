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

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
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
            title: AppStrings.termsAndConditions,
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
                        text: '360° Walkie Talkie Terms Of Service',
                        fontSize: FontSize.s16,
                        fontWeight: FontWeightManager.medium,
                        textColor: ColorManager.whiteColor,
                      ),
                    ),
                  ),
                  Container(
                    child: CustomTextNoOverFlow(
                      text: 'Table of Contents',
                      fontSize: FontSize.s16,
                      fontWeight: FontWeightManager.medium,
                      textColor: ColorManager.primaryColor,
                    ),
                  ),
                  termsWidget(
                      title: 'About Our Services', withDescription: false),
                  termsWidget(
                      title: 'Privacy Policy And User Data',
                      withDescription: false),
                  termsWidget(
                      title: 'Acceptable Use Of Our Services',
                      withDescription: false),
                  termsWidget(
                      title: 'Third-Party Services', withDescription: false),
                  termsWidget(title: 'Licenses', withDescription: false),
                  termsWidget(
                      title:
                          'Reporting Third-Party Copyright, Trademark, And Other Intellectual Property Infringement',
                      withDescription: false),
                  termsWidget(
                      title: 'Disclaimers And Release', withDescription: false),
                  termsWidget(
                      title: 'Limitation Of Liability', withDescription: false),
                  termsWidget(
                      title: 'Dispute Resolution', withDescription: false),
                  termsWidget(
                      title: 'Availability And Termination Of Our Services',
                      withDescription: false),
                  termsWidget(title: 'Other', withDescription: false),
                  termsWidget(
                      title:
                          'Accessing 360° Walkie Talkie\'s Terms in Different Languages',
                      withDescription: false),
                  termsWidget2(
                      title:
                          'In order to provide our Services (as defined below) through our apps, services, features, software, or website, we need to obtain your agreement to our Terms of Service ("Terms").'),
                  termsWidget2(
                      title: 'About Our Services',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget(
                      title: 'Privacy And Security Principles',
                      description:
                          'We have built our Services with strong privacy and security principles in mind.'),
                  termsWidget(
                      title: 'Connecting You With Other People',
                      description:
                          'We provide, and always strive to improve, ways for you to communicate with other 360° Walkie Talkie users including through messages, voice and video calls, sending images and video, showing your status, and sharing your location with others when you choose. 360° Walkie Talkie works with partners, service providers, and affiliated companies to help us provide ways for you to connect with their services.'),
                  termsWidget(
                      title: 'Safety, Security, And Integrity.',
                      description:
                          'We work to protect the safety, security, and integrity of our Services. This includes appropriately dealing with abusive people and activity violating our Terms. We work to prohibit misuse of our Services including harmful conduct towards others. If we learn of people or activity like this, we will take appropriate action by removing such people or activity or contacting law enforcement. Any such removal of people will be in accordance with the "Termination" section below.'),
                  termsWidget(
                      title: 'Enabling Access To Our Services',
                      description:
                          'o operate our global Services, we need to store and distribute content and information in data centers and systems around the world, including outside your country of residence. The use of this global infrastructure is necessary and essential to provide our Services. This infrastructure may be owned or operated by our service providers including affiliated companies.'),
                  termsWidget2(
                      title:
                          'We may add the clause Emergency service feature in the future and modify as appropriate (Ray)',
                      color: ColorManager.redColor),
                  termsWidget(
                      title: 'NO ACCESS TO EMERGENCY SERVICES: ',
                      description:
                          'There are important differences between our Services and your mobile phone and a fixed-line telephone and SMS services. Our Services do not provide access to emergency services or emergency services providers, including the police, fire departments, or hospitals, or otherwise connect to public safety answering points. You should ensure you can contact your relevant emergency services providers through a mobile phone, a fixed-line telephone, or other service.'),
                  termsWidget2(
                      title:
                          'We may add the clause Emergency service feature in the future and modify as appropriate (Ray)',
                      color: ColorManager.redColor),
                  termsWidget(
                      title: 'Registration',
                      description:
                          'You must register for our Services using accurate information, provide your current mobile phone number, and, if you change it, update your mobile phone number using our in-app change number feature. You agree to receive text messages and phone calls (from us or our third-party providers) with codes to register for our Services.'),
                  termsWidget(
                      title: 'Address Book',
                      description:
                          'You can use the contact upload feature and provide us, if permitted by applicable laws, with the phone numbers in your mobile address book on a regular basis, including those of both the users of our Services and your other contacts. Learn more about our contact upload feature here.'),
                  termsWidget(
                      title: 'Age',
                      description:
                          'If you live in a country or territory in the European Region, you must be at least 16 years old to use our Services or such greater age required in your country or territory to register for or use our Services without parental approval. If you live in any other country or territory except those in the European Region, you must be at least 13 years old to use our Services or such greater age required in your country or territory to register for or use our Services. In addition to being of the minimum required age to use our Services under applicable law, if you are not old enough to have authority to agree to our Terms in your country or territory, your parent or guardian must agree to our Terms on your behalf in order for you to use the Services. Please ask your parent or guardian to read these Terms with you.'),
                  termsWidget(
                      title: 'Devices And Software.',
                      description:
                          "You must provide certain devices, software, and data connections to use our Services, which we otherwise do not supply. In order to use our Services, you consent to manually or automatically download and install updates to our Services. You also consent to our sending you notifications via our Services from time to time, as necessary to provide our Services to you."),
                  termsWidget(
                      title: 'Fees And Taxes.',
                      description:
                          'You are responsible for all carrier data plans, Internet fees, and other fees and taxes associated with your use of our Services.'),
                  termsWidget2(
                      title: 'Privacy Policy And User Data',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget2(
                      title:
                          '360° Walkie Talkie cares about your privacy. 360° Walkie Talkie  Privacy Policy describes our data (including calls and messages) practices, including the types of information we receive and collect from you, how we use and share this information, and your rights in relation to the processing of information about you'),
                  termsWidget2(
                      title: 'Acceptable Use Of Our Services',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget(
                      title: 'Our Terms And Policies',
                      description:
                          'You must use our Services according to our Terms and policies. If you violate our Terms or policies, we may take action with respect to your account, including disabling or suspending your account and, if we do, you agree not to create another account without our permission. Disabling or suspending your account will be in accordance with the "Termination" section below.'),
                  termsWidget(
                      title: 'Legal And Acceptable Use.',
                      description:
                          'You must access and use our Services only for legal, authorized, and acceptable purposes. You will not use (or assist others in using) our Services in ways that: (a) violate, misappropriate, or infringe the rights of 360° Walkie Talkie , our users, or others, including privacy, publicity, intellectual property, or other proprietary rights; (b) are illegal, obscene, defamatory, threatening, intimidating, harassing, hateful, racially or ethnically offensive, or instigate or encourage conduct that would be illegal or otherwise inappropriate, such as promoting violent crimes, endangering or exploiting children or others, or coordinating harm; (c) involve publishing falsehoods, misrepresentations, or misleading statements; (d) impersonate someone; (e) involve sending illegal or impermissible communications, such as bulk messaging, auto-messaging, auto-dialing, and the like; or (f) involve any non-personal use of our Services unless otherwise authorized by us.'),
                  termsWidget(
                      title: 'Harm To 360° Walkie Talkie Or Our Users.',
                      description:
                          'You must not (or assist others to) directly, indirectly, through automated or other means access, use, copy, adapt, modify, prepare derivative works based upon, distribute, license, sublicense, transfer, display, perform, or otherwise exploit our Services in impermissible or unauthorized manners, or in ways that burden, impair, or harm us, our Services, systems, our users, or others, including that you must not directly or through automated means: (a) reverse engineer, alter, modify, create derivative works from, decompile, or extract code from our Services; (b) send, store, or transmit viruses or other harmful computer code through or onto our Services; (c) gain or attempt to gain unauthorized access to our Services or systems; (d) interfere with or disrupt the safety, security, confidentiality, integrity, availability or performance of our Services; (e) create accounts for our Services through unauthorized or automated means; (f) collect information of or about our users in any impermissible or unauthorized manner; (g) sell, resell, rent, or charge for our Services or data obtained from us or our Services in an unauthorized manner; (h) distribute or make our Services available over a network where they could be used by multiple devices at the same time, except as authorized through tools we have expressly provided via our Services; (i) create software or APIs that function substantially the same as our Services and offer them for use by third parties in an unauthorized manner; or (j) misuse any reporting channels, such as by submitting fraudulent or groundless reports or appeals.'),
                  termsWidget(
                      title: 'Keeping Your Account Secure.',
                      description:
                          'You are responsible for keeping your device and your 360° Walkie Talkie account safe and secure, and you must notify us promptly of any unauthorized use or security breach of your account or our Services.'),
                  termsWidget2(
                      title: 'Third-Party Services',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget2(
                      title:
                          'Our Services may allow you to access, use, or interact with third-party websites, apps, content, other products and services. For example, you may choose to use third-party data backup services (such as iCloud or Google Drive) that are integrated with our Services or interact with a share button on a third-party\'s website that enables you to send information to your 360° Walkie Talkie contacts. Please note that these Terms and our Privacy Policy apply only to the use of our Services. When you use third-party products or services, their own terms and privacy policies will govern your use of those products or services.'),
                  termsWidget2(
                      title: 'Licenses',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget(
                      title: 'Your Rights',
                      description:
                          '360° Walkie Talkie does not claim ownership of the information that you submit for your 360° Walkie Talkie account or through our Services. You must have the necessary rights to such information that you submit for your 360° Walkie Talkie account or through our Services and the right to grant the rights and licenses in our Terms.'),
                  termsWidget(
                      title: '360° Walkie Talkie\'s Rights.',
                      description:
                          'We own all copyrights, trademarks, domains, logos, trade dress, trade secrets, patents, and other intellectual property rights associated with our Services. You may not use our copyrights, trademarks (or any similar marks), domains, logos, trade dress, trade secrets, patents, or other intellectual property rights unless you have our express permission and except in accordance with our Brand Guidelines. You may use the trademarks of our affiliate companies only with their permission, including as authorized in any published brand guidelines.'),
                  termsWidget(
                      title: 'Your License To 360° Walkie Talkie.',
                      description:
                          'We grant you a limited, revocable, non-exclusive, non-sublicensable, and non-transferable license to use our Services, subject to and in accordance with our Terms. This license is for the sole purpose of enabling you to use our Services in the manner permitted by our Terms. No licenses or rights are granted to you by implication or otherwise, except for the licenses and rights expressly granted to you.'),
                  termsWidget2(
                      title:
                          'Reporting Third-Party Copyright, Trademark, And Other Intellectual Property Infringement',
                      isBold: true,
                      color: ColorManager.primaryColor),
                  termsWidget2(
                      title:
                          'To report claims of third-party copyright, trademark, or other intellectual property infringement, please visit our Intellectual Property Policy. We may take action with respect to your account, including disabling or suspending your account, if you clearly, seriously or repeatedly infringe the intellectual property rights of others or where we are required to do so for legal reasons. Disabling or suspending your account will be in accordance with the "Termination" section below.'),
                  termsWidget2(
                      title: 'Disclaimers And Release',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget2(
                      title:
                          'You use our Services at your own risk and subject to the following disclaimers. We are providing our Services on an "as is" basis without any express or implied warranties, including, but not limited to, warranties of merchantability, fitness for a particular purpose, title, non-infringement, and freedom from computer virus or other harmful code. We do not warrant that any information provided by us is accurate, complete, or useful, that our Services will be operational, error free, secure, or safe, or that our Services will function without disruptions, delays, or imperfections. We do not control and are not responsible for, controlling how or when our users use our Services or the features, services, and interfaces our Services provide. We are not responsible for and are not obligated to control the actions or information (including content) of our users or other third-parties. You release us, our subsidiaries, affiliates, and our and their directors, officers, employees, partners, and agents (together, the "360° Walkie Talkie Parties") from any claim, complaint, cause of action, controversy, or damages (together, "Claim"), known and unknown, relating to, arising out of, or in any way connected with any such Claim you have against any third-parties. Your rights with respect to the 360° Walkie Talkie Parties are not modified by the foregoing disclaimer if the laws of your country or territory of residence, applicable as a result of your use of our Services, do not permit it.'),
                  termsWidget2(
                      title: 'Limitation Of Liability',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget2(
                      title:
                          '360° Walkie Talkie is only liable to the following extent:',
                      isBold: true),
                  termsWidget2(
                      title:
                          '360° Walkie Talkie is liable without limitation in accordance with the statutory provisions for damages resulting from injury to life, body or health; in the case of intent; in the case of gross negligence; and in accordance with the Product Liability Directive.'),
                  termsWidget2(
                      title:
                          '360° Walkie Talkie will exercise professional diligence in providing the Services to you. Provided that we have acted with professional diligence, 360° Walkie Talkie does not accept responsibility for losses not caused by our breach of these Terms or otherwise by our acts; losses that are not reasonably foreseeable by you and us at the time of entering into these Terms; and events beyond our reasonable control.'),
                  termsWidget2(
                      title: 'Dispute Resolution',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget2(
                      title:
                          'If you are a consumer and habitually reside in a country or territory within the European Region, the laws of your country or territory will apply to any Claim you have against us that arises out of or relates to these Terms or our Services, and you may resolve your Claim in any competent court in your country or territory that has jurisdiction over the Claim. In all other cases, you agree that the Claim must be resolved in a competent court in Ireland that has jurisdiction over the Claim and that the laws of Ireland will govern these Terms and any Claim, without regard to conflict of law provisions.'),
                  termsWidget2(
                      title: 'Availability And Termination Of Our Services',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget(
                      title: 'Availability Of Our Services.',
                      description:
                          'We are always trying to improve our Services. That means we may expand, add, or remove our Services, features, functionalities, and the support of certain devices and platforms. Our Services may be interrupted, including for maintenance, repairs, upgrades, or network or equipment failures. We may discontinue some or all of our Services, including certain features and the support for certain devices and platforms, at any time after a notice period of 30 days, with no such notice being required in urgent situations such as preventing abuse, responding to legal requirements, or addressing security and operability issues. Events beyond our control may affect our Services, such as events in nature and other force majeure events.'),
                  termsWidget(
                      title: 'Termination',
                      description:
                          'Although we hope you remain a 360° Walkie Talkie user, you can terminate your relationship with 360° Walkie Talkie anytime for any reason by deleting your account. For instructions on how to do so, please visit the Android, iPhone, or KaiOS articles in our Help Center.'),
                  termsWidget2(
                      title:
                          'Our right to terminate for cause remains unaffected. Good cause shall be deemed to exist if one party violates laws, third-party rights, or otherwise breaches these Terms, and the terminating party cannot reasonably be expected to continue the contractual relationship until the agreed termination date or until the expiry of a notice period, taking into account all circumstances of the individual case and after weighing the interests of both parties. A termination for good cause is only possible within a reasonable period of time after a breach has come to the knowledge of the other party'),
                  termsWidget2(
                      title:
                          'If the important reason is a violation of an obligation of these Terms, termination is only permissible after the unsuccessful expiration of a granted remedy period or after an unsuccessful warning. However, this does not apply if the party in breach seriously and finally refuses to fulfill its obligations or if, after weighing the interests of both parties, special circumstances justify immediate termination.'),
                  termsWidget2(
                      title:
                          'In accordance with this "Termination" section, we may also modify, suspend, or terminate your access to or use of our Services anytime for suspicious or unlawful conduct, including for fraud, or if we reasonably believe you violate our Terms or create harm, risk, or possible legal exposure for us, our users, or others. We may also disable or delete your account if it does not become active after account registration or if it remains inactive for an extended period of time. If you delete your account or we delete or disable it, these Terms will end as an agreement between you and us, but the following provisions will survive any termination of your relationship with 360° Walkie Talkie: "Licenses," "Disclaimers And Release," "Limitation Of Liability," "Dispute Resolution," "Availability And Termination Of Our Services," and "Other.” If you believe your account\'s termination or suspension was in error, please contact us at reyzortechnologie@gmail.com'),
                  termsWidget2(
                      title: 'Other',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget(
                      noTitle: true,
                      title:
                          'Unless a mutually executed agreement between you and us states otherwise, our Terms make up the entire agreement between you and us regarding 360° Walkie Talkie and our Services, and supersede any prior agreements.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'We reserve the right to designate in the future that certain of our Services are governed by separate terms (where, as applicable, you may separately consent).'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'Our Services are not intended for distribution to or use in any country or territory where such distribution or use would violate local law or would subject us to any regulations in another country or territory. We reserve the right to limit our Services in any country or territory.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'You will comply with all applicable United States and non-United States export control and trade sanctions laws ("Export Laws"). You will not, directly or indirectly, export, re-export, provide, or otherwise transfer our Services: (a) to any individual, entity, territory, or country prohibited by Export Laws; (b) to anyone on United States or non-United States government restricted parties lists; or (c) for any purpose prohibited by Export Laws, including nuclear, chemical, or biological weapons, or missile technology applications without the required government authorizations. You will not use or download our Services if you are located in a restricted country or territory, if you are currently listed on any United States or non-United States restricted parties list, or for any purpose prohibited by Export Laws, and you will not disguise your location through IP proxying or other methods.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'Any amendment to or waiver of our Terms proposed by you requires our express consent.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'We are constantly working to improve our Services and develop new features to make our products even better for you and our community. Therefore, we may need to update these Terms from time to time to reflect our Services and practices correctly. We will only make changes if the provisions are no longer appropriate or incomplete. Unless otherwise required by law, we will provide you at least 30 days\' advance notice of changes to our Terms (e.g., by e-mail or through the Services), which will give you the opportunity to review the revised Terms before they become effective, and we will ensure that any such changes are reasonable for you, taking into consideration your interests. We will also update the "Last modified" date at the top of our Terms. Changes to these Terms shall become effective no sooner than 30 days after we provide notice of planned changes. Once updated Terms come into effect, you will be bound by them if you continue to use our Services. We hope you will continue using our Services, but if you do not agree to our Terms, as amended, you must stop using our Services by deleting your account.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'All of our rights and obligations under our Terms are freely assignable by us to any of our affiliates or in connection with a merger, acquisition, restructuring, or sale of assets, or by operation of law or otherwise. In the event of such an assignment, we will only transfer your information in compliance with applicable laws, and ask for your consent where required; these Terms will continue to govern your relationship with such third-party. We hope you will continue using 360° Walkie Talkie, but if you do not agree to such an assignment, you must stop using our Services by deleting your account after having been notified about the assignment.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'You will not transfer any of your rights or obligations under our Terms to anyone else without our prior written consent.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'Nothing in our Terms will prevent us from complying with the law.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'Except as contemplated herein, our Terms do not give any third-party beneficiary rights.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'If we fail to enforce any of our Terms, it will not be considered a waiver.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'If any provision of these Terms is found to be unlawful, void, or for any reason unenforceable, then that provision shall be deemed amended to the minimum extent necessary to make it enforceable, and if it cannot be made enforceable, then it shall be deemed severable from our Terms and shall not affect the validity and enforceability of the remaining provisions of our Terms, and the remaining portion of our Terms will remain in full force and effect.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'We reserve all rights not expressly granted by us to you. In certain jurisdictions, you may have legal rights as a consumer, and our Terms are not intended to limit such consumer legal rights that may not be waived by contract. Also, in certain jurisdictions, you may have legal rights as a data subject, and our Terms are not intended to limit such rights that may not be waived by contract.'),
                  termsWidget(
                      noTitle: true,
                      title:
                          'We always appreciate your feedback or other suggestions about 360° Walkie Talkie and our Services, but you understand that you have no obligation to provide feedback or suggestions and that we may use your feedback or suggestions without any restriction or obligation to compensate you for them.'),
                  termsWidget2(
                      title:
                          'Accessing 360° Walkie Talkie \'s Terms in Different Languages',
                      color: ColorManager.primaryColor,
                      isBold: true),
                  termsWidget2(
                      title:
                          'To access our Terms in certain other languages, change the language setting for your 360° Walkie Talkie  session. If our Terms are not available in the language you select, we will default to the English version.'),
                  termsWidget2(
                      title:
                          'Please review the following documents, which provide additional information about your use of our Services:')
                ],
              ),
            ),
          )
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

Widget termsWidget({
  required String title,
  String? description,
  double? leftPadding,
  double? topPadding,
  bool? withDescription = true,
  bool? noTitle = false,
}) {
  return SizedBox(
    child: Padding(
        padding: EdgeInsets.only(
            left: leftPadding ?? 10.0, top: topPadding ?? 6, bottom: 4),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.square,
                    size: 7,
                    color: ColorManager.whiteColor,
                  ),
                  SizedBox(width: 7),
                  Expanded(
                      child: CustomTextNoOverFlow(
                    text: title,
                    justification: true,
                    textColor: ColorManager.whiteColor,
                    fontSize: AppSize.s13,
                    fontWeight: noTitle == true
                        ? FontWeightManager.hintWeight
                        : FontWeightManager.bold,
                  )),
                ],
              ),
              withDescription == true
                  ? CustomTextNoOverFlow(
                      justification: true,
                      text: description ?? '',
                      textColor: ColorManager.whiteColor,
                      fontSize: FontSize.s13,
                      fontWeight: FontWeightManager.hintWeight,
                    )
                  : SizedBox(),
            ],
          ),
        )),
  );
}

Widget termsWidget2({
  required String title,
  Color? color,
  bool? isBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: CustomTextNoOverFlow(
      justification: true,
      text: title,
      fontSize: FontSize.s13,
      fontWeight:
          isBold == true ? FontWeightManager.bold : FontWeightManager.medium,
      textColor: color ?? ColorManager.whiteColor,
    ),
  );
}
