import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_api/models/users_model.dart';
import 'package:store_api/widgets/users_widget.dart';

import '../services/api_handler.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: FutureBuilder<List<UsersModel>>(
        future: ApiHandler.getAllUSers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          } else if (snapshot.hasError) {
            Center(child: Text("An Error Occured ${snapshot.error}"));
          } else if (snapshot.data == null) {
            const Center(child: Text("No Products"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: snapshot.data![index],
                child: const UsersWidget(),
              );
            },
          );
        },
      ),
    );
  }
}
