import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/brick/models/lookbook.model.dart';

class LookbookController {
  final AppRepository _appRepository;

  LookbookController(this._appRepository);

  Future<List<Lookbook>> fetchLookbookItems() async {
    try {
      return await _appRepository.get<Lookbook>();
    } catch (e) {
      throw Exception('Failed to fetch lookbook items: $e');
    }
  }
}
