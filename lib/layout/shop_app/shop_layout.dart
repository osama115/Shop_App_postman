import 'package:shop_app_api_2/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_api_2/layout/shop_app/cubit/states.dart';
import 'package:shop_app_api_2/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app_api_2/modules/shop_app/search/search_screen.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:shop_app_api_2/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, ShopStates state) {},
      builder: (BuildContext context, ShopStates state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: Icon(Icons.search),
              ),],
            title: Text(AppString.salla),
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppString.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                label: AppString.categories,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: AppString.favorites,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppString.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
