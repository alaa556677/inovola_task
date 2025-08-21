import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/style/theme.dart';
import '../features/add_expense/presentation/pages/add_expense_screen.dart';
import '../features/dashboard/presentation/pages/dashboard_screen.dart';
import 'blocProviders.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: ScreenUtilInit(
          designSize: const Size (375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child){
            return MaterialApp(
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              home: const DashboardScreen(),
              routes: {
                '/dashboard': (context) => const DashboardScreen(),
                '/add-expense': (context) => const AddExpenseScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}


