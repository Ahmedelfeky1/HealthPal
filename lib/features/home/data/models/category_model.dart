class CategoryModel {
  final int id;
  final String name;
  final String iconUrl;

  CategoryModel({required this.id, required this.name, required this.iconUrl});
  factory CategoryModel.fromJson(Map<String, dynamic> josn) {
    return CategoryModel(
      id: josn['id'],
      name: josn['name'],
      iconUrl: josn['icon_url']??'',
    );
  }
}
