import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/constants/app_constant.dart';
import 'package:mobile/extension/number_extension.dart';
import 'package:mobile/model/entity/table_entity.dart';
import 'package:mobile/page/home/home_state.dart';
import 'package:mobile/page/login/login_page.dart';
import 'package:mobile/repo/table_repo.dart';
import 'package:mobile/utils/logger.dart';

import '../table/table_page.dart';
import 'home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (cxt) {
        final _repo = RepositoryProvider.of<ITableRepo>(context);
        return HomeCubit(_repo);
      },
      child: HomePageChild(),
    );
  }
}

class HomePageChild extends StatefulWidget {
  const HomePageChild({Key? key}) : super(key: key);

  @override
  State<HomePageChild> createState() => _HomePageChildState();
}

class _HomePageChildState extends State<HomePageChild> {
  late HomeCubit _cubit;
  @override
  void initState() {
    _cubit = BlocProvider.of(context);
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildTablesGrid(),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      color: const Color(0xFF004D40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.green, size: 16),
                SizedBox(width: 6),
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.tables.length != current.tables.length,
                  builder: (context, state) {
                    return Text(
                      state.username ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.tables.length != current.tables.length,
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: state.tables.length,
          itemBuilder: (context, index) {
            final data = state.tables[index];

            return _buildTableItem(data);
          },
        );
      },
    );
  }

  Widget _buildTableItem(TableEntity table) {
    Color borderColor = Colors.blue;
    Color textColor = const Color(0xFF004D40);
    Color? backgroundColor;

    switch (table.status) {
      case AppConstant.TABLE_USING:
        textColor = Colors.grey;
        backgroundColor = const Color(0xFFF5F5F5);
        break;
      case AppConstant.TABLE_EMPTY:
        backgroundColor = Colors.white;
        textColor = Colors.black87;
        break;
    }

    return InkWell(
      onTap: () {
        if (table.userName != _cubit.state.username &&
            (table.userName != null && table.userName != "")) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("thông báo"),
                content:
                    Text("Bạn không được phép vào bàn của ${table.userName}"),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrderScreen(
                        table: table,
                      )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            // Price at the top
            if (table.amount != 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    table.amount.formatMoney(),
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

            // Table number
            Expanded(
              child: Center(
                child: Text(
                  table.code.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Table icon

            // Time and customer name
            if (table.userName != '' && table.userName != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  table.userName ?? "",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              _cubit.fillter(fillter: AppConstant.TRONG_NHA);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              alignment: Alignment.center,
                              child: Text("Trong nhà"),
                            ),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              _cubit.fillter(fillter: AppConstant.NGOAI_NHA);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              alignment: Alignment.center,
                              child: Text("Ngoài nhà"),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _cubit.init();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          alignment: Alignment.center,
                          child: Text("Tất cả"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        color: const Color(0xFF004D40),
        child: const Text(
          'Khu vực: Nhà hàng',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
