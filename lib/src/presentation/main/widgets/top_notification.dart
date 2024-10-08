import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopNotification extends StatelessWidget {
  final VoidCallback callback;
  const TopNotification({required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
        builder: (BuildContext context, OrderState state) {
      if (state is OrderReceived) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Comanda noua', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    },);
  }
}
