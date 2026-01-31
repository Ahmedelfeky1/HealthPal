import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/home/presentation/main_layout.dart';
import 'package:doctor_appointment/features/profile/data/models/user_profile_model.dart';
import 'package:doctor_appointment/features/profile/data/services/profile_service.dart';
import 'package:doctor_appointment/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FillProfileScreen extends StatefulWidget {
  final UserProfileModel? userModel;
  final String firstName;
  final String email;
  const FillProfileScreen({
    super.key,
    this.userModel,
    required this.firstName,
    required this.email,
  });

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController nickNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController roleController;
  late TextEditingController dobController;
  bool isEditing = false;
  String? selectedGender;
  String? selectedRole;
  File? imageFile;
  String? uploadedImageUrl;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });

      try {
        final url = await ProfileService().uploadImage(imageFile!);
        setState(() {
          uploadedImageUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to upload image")));
      }
    }
  }

  final List<String> roles = ['Patient', 'Doctor'];
  final List<String> genders = ['Male', 'Female'];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    isEditing = widget.userModel != null;
    nameController = TextEditingController(
      text: isEditing ? widget.userModel!.fullName : widget.firstName,
    );
    emailController = TextEditingController(
      text: isEditing ? widget.userModel!.email : widget.email,
    );
    phoneController = TextEditingController(
      text: widget.userModel?.phoneNumber ?? '',
    );
    genderController = TextEditingController(
      text: widget.userModel?.gender ?? '',
    );
    roleController = TextEditingController(text: widget.userModel?.role ?? '');
    dobController = TextEditingController(
      text: widget.userModel?.dateOfBirth ?? '',
    );
    nickNameController = TextEditingController(
      text: widget.userModel?.nickname ?? '',
    );
    if (isEditing) {
      selectedGender = widget.userModel?.gender;
      selectedRole = widget.userModel?.role;
    }
    super.initState();
  }

  Future<void> selectDate(BuildContext context) async {
    if (isEditing) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorsManager.mainBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileService()),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.darkTeal),
              ),
            );
          } else if (state is ProfileSuccess) {
            Navigator.pop(context);
            if (isEditing) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated successfully")),
              );
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20.h),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9FBF5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Text(
                        "Congratulations!",
                        style: TextStyles.font18BlackBold.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        "Your account is ready to use. You will be redirected to the Home Page in a few seconds...",
                        textAlign: TextAlign.center,
                        style: TextStyles.font13GrayRegular.copyWith(
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      const CircularProgressIndicator(
                        color: ColorsManager.mainBlue,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );

              Future.delayed(const Duration(seconds: 3), () {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainLayout()),
                  );
                }
              });
            }
          } else if (state is ProfileError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorsManager.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorsManager.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: isEditing ? true : false,
              title: Text(
                isEditing ? "Edit Profile" : "Fill Profile",
                style: TextStyles.font18BlackBold.copyWith(
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60.r,
                              backgroundColor: ColorsManager.lighterGray,
                              backgroundImage: imageFile != null
                                  ? FileImage(imageFile!) as ImageProvider
                                  : (widget.userModel?.avatarUrl != null &&
                                        widget.userModel!.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(widget.userModel!.avatarUrl!)
                                  : null,
                              child:
                                  (imageFile == null &&
                                      (widget.userModel?.avatarUrl == null ||
                                          widget.userModel!.avatarUrl!.isEmpty))
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: ColorsManager.gray,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.darkBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: nameController,
                        isReadOnly: true,
                        backgroundColor: const Color.fromARGB(
                          132,
                          238,
                          238,
                          238,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        hintText: "Nickname",
                        controller: nickNameController,
                        backgroundColor: const Color.fromARGB(
                          132,
                          238,
                          238,
                          238,
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? "Required" : null,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        hintText: "Phone Number",
                        controller: phoneController,
                        backgroundColor: const Color.fromARGB(
                          132,
                          238,
                          238,
                          238,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        controller: emailController,
                        isReadOnly: true,
                        backgroundColor: const Color.fromARGB(
                          132,
                          238,
                          238,
                          238,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      isEditing
                          ? CustomTextFormField(
                              hintText: "Role",
                              controller: roleController,
                              isReadOnly: true,
                              backgroundColor: const Color.fromARGB(
                                132,
                                238,
                                238,
                                238,
                              ),
                              prefixIcon: const Icon(
                                Icons.work_outline,
                                color: Colors.grey,
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                size: 18,
                                color: Colors.grey,
                              ),
                            )
                          //
                          : DropdownButtonFormField<String>(
                              menuMaxHeight: 200.h,
                              borderRadius: BorderRadius.circular(16.0),
                              decoration: InputDecoration(
                                hintText: "I am a...",
                                hintStyle: TextStyles.font13GrayRegular,
                                prefixIcon: const Icon(
                                  Icons.work_outline,
                                  color: Colors.grey,
                                ),
                                fillColor: ColorsManager.moreLightGray,
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 18.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                    color: ColorsManager.lighterGray,
                                    width: 1.3,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                    color: ColorsManager.lighterGray,
                                    width: 1.3,
                                  ),
                                ),
                              ),
                              initialValue: selectedRole,
                              items: roles
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role.toLowerCase(),
                                      child: Text(
                                        role,
                                        style: TextStyles.font13GrayRegular,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value;
                                });
                              },
                              validator: (val) =>
                                  val == null ? "Required" : null,
                            ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hintText: "Date of Birth",
                              controller: dobController,
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              isReadOnly: true,
                              onTap: () => selectDate(context),

                              validator: (val) => val == null || val.isEmpty
                                  ? "Required"
                                  : null,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: isEditing
                                ? CustomTextFormField(
                                    hintText: "Gender",
                                    controller: genderController,
                                    isReadOnly: true,
                                    backgroundColor: isEditing
                                        ? const Color.fromARGB(
                                            132,
                                            238,
                                            238,
                                            238,
                                          )
                                        : null,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: isEditing
                                        ? Icon(
                                            Icons.lock,
                                            size: 18,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  )
                                : DropdownButtonFormField<String>(
                                    menuMaxHeight: 200.h,
                                    borderRadius: BorderRadius.circular(16.0),
                                    decoration: InputDecoration(
                                      hintText: "Gender",
                                      hintStyle: TextStyles.font13GrayRegular,
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                        color: Colors.grey,
                                      ),
                                      fillColor: ColorsManager.moreLightGray,
                                      filled: true,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 18.h,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: ColorsManager.lighterGray,
                                          width: 1.3,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: ColorsManager.lighterGray,
                                          width: 1.3,
                                        ),
                                      ),
                                    ),
                                    initialValue: selectedGender,
                                    items: genders
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style:
                                                  TextStyles.font13GrayRegular,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value;
                                      });
                                    },
                                    validator: (val) =>
                                        val == null ? "Required" : null,
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      CustomButton(
                        text: isEditing ? "Save" : "Save & Continue",
                        backgroundColor: ColorsManager.darkTeal,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().saveUserProfile(
                              fullName: widget.firstName,
                              nickname: nickNameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                              dateOfBirth: dobController.text,
                              gender: selectedGender!,
                              role: selectedRole!,
                              avatarUrl:
                                  uploadedImageUrl ??
                                  widget.userModel?.avatarUrl,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
