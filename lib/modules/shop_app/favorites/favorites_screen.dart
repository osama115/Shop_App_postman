import 'package:shop_app_api_2/model/shop_app/favorites_model.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../presentation/color_manager.dart';
import '../../../presentation/string_manager.dart';
import '../../../shared/componants/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context,state){
          return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder:(context)=> ListView.separated(
              itemBuilder: (context ,index)=> buildListProduct(ShopCubit.get(context).favoritesModel!.data!.data![index].product,context),
              separatorBuilder: (context ,index)=>myDivider(),
              itemCount:ShopCubit.get(context).favoritesModel!.data!.data!.length,
            ),
            fallback: (context) =>Center(child: CircularProgressIndicator()),
          );
        }
    );
  }
}
