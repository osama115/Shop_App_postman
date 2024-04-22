//Your API key is: f722f64ea76c41f3bd8eb904c9cda840

//https://newsapi.org/v2/everything?q=tesla&apiKey=f722f64ea76c41f3bd8eb904c9cda840



import '../../modules/shop_app/login/shop_login_screen.dart';
import '../../presentation/string_manager.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void SignOut(context){
  CacheHelper.removeData(key: AppString.token).then((value) {
    if(value){
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text){
  final pattern =RegExp('.{1,800}');///800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
String? token='';