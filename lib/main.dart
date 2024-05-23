import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqlite/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.manageExternalStorage.request().isGranted) {
    print("Permissão de gerenciamento de armazenamento externo concedida");
  } else {
    print("Permissão de gerenciamento de armazenamento externo negada");
  }

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD APP',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}
