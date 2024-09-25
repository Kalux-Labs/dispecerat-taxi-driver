import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Conectează-te ca șofer',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Introduceți numarul de telefon',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumberController,
                    enabled: state is! AuthCodeSent,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '770 313 912',
                      labelText: 'Numar de telefon',
                      prefixText: '+40 ',
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                      PhoneNumberTextInputFormatter(),
                    ],
                    validator: Validators.phoneValidator,
                  ),
                  if (state is AuthCodeSent) const SizedBox(height: 10),
                  if (state is AuthCodeSent)
                    TextFormField(
                      controller: _smsCodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  FullWidthButton(
                    onPressed: () {
                      if (state is AuthInitial ||
                          state is AuthCodeAutoRetrievalTimeout) {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationCubit>().verifyPhoneNumber(
                                '+40${_phoneNumberController.text.replaceAll(' ', '').trim()}',
                              );
                        }
                      }
                      if (state is AuthCodeSent) {
                        // final verificationId = (state as AuthCodeSent).verificationId;
                        context.read<AuthenticationCubit>().signInWithSmsCode(
                              state.verificationId,
                              _smsCodeController.text,
                            );
                      }
                    },
                    text: (state is AuthCodeSent)
                        ? 'Valideaza codul'
                        : 'Conectează-te',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
