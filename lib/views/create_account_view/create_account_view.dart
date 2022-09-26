import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';
import 'package:walkie_talkie_360/widgets/custom_text_field.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../resources/constanst.dart';
import '../../resources/navigation_utils.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final ImagePicker _picker = ImagePicker();

  File? file;
  XFile? xFile;


  handleChooseFromGallery(BuildContext context) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      xFile = file;
      this.file = File(file!.path);
    });

  }

  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool userNameTaken = false;
  bool isSearching = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,

      body: SafeArea(
          child: Scaffold(
            backgroundColor: ColorManager.bgColor,
            body: Column(
              children: [
                SizedBox(height: AppSize.s46.h,),
                Image.asset(AppImages.line),
                SizedBox(height: AppSize.s12.h,),
                CustomTextWithLineHeight(text: AppStrings.createAccount,
                  textColor: ColorManager.textColor, fontSize: FontSize.s20,),
                SizedBox(height: AppSize.s12.h,),
                Image.asset(AppImages.line),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.s28.h,),
                        Image.asset(AppImages.three60Circle),
                        SizedBox(height: AppSize.s16.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSize.s73.r),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: fullNameController,
                                hint: AppStrings.fullName,
                                labelText: AppStrings.fullName,
                                obSecureText: false,
                              ),
                              SizedBox(height: AppSize.s9.h,),

                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: ColorManager.textFilledColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: userNameController,
                                    cursorColor: ColorManager.textColor,
                                    autofocus: false,
                                    maxLines: 1,
                                    onChanged: (String value){
                                      setState(() {
                                        isSearching = true;
                                      });
                                      searchUserName(context, value);
                                    },
                                    maxLength: 20,
                                    style: TextStyle(
                                        color: ColorManager.textColor,
                                        fontSize: FontSize.s16
                                    ),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ColorManager.bgColor,
                                        hintText: AppStrings.username,
                                        labelText: AppStrings.username,
                                        counterText: "",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.r),
                                          borderSide:
                                          BorderSide(
                                              color: ColorManager.textColor,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.r),
                                          borderSide: BorderSide(
                                              color: ColorManager.textColor,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          gapPadding: 0.0,
                                          borderRadius:
                                          BorderRadius.circular(5.r),
                                          borderSide:
                                          BorderSide(
                                              color: ColorManager.textColor,
                                              width: 1),
                                        ),
                                        hintStyle: TextStyle(
                                            color: ColorManager.textColor,
                                            fontSize: FontSize.s16
                                        ),
                                        labelStyle: TextStyle(
                                            color: ColorManager.textColor,
                                            fontSize: FontSize.s16
                                        )
                                    ),
                                  )
                              ),

                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: isSearching ? "Searching..." :
                                    userNameTaken ? "Username taken" :
                                    !userNameTaken &&
                                        !isSearching &&
                                        userNameController.text.trim().length
                                            >= 3? "Username available!":
                                    !userNameTaken &&
                                        !isSearching &&
                                        userNameController.text.trim().length
                                            <3? "Hint: A unique name > 2 letters":
                                    "Search username availability",
                                    textColor: userNameTaken ?
                                    ColorManager.errorColor :
                                    !userNameTaken &&
                                        !isSearching &&
                                        userNameController.text.trim().length
                                            >=3? ColorManager.greenColor:
                                    !userNameTaken &&
                                        !isSearching &&
                                        userNameController.text.trim().length
                                            > 2? ColorManager.primaryColor :
                                    ColorManager.whiteColor,),
                                ],
                              ),

                              SizedBox(height: AppSize.s9.h,),
                              CustomTextField(
                                controller: passwordController,
                                hint: AppStrings.password,
                                labelText: AppStrings.password,
                                obSecureText: true,
                              ),

                              SizedBox(height: AppSize.s9.h,),

                              CustomTextField(
                                controller: emailController,
                                hint: AppStrings.email,
                                labelText: AppStrings.email,
                              ),

                              SizedBox(height: AppSize.s9.h,),

                              CustomTextField(
                                controller: phoneNumberController,
                                hint: AppStrings.phoneNumber,
                                isNumbers: true,
                                labelText: AppStrings.phoneNumber,
                                maxLength: 11,
                              ),

                              SizedBox(height: AppSize.s9.h,),

                              Container(
                                height: AppSize.s51.h,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: AppSize.s12.r
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(AppSize.s10.r),
                                  border: Border.all(
                                    color: ColorManager.primaryColor
                                  )
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: AppSize.s100.w,
                                      child: CustomText(
                                          text: file == null ?
                                          AppStrings.noFileHere :
                                          file!.path.toString().substring(file!.path.toString().length -10),
                                        textColor: ColorManager.primaryColor,
                                        fontSize: FontSize.s16,
                                      ),
                                    ),

                                    SizedBox(width: AppSize.s10.w,),

                                    Expanded(child: InkWell(
                                      onTap: (){
                                        handleChooseFromGallery(context);
                                      },
                                      child: Container(
                                        height: AppSize.s51.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppSize.s10.r),
                                          image: const DecorationImage(
                                              image: AssetImage(AppImages.buttonCreateAccount), fit: BoxFit.cover)
                                        ),
                                        alignment: Alignment.center,
                                        child: CustomTextWithLineHeight(
                                          text: file == null? AppStrings.chooseFile : AppStrings.changeFIle,
                                          textColor: ColorManager.blckTxtColor,
                                          fontSize: FontSize.s14,),
                                      ),
                                    ))

                                  ],
                                ),
                              ),

                              CustomTextWithLineHeight(
                                  text: AppStrings.uploadYourPassport,
                                textColor: ColorManager.primaryColor,
                                fontSize: FontSize.s14,),

                              SizedBox(height: AppSize.s17.h,),

                              SizedBox(
                                width: AppSize.s280.w ,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'by clicking on ',
                                    style: TextStyle(
                                        color: ColorManager.textColor
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '"create account"',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: ColorManager.whiteColor)),
                                      TextSpan(text: ' you completely agree to the',
                                        style: TextStyle(
                                            color: ColorManager.textColor
                                        ),),
                                      TextSpan(text: ' term of service',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: ColorManager.whiteColor)),
                                      TextSpan(text: ' and accept our',
                                        style: TextStyle(
                                            color: ColorManager.textColor
                                        ),),
                                      TextSpan(text: ' privacy policy.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: ColorManager.whiteColor)),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: AppSize.s17.h,),

                              Consumer<AuthenticationProvider>(
                                  builder: (ctx, auth, child) {
                                    WidgetsBinding.instance.
                                    addPostFrameCallback((_) {
                                      if (auth.resMessage != '') {
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.info(
                                            message: auth.resMessage,
                                            backgroundColor:
                                            ColorManager.primaryColor,
                                          ),
                                        );

                                        ///Clear the response message to avoid duplicate
                                        auth.clear();
                                      }
                                    });
                                  return WalkieButton(

                                      height: AppSize.s51.h,
                                      width: AppSize.s255.w,
                                      context: context,
                                      onTap: ()async{
                                    if(userNameTaken){
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: AppStrings.userNameTaken,
                                          backgroundColor:
                                          ColorManager.primaryColor,
                                        ),
                                      );
                                    }else if(
                                    emailController.text.isEmpty ||
                                    fullNameController.text.isEmpty ||
                                    userNameController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    phoneNumberController.text.isEmpty
                                    ){
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: AppStrings.allFieldsAreRequired,
                                          backgroundColor:
                                          ColorManager.primaryColor,
                                        ),
                                      );
                                    }else if(file == null){
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: AppStrings.avatarRequired,
                                          backgroundColor:
                                          ColorManager.primaryColor,
                                        ),
                                      );
                                    }else{
                                      final user = await
                                      auth.createUserWithEmailAndPassword(
                                          context: context,
                                          email: emailController.text
                                          , password: passwordController.text,
                                          fullName: fullNameController.text,
                                          userName:
                                          userNameController.text.toLowerCase(),
                                          phoneNumber:
                                          phoneNumberController.text,
                                        file: file!
                                      );

                                      if(user != null){
                                        openLoginScreen(context);
                                      }
                                    }

                                  }, title: AppStrings.createAccount);
                                }
                              ),

                              SizedBox(height: AppSize.s50.h,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void searchUserName(BuildContext context, String value) async{
    try{
      DocumentSnapshot doc = await registeredUserNamesCollection
          .doc(value.toLowerCase())
          .get();
      setState(() {
        // print("Docs: $doc");
      });

      if(doc.exists){
        // print("Username exist");
        setState(() {
          userNameTaken = true;
          isSearching = false;
        });
      }else{
        setState(() {
          userNameTaken = false;
          isSearching = false;
        });
        // print("Username not taken");
      }
    }catch (e){
      // print("Error: ${e.toString()}");

    }

    setState(() {
      isSearching = false;
    });
  }
}
