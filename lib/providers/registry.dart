import 'package:pay_or_save/element/amazon/Provider/amazon_provider.dart';
import 'package:pay_or_save/element/amazon/Provider/categories_provider.dart';
import 'package:pay_or_save/providers/auth_provider.dart';
import 'package:pay_or_save/providers/info_provider.dart';
// import 'package:pay_or_save/providers/save_invest_now_provider.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pay_or_save/providers/auth_provider.dart';

final registry = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => TotalValues()),
  ChangeNotifierProvider(create: (_) => AmazonProvider()),
  ChangeNotifierProvider(create: (_) => AmzCategoriesProvider()),
  ChangeNotifierProvider(create: (_) => InfoProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  // ChangeNotifierProvider(create: (_) => SaveInvestNowProvider()),
];
