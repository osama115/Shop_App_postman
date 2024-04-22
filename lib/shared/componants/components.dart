import 'package:shop_app_api_2/presentation/values_manager.dart';
import 'package:shop_app_api_2/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../presentation/color_manager.dart';
import '../../presentation/string_manager.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double raduis = AppSize.s10,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: AppSize.s40,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        color: background,
      ),
    );

Widget defaultTextButton({
  required VoidCallback function,
  required String text,

})=>TextButton(onPressed: function, child: Text(text.toUpperCase(),style: TextStyle(color: ColorManager.defaultColor),),);

Widget defualtFormField(
        {required TextEditingController controller,
        required TextInputType inputType,
        void Function(String)? onSubmit,
        void Function()? onTap,
        void Function(String)? onChanged,
        required final String? Function(String?)? validate,
        required String labelText,
        required IconData prefix,
        bool isPassword = false,
        IconData? suffix,
        void Function()? suffixPressed,
        bool isclickable = true}) =>
    TextFormField(
      controller: controller,
      enabled: isclickable,
      keyboardType: inputType,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTap,
      validator: validate,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefix),
        suffix: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

///////////////TO do App ///////////////

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSize.s20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorManager.blue,
              radius: AppSize.s40,
              child: Text(
                ' ${model['time']}',
                style: TextStyle(color: ColorManager.white),
              ),
            ),
            SizedBox(
              width: AppSize.s20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ' ${model['title']}',
                    style: TextStyle(
                        fontSize: AppSize.s18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ${model['date']}',
                    style: TextStyle(color: ColorManager.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: AppSize.s20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.check_box_outlined,
                color: ColorManager.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.archive_outlined,
                color: ColorManager.black45,
              ),
            )
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > AppSize.s0,
      builder: (BuildContext context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      fallback: (BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: AppSize.s100,
              color: ColorManager.grey,
            ),
            Text(
              AppString.noTasksYetPleaseAddSomeTasks,
              style: TextStyle(
                fontSize: AppSize.s16,
                fontWeight: FontWeight.bold,
                color: ColorManager.grey,
              ),
            )
          ],
        ),
      ),
    );

/////////news App////////////////

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: AppSize.s20),
      child: Container(
        width: double.infinity,
        height: AppSize.s1,
        color: ColorManager.grey300,
      ),
    );

// Widget buildArticlesItem(article, context) => InkWell(
//   onTap: (){
//     navigateTo(context, WebViewScreen(url:article['url']));
//   },
//   child: Padding(
//         padding: const EdgeInsets.all(AppSize.s20),
//         child: Row(
//           children: [
//             Container(
//               width: AppSize.s120,
//               height: AppSize.s120,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(AppSize.s10),
//                 image: DecorationImage(
//                   image: NetworkImage('${article['urlToImage']}'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: AppSize.s20,
//             ),
//             Expanded(
//               child: Container(
//                 height: AppSize.s120,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         '${article['title']}',
//                         style: Theme.of(context).textTheme.bodyLarge,
//                         maxLines: AppSize.si3,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Text(
//                       '${article['publishedAt']}',
//                       style: TextStyle(color: ColorManager.grey),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
// );
//
// Widget articleBuilder(list, context,{isSearch = false}) => ConditionalBuilder(
//       condition: list.length > AppSize.si0,
//       builder: (context) => ListView.separated(
//         physics: BouncingScrollPhysics(),
//         itemBuilder: (context, index) =>
//             buildArticlesItem(list[index], context),
//         separatorBuilder: (context, index) => myDivider(),
//         itemCount: AppSize.si10,
//       ),
//       fallback: (context) =>isSearch? Container() : Center(child: CircularProgressIndicator()),
//     );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    (route) => false,
    );



/////////shop app things//////
void ShowToast({
  required String? text,
  required ToastStates state
})=>
    Fluttertoast.showToast(
    msg:text ?? '' ,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: ChooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);
///enum
enum ToastStates{ SUCCESS,ERROR,WARNING}

Color ChooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = ColorManager.green;
      break;
    case ToastStates.ERROR:
      color = ColorManager.red;
      break;
    case ToastStates.WARNING:
      color = ColorManager.amber;
      break;
  }
  return color;
}

Widget buildListProduct(model,context,{bool isOldPrice = true})=> Padding(
  padding: const EdgeInsets.all(AppSize.s20),
  child: Container(
    height: AppSize.s120,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image??'' ),
              width: AppSize.s120,
              // fit: BoxFit.cover,
              height: AppSize.s120,
            ),
            if (model.discount != AppSize.s0 && isOldPrice)
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
        SizedBox(width: AppSize.s20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name??'',
                maxLines: AppSize.si2,
                overflow: TextOverflow.ellipsis,
                style:
                TextStyle(fontSize: AppSize.s14, height: AppSize.s1_3),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${model.price}',
                    style: TextStyle(
                        fontSize: AppSize.s12,
                        color: ColorManager.defaultColor),
                  ),
                  SizedBox(
                    width: AppSize.s5,
                  ),
                  if (model.discount != AppSize.s0 && isOldPrice)
                    Text(
                      '${model.oldPrice}',
                      style: TextStyle(
                          fontSize: AppSize.s10,
                          color: ColorManager.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.id);
                      // print(model.id);
                    },
                    icon: CircleAvatar(
                      backgroundColor:
                      ShopCubit.get(context).favorites![model.id]!
                          ? ColorManager.defaultColor:
                      ColorManager.grey,
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
  ),
);
