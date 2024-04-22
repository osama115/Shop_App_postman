import 'package:bloc/bloc.dart';
import 'package:shop_app_api_2/model/shop_app/search_model.dart';
import 'package:shop_app_api_2/modules/shop_app/search/cubit/states.dart';
import 'package:shop_app_api_2/shared/componants/constants.dart';
import 'package:shop_app_api_2/shared/network/end_points.dart';
import 'package:shop_app_api_2/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text':text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value!.data);
      emit(SearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
