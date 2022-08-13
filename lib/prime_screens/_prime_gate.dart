import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/model/user_model.dart';
import 'package:advaithaunnathi/prime_screens/prime_home_screen.dart';
import 'package:advaithaunnathi/prime_screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class PrimeGate extends StatelessWidget {
  const PrimeGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: authUserCR.doc(fireUser()?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var um = UserModel.fromMap(snapshot.data!.data()!);
          if (um.memberPosition != null) {
            return const PrimeHomeScreen();
          } else {
            return const PrimeRegistrationScreen();
          }
        }
        return const Scaffold(
            body: GFLoader(
          type: GFLoaderType.circle,
        ));

        // Render your application if authenticated
      },
    );
  }
}
