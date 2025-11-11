import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_event.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/main_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadBloc()..add(FetchImagesEvent()), // <-- initializes Firestore data on startup
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const MainHomeScreen(),
      ),
    );
  }
}


