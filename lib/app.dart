import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/network/api_client.dart';
import 'package:mobile/network/api_util.dart';
import 'package:mobile/repo/auth_repo.dart';

import 'page/login/login_page.dart';
import 'repo/table_repo.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ApiClient? _apiClient;

  @override
  void initState() {
    _setupApiClient();

    super.initState();
  }

  void _setupApiClient() async {
    _apiClient = ApiUtil.apiClient;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (_apiClient == null) {
      return MaterialApp(
        builder: (context, widget) {
          return Container(color: Colors.white);
        },
      );
    }
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthRepo>(create: (context) {
          return AuthRepo(_apiClient!);
        }),
        RepositoryProvider<ITableRepo>(create: (context) {
          return TableRepo(_apiClient!);
        }),
        // RepositoryProvider<UserRepository>(create: (context) {
        //   return UserRepositoryImpl(apiClient: _apiClient!);
        // }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
