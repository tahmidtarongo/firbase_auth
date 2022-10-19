import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/repository/category_repo.dart';

CategoryRepo categoryRepo = CategoryRepo();
final categoryProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) => categoryRepo.getAllCategory());
