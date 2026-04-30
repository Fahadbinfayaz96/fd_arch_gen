import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/{{snake}}_cubit.dart';
import '../../../../core/di/injection_container.dart';  // ← Add this import

class {{Feature}}Screen extends StatelessWidget {
  const {{Feature}}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<{{Feature}}Cubit>()..fetchItems(), 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('{{Feature}}'),
        ),
        body: BlocBuilder<{{Feature}}Cubit, {{Feature}}State>(
          builder: (context, state) {
            if (state is {{Feature}}Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is {{Feature}}Error) {
              return Center(child: Text(state.message));
            }
            
            if (state is {{Feature}}Loaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.items[index].toString()),
                  );
                },
              );
            }
            
            return const Center(child: Text('{{Feature}} Screen'));
          },
        ),
      ),
    );
  }
}