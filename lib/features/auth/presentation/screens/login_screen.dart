import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hemaya_mogg/core/widgets/custom_elevated_button.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundDark,
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            // Background glow top left
            Positioned(
              left: -100.w,
              top: -140.h,
              child: Container(
                width: 320.w,
                height: 320.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.buttonColor.withOpacity(0.15),
                      blurRadius: 100.r,
                      spreadRadius: 20.r,
                    ),
                  ],
                ),
              ),
            ),
            // Background glow bottom right
            Positioned(
              right: -70.w,
              bottom: -50.h,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.buttonColorSecondary.withOpacity(0.15),
                      blurRadius: 100.r,
                      spreadRadius: 20.r,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 54.h),
                      Text(
                        StringsManager.welcomeBack,
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        StringsManager.loginSubtitle,
                        style: TextStyle(
                          color: ColorManager.hintColor,
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        StringsManager.email,
                        style: TextStyle(
                          color: ColorManager.hintColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      AppTextFormField(
                        hintText: StringsManager.emailPlaceholder,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(14.r),
                          child: SvgPicture.asset(
                            AssetsManager.emailIcon,
                            colorFilter: ColorFilter.mode(
                              ColorManager.buttonColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        StringsManager.password,
                        style: TextStyle(
                          color: ColorManager.hintColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      AppTextFormField(
                        hintText: StringsManager.passwordPlaceholder,
                        obscureText: _obscurePassword,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(14.r),
                          child: SvgPicture.asset(
                            AssetsManager.lockIcon,
                            colorFilter: ColorFilter.mode(
                              ColorManager.buttonColorSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: SvgPicture.asset(
                              AssetsManager.eyeIcon,
                              colorFilter: ColorFilter.mode(
                                _obscurePassword
                                    ? ColorManager.hintColor
                                    : ColorManager.buttonColorSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                     CustomElevatedButton(text: StringsManager.login,onpressed:(){}),
                      SizedBox(height: 120.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringsManager.dontHaveAccount,
                            style: TextStyle(
                              color: ColorManager.hintColor,
                              fontSize: 13.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(Routes.signupRoute);
                            },
                            child: Text(
                              StringsManager.signUp,
                              style: TextStyle(
                                color: ColorManager.buttonColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
