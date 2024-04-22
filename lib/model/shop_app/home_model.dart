
class HomeModel{
   bool? status;
   HomeDataModel? data;

   HomeModel.fromJson(Map<String,dynamic> json){
     status = json['status'];
     data = HomeDataModel.fromJson(json['data']);
     // data = json["data"] != null ? HomeDataModel.fromJson(json["data"]): null;

   }
}
class HomeDataModel{
  List<BannerModel> banners = [];
  List<ProductModel> products = [];
  HomeDataModel.fromJson(Map<String,dynamic> json){

    if (json['banners'] is List) {
      banners = (json['banners'] as List).map((bannerJson) => BannerModel.fromJson(bannerJson)).toList();///////***************chat gpt***////***********
    }
    // json['banners'].forEach((element){
    //   banners.add(element);
    // });

    if (json['products'] is List) {
      products = (json['products'] as List).map((productJson) => ProductModel.fromJson(productJson)).toList();
    }
    // json['products'].forEach((element){
    //   products.add(element);
    // });
  }
}
class BannerModel{
  int? id;
  String? image;

BannerModel.fromJson(Map<String,dynamic> json){
  id = json['id'] as int;
  image = json['image'] as String;
}
}
class ProductModel{
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic dicount;
  String? image;
  String? name;
  bool? inFavorites;
  bool? inCart;

  ProductModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    dicount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];

  }
}