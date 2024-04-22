import 'package:shop_app_api_2/modules/shop_app/register/cubit/cubit.dart';
import 'package:shop_app_api_2/modules/shop_app/register/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/shop_layout.dart';
import '../../../presentation/color_manager.dart';
import '../../../presentation/string_manager.dart';
import '../../../presentation/values_manager.dart';
import '../../../shared/componants/components.dart';
import '../../../shared/componants/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../login/cubit/cubit.dart';

class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passWordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
            if (state is ShopRegisterSuccessState) {
              if (state.loginModel!.status ?? true) {
                print(state.loginModel!.message);
                print(state.loginModel!.data!.token);

                CacheHelper.saveData(
                    key: AppString.token,
                    value: state.loginModel!.data!.token)
                    .then((value) {
                  token= state.loginModel!.data!.token;
                  navigateAndFinish(
                    context,
                    ShopLayout(),
                  );
                });

                ShowToast(
                  text: state.loginModel!.message ,
                  state: ToastStates.SUCCESS,
                );
              } else {
                print(state.loginModel!.message);

                ShowToast(
                  text: state.loginModel!.message,
                  state: ToastStates.ERROR,
                );
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.s20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.Register,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                              color: ColorManager.black,
                            ),
                          ),
                          Text(
                            AppString.RegisterNow,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: ColorManager.grey),
                          ),
                          const SizedBox(
                            height: AppSize.s30,
                          ),
                          defualtFormField(
                            controller: nameController,
                            inputType: TextInputType.name,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppString.pleaseName;
                              }
                              return null;
                            },
                            labelText: AppString.userName,
                            prefix: Icons.person,
                          ),
                          const SizedBox(
                            height: AppSize.s15,
                          ),
                          defualtFormField(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppString.pleaseEmail;
                              }
                              return null;
                            },
                            labelText: AppString.emailAdr,
                            prefix: Icons.email_outlined,
                          ),
                          const SizedBox(
                            height: AppSize.s15,
                          ),
                          defualtFormField(
                            controller: passWordController,
                            inputType: TextInputType.visiblePassword,
                            suffix: ShopRegisterCubit
                                .get(context)
                                .suffix,
                            onSubmit: (value) {
                              // if (formKey.currentState!.validate()) {
                              //   ShopRegisterCubit.get(context).userLogin(
                              //     email: emailController.text,
                              //     password: passWordController.text,
                              //   );
                              // }
                            },
                            isPassword: ShopRegisterCubit
                                .get(context)
                                .isPasword,
                            suffixPressed: () {
                              ShopRegisterCubit.get(context)
                                  .changePasswordVisiability();
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppString.pleasePass;
                              }
                              return null;
                            },
                            labelText: AppString.password,
                            prefix: Icons.lock_open_outlined,
                          ),
                          const SizedBox(
                            height: AppSize.s15,
                          ),
                          defualtFormField(
                            controller: phoneController,
                            inputType: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppString.pleasePhone;
                              }
                              return null;
                            },
                            labelText: AppString.phone,
                            prefix: Icons.phone,
                          ),
                          const SizedBox(
                            height: AppSize.s30,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder: (context) =>
                                defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      ShopRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passWordController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  },
                                  text: AppString.register,
                                  isUpperCase: true,
                                ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          const SizedBox(
                            height: AppSize.s15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(AppString.dontHaveAnAccount),
                              defaultTextButton(
                                function: () {
                                  navigateTo(context, ShopRegisterScreen());
                                },
                                text: AppString.register,
                              ),
                            ],
                          )
                        ],
                      ),
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
