import 'package:shop_app_api_2/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_api_2/model/shop_app/categories_model.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context,state){
        return ListView.separated(
        itemBuilder: (context ,index)=> buildCatItem(ShopCubit.get(context).categoriesModel!.data!.data![index]),
        separatorBuilder: (context ,index)=>myDivider(),
        itemCount:ShopCubit.get(context).categoriesModel!.data!.data!.length,
      );
      }
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(AppSize.s20),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image??''),
              width: AppSize.s80,
              height: AppSize.s80,
            ),
            SizedBox(
              width: AppSize.s20,
            ),
            Text(
              model.name??'',
              style:
                  TextStyle(fontSize: AppSize.s20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
