import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/{{snake}}_bloc.dart';

class {{Feature}}Screen extends StatelessWidget {
  const {{Feature}}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{{Feature}}Bloc, {{Feature}}State>(
      builder: (context, state) {
        if (state is {{Feature}}Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is {{Feature}}Loaded) {
          return Text("Hello!");
        }
        if (state is {{Feature}}Error) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('{{Feature}} Screen'));
      },
    );
  }
}