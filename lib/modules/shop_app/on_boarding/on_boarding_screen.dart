import 'package:shop_app_api_2/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app_api_2/presentation/assets_manager.dart';
import 'package:shop_app_api_2/presentation/color_manager.dart';
import 'package:shop_app_api_2/presentation/string_manager.dart';
import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/componants/components.dart';
import 'package:shop_app_api_2/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class boardingModel {
  final String image;
  final String title;
  final String body;

  boardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingsScreen extends StatefulWidget {
  OnBoardingsScreen({super.key});

  @override
  State<OnBoardingsScreen> createState() => _OnBoardingsScreenState();
}

class _OnBoardingsScreenState extends State<OnBoardingsScreen> {
  var boarController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: AppString.onBoarding,
      value: true,
    ).then((value) {
      if (value) {
        navigateAndFinish(
          context,
          ShopLoginScreen(),
        );
      }
    });
  }

  List<boardingModel> baording = [
    boardingModel(
      image: ImageAssets.onBoarding1,
      title: 'on boarding 1 title',
      body: 'on boarding 1 body',
    ),
    boardingModel(
      image: ImageAssets.onBoarding1,
      title: 'on boarding 2 title',
      body: 'on boarding 2 body',
    ),
    boardingModel(
      image: ImageAssets.onBoarding1,
      title: 'on boarding 3 title',
      body: 'on boarding 3 body',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: submit,
            text: AppString.skip,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.s30),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boarController,
                onPageChanged: (int index) {
                  if (index == baording.length - AppSize.s1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(baording[index]),
                itemCount: baording.length,
              ),
            ),
            SizedBox(
              height: AppSize.s40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boarController,
                  count: baording.length,
                  effect: ExpandingDotsEffect(
                    dotColor: ColorManager.grey,
                    dotHeight: AppSize.s10,
                    expansionFactor: AppSize.s4,
                    dotWidth: AppSize.s10,
                    spacing: AppSize.s5,
                    activeDotColor: ColorManager.oran,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boarController.nextPage(
                        duration: Duration(milliseconds: AppSize.si750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(boardingModel model) => (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Image(
            image: AssetImage('${model.image}'),
          )),
          SizedBox(
            height: AppSize.s30,
          ),
          Text(
            '${model.title}',
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: AppSize.s24),
          ),
          SizedBox(
            height: AppSize.s15,
          ),
          Text(
            '${model.body}',
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: AppSize.s14),
          ),
          SizedBox(
            height: AppSize.s15,
          )
        ],
      ));
}
