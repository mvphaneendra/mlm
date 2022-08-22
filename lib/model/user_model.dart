import 'package:advaithaunnathi/dart/const_global_objects.dart';
import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';

import '../hive/hive_boxes.dart';

class UserModel {
  int? memberPosition;
  String profileName;
  String? memberID;
  String userEmail;
  String? phoneNumber;
  String? refMemberId;
  String? profilePhotoUrl;
  DateTime? paymentTime;
  int directIncome;
  String? fcmToken;
  DocumentReference<Map<String, dynamic>>? docRef;

  UserModel({
    required this.memberPosition,
    required this.profileName,
    required this.memberID,
    required this.userEmail,
    required this.phoneNumber,
    required this.refMemberId,
    required this.profilePhotoUrl,
    required this.paymentTime,
    required this.directIncome,
    required this.fcmToken,
    this.docRef,
  });

  Map<String, dynamic> toMap() {
    return {
      umos.memberPosition: memberPosition,
      umos.profileName: profileName,
      umos.userEmail: userEmail,
      umos.phoneNumber: phoneNumber,
      umos.memberID: memberID,
      umos.refMemberId: refMemberId,
      umos.paymentTime:
          paymentTime != null ? Timestamp.fromDate(DateTime.now()) : null,
      umos.directIncome: directIncome,
      unIndexed: {
        umos.profilePhotoUrl: profilePhotoUrl,
        boxStrings.fcmToken: fcmToken,
      }
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> userMap) {
    return UserModel(
      memberPosition: userMap[umos.memberPosition],
      profileName: userMap[umos.profileName] ?? "",
      memberID: userMap[umos.memberID],
      userEmail: userMap[umos.userEmail] ?? "",
      phoneNumber: userMap[umos.phoneNumber],
      refMemberId: userMap[umos.refMemberId],
      paymentTime: userMap[umos.paymentTime]?.toDate(),
      directIncome: userMap[umos.directIncome] ?? 0,
      profilePhotoUrl: userMap[unIndexed] != null
          ? userMap[unIndexed][umos.profilePhotoUrl]
          : null,
      fcmToken: userMap[unIndexed] != null
          ? userMap[unIndexed][boxStrings.fcmToken]
          : null,
    );
  }
}

UserModelObjects umos = UserModelObjects();

class UserModelObjects {
  final memberPosition = "memberPosition";
  final profileName = "profileName";
  final memberID = "memberID";
  final userEmail = "userEmail";
  final phoneNumber = "phoneNumber";
  final refMemberId = "refMemberId";
  final profilePhotoUrl = "profilePhotoUrl";
  final downLevelEndPositions = "downLevelEndPositions";
  final directIncome = "directIncome";
  final matrixIncome = "matrixIncome";
  final directWalletHistory = "directWalletHistory";
  final matrixIncomeHistory = "matrixIncomeHistory";
  final paymentTime = "paymentTime";
  final docs = "docs";
  final payment = "payment";

  //
  String dateTime(DateTime time) {
    String ampm = DateFormat("a").format(time).toLowerCase();
    String chatDayTime = DateFormat("dd MMM").format(time);
    //
    String today = DateFormat("dd MMM").format(DateTime.now());
    // String chatDay =
    //     DateFormat("dd MMM").format(crm.lastChatModel!.senderSentTime);

    if (today == chatDayTime) {
      chatDayTime = DateFormat("h:mm").format(time) + ampm;
    }
    return chatDayTime;
  }

  Future<void> onPaymentFunctionCall(String userUID) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable("on_payment");
    await callable.call(<String>[userUID]);
  }

  Future<void> updateUserModelFields({
    int? memberPosition,
    String? profileName,
    String? memberID,
    String? userEmail,
    String? refMemberId,
    String? profilePhotoUrl,
  }) async {
    Map<String, dynamic> map = {
      umos.memberPosition: memberPosition,
      umos.profileName: profileName,
      umos.userEmail: userEmail,
      umos.memberID: memberID,
      umos.refMemberId: refMemberId,
      umos.profilePhotoUrl: profilePhotoUrl,
    };

    Map<String, dynamic> updatedMap = {};
    map.forEach((key, value) {
      if (value != null) {
        updatedMap.addAll({key: value});
      }
    });

    await authUserCR.doc(fireUser()?.uid).update(updatedMap);
  }

  Future<void> updateCartOfnonAuthUser() async {
    if (userBoxUID() != null) {
      HttpsCallable function = FirebaseFunctions.instance
          .httpsCallable('update_cart_after_nonAuth_login');
      await Future.delayed(const Duration(seconds: 3));
      await function.call(<String, dynamic>{
        "authID": fireUser()?.uid,
        "nonAuthID": userBoxUID(),
      });

      userBox.delete(boxStrings.userUID);
    }
  }

  Future<void> addPosition(String refID) async {
    HttpsCallable addPos =
        FirebaseFunctions.instance.httpsCallable('addPosition');
    await addPos.call(<String, dynamic>{
      "uid": fireUser()?.uid,
      "refMemberId": refID,
    });
  }

  Future<void> checkAndAddPos(String refID) async {
    await authUserCR.doc(fireUser()?.uid).get().then((ds) async {
      if (ds.exists && ds.data() != null) {
        var um = UserModel.fromMap(ds.data()!);
        if (um.memberPosition == null) {
          await addPosition(refID);
        }
      }
    });
  }

  Future<UserModel?> getUserModel() async {
    return await authUserCR.doc(fireUser()?.uid).get().then((ds) {
      if (ds.exists && ds.data() != null) {
        var um = UserModel.fromMap(ds.data()!);
        um.docRef = ds.reference;
        return um;
      }
      return null;
    });
  }

  DocumentReference<Map<String, dynamic>>? userDR() {
    if (fireUser() != null) {
      return authUserCR.doc(fireUser()!.uid);
    }
    return null;
  }

  Future<void> userInit() async {
    if (fireUser() != null) {
      await userDR()!.get().then((ds) async {
        if (!ds.exists || ds.data() == null) {
          userDR()!.set(UserModel(
                  memberPosition: null,
                  profileName: fireUser()?.displayName ?? "",
                  memberID: null,
                  userEmail: fireUser()?.email ?? "",
                  phoneNumber: null,
                  refMemberId: null,
                  profilePhotoUrl: fireUser()?.photoURL,
                  paymentTime: null,
                  directIncome: 0,
                  fcmToken: null)
              .toMap(), SetOptions(merge: true),);
        }
      });
    }
  }
}
