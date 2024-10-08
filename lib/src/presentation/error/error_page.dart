import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorPage extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? callback;
  final String? callbackText;
  const ErrorPage(
      {super.key,
      this.title,
      this.description,
      this.callback,
      this.callbackText,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title ?? '', style: Theme.of(context).textTheme.bodyLarge),
              Text(description ?? ''),
              if (callback != null)
                ElevatedButton(onPressed: callback, child: Text(callbackText!)),
            ],
          ),
        ),
      );
    },);
  }
}
