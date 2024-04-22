import 'package:bloc/bloc.dart';
import 'package:shop_app_api_2/model/shop_app/login_model.dart';
import 'package:shop_app_api_2/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app_api_2/shared/network/end_points.dart';
import 'package:shop_app_api_2/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {'email': email, 'password': password},
    ).then((value) {
      print(value!.data);
      print('good\n');
      loginModel = ShopLoginModel.fromJson(value!.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error){
      print('that\'s it the error ${error.toString()}');
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix =Icons.visibility_outlined;
  bool isPasword = true;
  void changePasswordVisiability(){
    isPasword = !isPasword;
    suffix = isPasword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());

  }
}
