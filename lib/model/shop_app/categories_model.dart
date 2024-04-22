class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel>? data = [];

  CategoriesDataModel.fromJson(Map<String, dynamic> json){
 currentPage =json['current_page'];

 if (json['data'] is List) {
   data = (json['data'] as List).map((dataJson) => DataModel.fromJson(dataJson)).toList();///////***************chat gpt***////***********
 }
  }
}
class DataModel{
  int? id;
  String? name;
  String? image;
  DataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }


}
