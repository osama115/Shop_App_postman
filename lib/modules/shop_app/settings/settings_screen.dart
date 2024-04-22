import 'package:shop_app_api_2/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_api_2/layout/shop_app/cubit/states.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/componants/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
 var formKey =GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // if(state is ShopSuccessUserDataState){
        //   nameController.text = state.shopLoginModel.data!.name!;
        //   emailController.text = state.shopLoginModel.data!.email!;
        //   phoneController.text = state.shopLoginModel.data!.phone!;
        // }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model!.data!.email!;
        phoneController.text = model!.data!.phone!;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(AppSize.s20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is ShopLoadingUpdateUserState)
                  LinearProgressIndicator(),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  defualtFormField(
                    controller: nameController,
                    inputType: TextInputType.name,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return AppString.nameMustNotBeEmpty;
                      }
                      return null;
                    },
                    labelText: 'Name',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  defualtFormField(
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return AppString.emailAddressMustNotBeEmpty;
                      }
                      return null;
                    },
                    labelText: 'Email Address',
                    prefix: Icons.email,
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  defualtFormField(
                    controller: phoneController,
                    inputType: TextInputType.phone,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return AppString.phoneNumberMustNotBeEmpty;
                      }
                      return null;
                    },
                    labelText: 'Phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  defaultButton(
                    function: () {
                      if(formKey.currentState!.validate()){
                        ShopCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }
                    },
                    text: AppString.update,
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  defaultButton(
                    function: () {
                      SignOut(context);
                    },
                    text: AppString.logout,
                  )
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
