import 'package:shop_app_api_2/layout/shop_app/shop_layout.dart';
import 'package:shop_app_api_2/modules/shop_app/login/cubit/cubit.dart';
import 'package:shop_app_api_2/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app_api_2/modules/shop_app/register/shop_register_screen.dart';
import 'package:shop_app_api_2/presentation/color_manager.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:shop_app_api_2/shared/network/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../shared/componants/constants.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: ( context,  state) {
          if (state is ShopLoginSuccessState) {
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
        builder: (BuildContext context, ShopLoginStates state) {
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
                          AppString.Login,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: ColorManager.black,
                              ),
                        ),
                        Text(
                          AppString.loginNow,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: ColorManager.grey),
                        ),
                        const SizedBox(
                          height: AppSize.s30,
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
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passWordController.text,
                              );
                            }
                          },
                          isPassword: ShopLoginCubit.get(context).isPasword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
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
                          height: AppSize.s30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passWordController.text,
                                );
                              }
                            },
                            text: AppString.login,
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
