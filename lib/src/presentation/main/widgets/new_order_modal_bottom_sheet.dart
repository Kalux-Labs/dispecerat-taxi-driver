import 'dart:async';

import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/utils/utils.dart';
import 'package:driver/src/utils/widgets/full_width_button.dart';
import 'package:driver/src/utils/widgets/full_width_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewOrderModalBottomSheet extends StatefulWidget {
  const NewOrderModalBottomSheet({super.key});

  @override
  State<NewOrderModalBottomSheet> createState() =>
      _NewOrderModalBottomSheetState();
}

class _NewOrderModalBottomSheetState extends State<NewOrderModalBottomSheet> {
  int _currentSeconds = 10;
  late Timer _timer;

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            _currentSeconds--;
          });
        }
      });
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
        listener: (BuildContext context, OrderState state) {},
        builder: (BuildContext context, OrderState state) {
          if (state is OrderReceived) {
            return SizedBox.expand(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Comanda noua",
                        style: Theme.of(context).textTheme.titleLarge),
                    ListTile(
                        leading: Icon(Icons.pin_drop),
                        title: Text("Adresa de preluare"),
                        subtitle: Text(state.order.place?.address ?? "")),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text("Numar de telefon"),
                      subtitle: Text(state.order.phone),
                      onTap: () {
                        Utils.initiatePhoneCall(state.order.phone);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        "Mai ai ${_currentSeconds} secunde sa accepti comanda."),
                    const Spacer(),
                    FullWidthFilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<OrderCubit>().acceptOrder();
                        },
                        text: "Accepta comanda")
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        });
  }
}
