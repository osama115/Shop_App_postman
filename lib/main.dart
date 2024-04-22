import 'package:bloc/bloc.dart';
import 'package:shop_app_api_2/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_api_2/layout/shop_app/shop_layout.dart';
import 'package:shop_app_api_2/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app_api_2/presentation/color_manager.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/bloc_observere.dart';
import 'package:shop_app_api_2/shared/componants/constants.dart';
import 'package:shop_app_api_2/shared/cubit/cubit.dart';
import 'package:shop_app_api_2/shared/cubit/states.dart';
import 'package:shop_app_api_2/shared/network/local/cache_helper.dart';
import 'package:shop_app_api_2/shared/network/remote/dio_helper.dart';
import 'package:shop_app_api_2/shared/styles/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'layout/news_app/cubit/cubit.dart';
// import 'layout/news_app/news_layout.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';

void main() async {
  // this widget is her to concern all thing un this method is finished and open the application
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: AppString.onBoarding);
  token = CacheHelper.getData(key:AppString.token);
  print(token);
  if(onBoarding != null)
  {
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  }else{
    widget = OnBoardingsScreen();
  }

  // print(onBoarding);

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isDark, this.startWidget});

  final bool? isDark;
  final Widget? startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //     create: (context) => NewsCubit()
        //       ..getBusniess()
        //       ..getSports()
        //       ..getScience()),
        BlocProvider(
          create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ), BlocProvider(
          create: (context) =>ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        )
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:ThemeMode.light,
                // AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,////////////////////////////////////some condition error check out
          );
        },
      ),
    );
  }
}
