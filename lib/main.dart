import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/bloc/qr_pair/qr_pair_cubit.dart';
import 'package:path_support/config/hive_setup.dart';
import 'package:path_support/view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSetup.hiveInitialization();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QrPairCubit>(
          create: (BuildContext context) => QrPairCubit(),
        ),
        BlocProvider<GuideCubit>(
          create: (BuildContext context) => GuideCubit(),
        ),
      ],
      child: const MaterialApp(
        title: 'Path Support',
        home: HomePage(),
      ),
    );
  }
}
