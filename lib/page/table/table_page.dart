import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/constants/app_constant.dart';
import 'package:mobile/extension/number_extension.dart';
import 'package:mobile/extension/textstyle_extension.dart';
import 'package:mobile/model/entity/order_temp_entity.dart';
import 'package:mobile/page/home/home_page.dart';
import 'package:mobile/page/table/table_state.dart';
import 'package:mobile/repo/order_temp_repo.dart';
import 'package:mobile/repo/product_repo.dart';
import 'package:mobile/utils/order_item_utils.dart';

import '../../model/entity/table_entity.dart';
import 'table_cubit.dart';

class OrderScreen extends StatelessWidget {
  final TableEntity table;
  const OrderScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final _repoOrderTemp = RepositoryProvider.of<IOrderTempRepo>(context);
        final _repoProduct = RepositoryProvider.of<IProductRepo>(context);
        return TableCubit(_repoOrderTemp, _repoProduct);
      },
      child: OrderScreenChild(
        table: table,
      ),
    );
  }
}

class OrderScreenChild extends StatefulWidget {
  final TableEntity table;
  const OrderScreenChild({super.key, required this.table});

  @override
  State<OrderScreenChild> createState() => _OrderScreenChildState();
}

class _OrderScreenChildState extends State<OrderScreenChild> {
  late TableCubit _cubit;
  @override
  void initState() {
    _cubit = BlocProvider.of(context);
    _cubit.init(id: widget.table.tableId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        title:
            Text('${widget.table.code}', style: TextStyle(color: Colors.white)),
        actions: [],
      ),
      body: Column(
        children: [
          // Cart items list
          BlocBuilder<TableCubit, TableState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.ordersTemp.length != current.ordersTemp.length,
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.ordersTemp.length,
                  itemBuilder: (ctx, index) {
                    final item = state.ordersTemp[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          title: Column(
                            children: [
                              Text(
                                "${item.quantity} x ${item.hiveId!.substring(0, 3)} ${item.product?.name}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: item.extras?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final extra = item.extras?[index];
                                  return Text(
                                      "+ ${extra?.name}  ${extra?.price.formatMoney()}");
                                },
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.product!.price.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                (item.product!.price! * item.quantity!)
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Total amount
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    BlocBuilder<TableCubit, TableState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return Text(
                          state.total.formatMoney(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category buttons
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF004D40),
              border: Border(
                top: BorderSide(color: Colors.grey.shade800, width: 1),
              ),
            ),
            child: Row(
              children: [
                // _buildCategoryButton(Icons.restaurant, 'Khai vị'),
                _buildCategoryButton(Icons.fastfood, 'Món chính', () {
                  _cubit.fillterProduct(fillter: AppConstant.THUC_AN);
                }),
                // _buildCategoryButton(Icons.icecream, 'Tráng miệng'),
                _buildCategoryButton(Icons.local_drink, 'Đồ uống', () {
                  _cubit.fillterProduct(fillter: AppConstant.NUOC);
                }),
              ],
            ),
          ),

          // Food items grid
          BlocBuilder<TableCubit, TableState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: state.productFiltter.length,
                  itemBuilder: (context, index) {
                    final product = state.productFiltter[index];
                    return FoodItemTile(
                      name: product.name!,
                      callBack: () {
                        if (product.extras?.length != 0) {
                          showDialog(
                            useRootNavigator: false,
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              List<Extras> _extra = [];
                              return StatefulBuilder(
                                  builder: (context, statefulBuilder) {
                                return Dialog(
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      product.extras?.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var extra =
                                                        product.extras![index];
                                                    extra.quantity = 1;
                                                    extra.total = extra.price;

                                                    return InkWell(
                                                      onTap: () {
                                                        statefulBuilder(() {
                                                          _extra.add(extra);
                                                        });
                                                      },
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 60,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: _extra
                                                                      .contains(
                                                                          extra)
                                                                  ? Color(
                                                                      0xFF004D40)
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            color: _extra
                                                                    .contains(
                                                                        extra)
                                                                ? Color(
                                                                    0xFF004D40)
                                                                : Colors.white,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              extra.name!.w400(
                                                                  fontSize: 20,
                                                                  color: _extra
                                                                          .contains(
                                                                              extra)
                                                                      ? Colors
                                                                          .white
                                                                      : Color(
                                                                          0xFF004D40)),
                                                              extra.price.formatMoney().w400(
                                                                  fontSize: 20,
                                                                  color: _extra
                                                                          .contains(
                                                                              extra)
                                                                      ? Colors
                                                                          .white
                                                                      : Color(
                                                                          0xFF004D40))
                                                            ],
                                                          )),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              OrderTempEntity order =
                                                  OrderItemUtils
                                                      .createOrderTemp(
                                                          product: product,
                                                          tableId: widget
                                                              .table.tableId!,
                                                          quantity: 1,
                                                          extras: _extra,
                                                          username:
                                                              state.username,
                                                          position: 0);
                                              _cubit.addOrderTemp(
                                                  order: order,
                                                  tableId:
                                                      widget.table.tableId!);
                                              _cubit.init(
                                                  id: widget.table.tableId!);
                                            },
                                            child: Container(
                                              height: 70,
                                              width: 120,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF004D40)),
                                              child: "Order".w400(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        } else {
                          OrderTempEntity order =
                              OrderItemUtils.createOrderTemp(
                                  product: product,
                                  tableId: widget.table.tableId!,
                                  quantity: 1,
                                  username: state.username,
                                  position: 0);
                          _cubit.addOrderTemp(
                              order: order, tableId: widget.table.tableId!);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),

          // Bottom buttons
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF004D40),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await _cubit.order(table: widget.table).then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomePage()));
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Đặt hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
      IconData icon, String label, VoidCallback? onTap) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
        ),
        child: TextButton.icon(
          onPressed: () {
            onTap?.call();
          },
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF004D40),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

class FoodItemTile extends StatelessWidget {
  final String name;
  final VoidCallback? callBack;
  const FoodItemTile({Key? key, required this.name, this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextButton(
        onPressed: () {
          callBack?.call();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.all(8),
        ),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
