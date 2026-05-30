import 'package:flutter/material.dart';
import 'package:mediezy_tech_task/app.dart';
import 'core/network/api_client.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.instance.init();

  runApp(const ZyromateApp());
}

