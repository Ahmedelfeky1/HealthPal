import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/home/data/models/category_model.dart';
import 'package:doctor_appointment/features/home/data/services/category_service.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService categoryService;
  CategoryCubit(this.categoryService) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());

    try {
      final categories = await categoryService.getCategories();
      emit(CategorySuccess(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
