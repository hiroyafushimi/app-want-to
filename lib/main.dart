import 'package:flutter/material.dart';

import 'app.dart';
import 'services/iap_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IAPService.instance.init();
  runApp(const ActClipApp());
}
