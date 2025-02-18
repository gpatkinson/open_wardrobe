import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/data/repositories/offline_first_repository.dart';
import 'package:openwardrobe/data/repositories/outfit_repository.dart';
import 'package:openwardrobe/domain/repositories/abstract/outfit_repository.dart';
import 'package:openwardrobe/presentation/cubit/outfit_cubit.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart' show databaseFactory;

void main() async {
  if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

  await Repository.configure(databaseFactory);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OutfitRepository>(
          create: (context) => OutfitRepositoryImpl(),
        ),
      ],
      child: BlocProvider(
        create: (context) => OutfitCubit(context.read<OutfitRepository>()),
        child: MaterialApp(
          home: Scaffold(body: Center(child: Text("App Ready!"))),
        ),
      ),
    );
  }
}