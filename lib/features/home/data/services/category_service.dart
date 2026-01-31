import 'package:doctor_appointment/features/home/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient supabaseClient;

  CategoryService(this.supabaseClient);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .order('name', ascending: true);

      return (response as List).map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
