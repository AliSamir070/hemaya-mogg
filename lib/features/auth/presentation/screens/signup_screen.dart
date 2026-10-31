import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/DI/di.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/dialog_utils.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/routes_manager/routes.dart';
import '../../../../core/widget/app_shimmer.dart';
import '../../../../core/widget/validators.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../viewmodels/signup/signup_view_model_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _userNameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SignupViewModelCubit>(),
      child: Scaffold(
        backgroundColor: ColorManager.backgroundDark,
        body: SizedBox(
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
                        color: ColorManager.buttonColor.withValues(alpha: 0.15),
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
                        color: ColorManager.buttonColorSecondary.withValues(
                          alpha: 0.15,
                        ),
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
                        SizedBox(height: 44.h),
                        Text(
                          StringsManager.createAccount,
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          StringsManager.createAccountSubtitle,
                          style: TextStyle(
                            color: ColorManager.hintColor,
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.h),

                        // Username ("name")
                        Text(
                          StringsManager.userName,
                          style: TextStyle(
                            color: ColorManager.hintColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _userNameController,
                          hintText: StringsManager.userNamePlaceholder,
                          validator: AppValidators.validateUsername,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: SvgPicture.asset(
                              AssetsManager.userIcon,
                              colorFilter: ColorFilter.mode(
                                ColorManager.inputIconOrange,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Full Name ("fullName")
                        Text(
                          StringsManager.fullName,
                          style: TextStyle(
                            color: ColorManager.hintColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _fullNameController,
                          hintText: StringsManager.fullNamePlaceholder,
                          validator: AppValidators.validateFullName,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: SvgPicture.asset(
                              AssetsManager.userIcon,
                              colorFilter: ColorFilter.mode(
                                ColorManager.inputIconOrange,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Phone ("phone")
                        Text(
                          StringsManager.phone,
                          style: TextStyle(
                            color: ColorManager.hintColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _phoneController,
                          hintText: StringsManager.phonePlaceholder,
                          keyboardType: TextInputType.phone,
                          validator: AppValidators.validatePhoneNumber,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: SvgPicture.asset(
                              AssetsManager.phoneIcon,
                              colorFilter: const ColorFilter.mode(
                                ColorManager.emerald,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Email ("email")
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
                          controller: _emailController,
                          hintText: StringsManager.emailPlaceholder,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.validateEmail,
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
                        SizedBox(height: 16.h),

                        // Password ("password")
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
                          controller: _passwordController,
                          hintText: StringsManager.createPasswordPlaceholder,
                          obscureText: _obscurePassword,
                          validator: AppValidators.validatePassword,
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
                        SizedBox(height: 16.h),

                        // Confirm Password
                        Text(
                          StringsManager.confirmPassword,
                          style: TextStyle(
                            color: ColorManager.hintColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _confirmPasswordController,
                          hintText: StringsManager.confirmPasswordPlaceholder,
                          obscureText: _obscureConfirmPassword,
                          validator: (val) =>
                              AppValidators.validateConfirmPassword(
                                val,
                                _passwordController.text,
                              ),
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
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(14.r),
                              child: SvgPicture.asset(
                                AssetsManager.eyeIcon,
                                colorFilter: ColorFilter.mode(
                                  _obscureConfirmPassword
                                      ? ColorManager.hintColor
                                      : ColorManager.buttonColorSecondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // Action Button with BlocConsumer & Shimmer loading
                        BlocConsumer<SignupViewModelCubit, SignupViewModelState>(
                          listener: (context, state) {
                            if (state is SignupViewModelError) {
                              DialogUtils.showMessageDialog(
                                context: context,
                                content: state.message,
                                actionTitle: StringsManager.ok,
                                actionPress: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            } else if (state is SignupViewModelSuccess) {
                              DialogUtils.showToast(
                                state.authEntity.message ??
                                    StringsManager.signupSuccessToast,
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.homeRoute,
                                (route) => false,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is SignupViewModelLoading) {
                              return AppShimmer(
                                child: ShimmerBox(
                                  height: 54.h,
                                  radius: 20.r,
                                ),
                              );
                            }
                            return CustomElevatedButton(
                              text: StringsManager.createAccount,
                              onpressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<SignupViewModelCubit>().signUp(
                                        name: _userNameController.text.trim(),
                                        fullName:
                                            _fullNameController.text.trim(),
                                        phone: _phoneController.text.trim(),
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(height: 36.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringsManager.alreadyHaveAccount,
                              style: TextStyle(
                                color: ColorManager.hintColor,
                                fontSize: 13.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(Routes.loginRoute);
                              },
                              child: Text(
                                StringsManager.login,
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
      ),
    );
  }
}
