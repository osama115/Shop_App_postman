import 'package:bloc/bloc.dart';
import 'package:shop_app_api_2/layout/shop_app/cubit/states.dart';
import 'package:shop_app_api_2/model/shop_app/categories_model.dart';
import 'package:shop_app_api_2/model/shop_app/change_favorites_model.dart';
import 'package:shop_app_api_2/model/shop_app/favorites_model.dart';
import 'package:shop_app_api_2/model/shop_app/home_model.dart';
import 'package:shop_app_api_2/model/shop_app/login_model.dart';
import 'package:shop_app_api_2/shared/componants/constants.dart';
import 'package:shop_app_api_2/shared/network/end_points.dart';
import 'package:shop_app_api_2/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/shop_app/categories/categories_screen.dart';
import '../../../modules/shop_app/favorites/favorites_screen.dart';
import '../../../modules/shop_app/products/products_screen.dart';
import '../../../modules/shop_app/settings/settings_screen.dart';
import '../../../presentation/values_manager.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopIntialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = AppSize.si0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int?, bool?>? favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
      query: {},
    ).then((value) {
      // print(value!.data);
      Map<String, dynamic> jsonData = value!.data;
      homeModel = HomeModel.fromJson(jsonData);
      // printFullText((homeModel!.data!.banners![0].image)??'');
      // printFullText(homeModel.toString());
      // print(homeModel!.status);
      homeModel!.data!.products.forEach((element) {
        favorites?.addAll({element.id: element.inFavorites});
      });
      print(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
      query: {},
    ).then((value) {
      // print(value!.data);
      Map<String, dynamic> jsonData = value!.data;
      categoriesModel = CategoriesModel.fromJson(jsonData);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int? productId) {
    favorites?[productId] = !favorites![productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromjson(value!.data);
      print(value.data);

      if (changeFavoritesModel!.status = false) {
        favorites?[productId] = !favorites![productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites?[productId] = !favorites![productId]!;

      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
      query: {},
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value!.data);
      // printFullText(value!.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
      query: {},
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value!.data);
      printFullText(userModel!.data!.name ?? '');
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
}) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      query: {},
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value!.data);
      printFullText(userModel!.data!.name ?? '');
      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
