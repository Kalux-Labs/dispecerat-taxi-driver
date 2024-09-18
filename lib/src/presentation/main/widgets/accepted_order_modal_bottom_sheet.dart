import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/utils/utils.dart';
import 'package:driver/src/utils/widgets/full_width_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptedOrderModalBottomSheet extends StatefulWidget {
  const AcceptedOrderModalBottomSheet({super.key});

  @override
  State<AcceptedOrderModalBottomSheet> createState() => _AcceptedOrderModalBottomSheetState();
}
class _AcceptedOrderModalBottomSheetState extends State<AcceptedOrderModalBottomSheet> {
  final DraggableScrollableController _controller = DraggableScrollableController();
  final GlobalKey<State<StatefulWidget>> _sheet = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final double currentSize = _controller.size;
    if(currentSize <= 0.05) {
      _collapse();
    }
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(size, duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      _sheet.currentWidget! as DraggableScrollableSheet;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (BuildContext context, OrderState state) {},
      builder: (BuildContext context, OrderState state) {
        if (state is OrderAccepted) {
          return PopScope(
              canPop: false,
              child: DraggableScrollableSheet(
                  key: _sheet,
                  controller: _controller,
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.7,
                  snap: true,
                  snapSizes: const <double>[0.3, 0.7],
                  shouldCloseOnMinExtent: false,
                  builder: (BuildContext context, ScrollController controller) {
                    return Material(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.all(16),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: 4,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey,),
                              ),
                            ],
                          ),
                          ListTile(
                              leading: const Icon(Icons.pin_drop),
                              title: const Text('Adresa de preluare'),
                              subtitle: Text(state.order.place?.address ?? ''),),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text('Numar de telefon'),
                            subtitle: Text(state.order.phone),
                            onTap: () {
                              Utils.initiatePhoneCall(state.order.phone);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text('Detalii'),
                            subtitle: Text(state.order.details.isNotEmpty
                                ? state.order.details
                                : 'Nu exista detalii aditionale',),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FullWidthFilledButton(
                              onPressed: () {
                                context.read<OrderCubit>().completeOrder();
                                context.read<MapCubit>().reset();
                              },
                              text: 'Finalizeaza comanda',),
                        ],
                      ),
                    );
                  },),);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
