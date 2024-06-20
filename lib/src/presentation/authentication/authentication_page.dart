import 'package:driver/src/business_logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:driver/src/utils/formatters/phone_number_text_input_formatter.dart';
import 'package:driver/src/utils/validators.dart';
import 'package:driver/src/utils/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Introdu numarul de telefon',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: '770 313 912',
                        labelText: 'Numar de telefon',
                        prefixText: '+40 '),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                      PhoneNumberTextInputFormatter()
                    ],
                    validator: Validators.phoneValidator,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FullWidthButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationBloc>().add(LoginUser(
                              phone:
                                  '+40${_controller.text.replaceAll(' ', '')}'));
                        }
                      },
                      text: "Conectează-te")
                ],
              ),
            )));
  }
}
