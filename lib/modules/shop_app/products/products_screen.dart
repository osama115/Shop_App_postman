import 'package:shop_app_api_2/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_api_2/layout/shop_app/cubit/states.dart';
import 'package:shop_app_api_2/model/shop_app/categories_model.dart';
import 'package:shop_app_api_2/model/shop_app/home_model.dart';
import 'package:shop_app_api_2/presentation/color_manager.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (state.model.status = false) {
            ShowToast(
              text: state.model.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel? model, CategoriesModel? categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: AppSize.s250,
                initialPage: AppSize.si0,
                viewportFraction: AppSize.s1,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: AppSize.si3),
                autoPlayAnimationDuration: Duration(seconds: AppSize.si1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: AppSize.s10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.categories,
                    style: TextStyle(
                      fontSize: AppSize.s24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s10,
                  ),
                  Container(
                    height: AppSize.s100,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoriesItem(
                          categoriesModel.data!.data![index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: AppSize.s20,
                      ),
                      itemCount: categoriesModel!.data!.data!.length,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s20,
                  ),
                  Text(
                    AppString.newProducts,
                    style: TextStyle(
                      fontSize: AppSize.s24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSize.s10,
            ),
            Container(
              color: ColorManager.grey300,
              child: GridView.count(
                mainAxisSpacing: AppSize.s1,
                crossAxisSpacing: AppSize.s1,
                childAspectRatio: 1 / 1.58,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: AppSize.si2,
                children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildGridProduct(model.data!.products[index], context),
                ),
              ),
            )
          ],
        ),
      );

  Widget buildCategoriesItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image ?? ''),
            width: AppSize.s100,
            height: AppSize.s100,
            fit: BoxFit.cover,
          ),
          Container(
            width: AppSize.s100,
            color: ColorManager.blackwith8,
            child: Text(
              model.name ?? '',
              textAlign: TextAlign.center,
              maxLines: AppSize.si1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ColorManager.white),
            ),
          )
        ],
      );

  Widget buildGridProduct(ProductModel model, context) => Container(
        color: ColorManager.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image ?? ''),
                  width: double.infinity,
                  // fit: BoxFit.cover,
                  height: AppSize.s200,
                ),
                if (model.dicount != AppSize.s0)
                  Container(
                    color: ColorManager.red,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s5),
                    child: Text(
                      AppString.DISCOUNT,
                      style: TextStyle(
                          fontSize: AppSize.s10, color: ColorManager.white),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSize.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name ?? '',
                    maxLines: AppSize.si2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: AppSize.s14, height: AppSize.s1_3),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                            fontSize: AppSize.s12,
                            color: ColorManager.defaultColor),
                      ),
                      SizedBox(
                        width: AppSize.s5,
                      ),
                      if (model.dicount != AppSize.s0)
                        Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                              fontSize: AppSize.s10,
                              color: ColorManager.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favorites![model.id]!
                                  ? ColorManager.defaultColor
                                  : ColorManager.grey,
                          radius: AppSize.s15,
                          child: Icon(
                            Icons.favorite_border,
                            size: AppSize.s14,
                            color: ColorManager.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
