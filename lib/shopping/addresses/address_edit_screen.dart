import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/model/address_model.dart';
import 'package:advaithaunnathi/model/pin_code_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class AddressEditScreen extends StatelessWidget {
  final AddressModel? addressModel;
  const AddressEditScreen(this.addressModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    AddressValidators v = AddressValidators();
    v.name = addressModel?.name ?? "";
    v.phone = addressModel?.phone ?? "";
    v.house = addressModel?.house ?? "";

    v.pinCode = addressModel?.pinCode.toString() ?? "";

    //
    var pin = (addressModel?.pinCode ?? "").obs;
    var city = (addressModel?.pinCodeModel.city ?? "").obs;

    var listAreas = (addressModel?.pinCodeModel.listAreas ?? []).obs;
    var postOffice = (addressModel?.postOffice ?? "").obs;

    var state = (addressModel?.pinCodeModel.state ?? "").obs;
    var district = (addressModel?.pinCodeModel.district ?? "").obs;

    //
    AddressTextControllers tc = AddressTextControllers();
    tc.name.text = addressModel?.name ?? "";
    tc.phone.text = addressModel?.phone ?? "";
    tc.colony.text = addressModel?.colony ?? "";
    tc.house.text = addressModel?.house ?? "";
    tc.landmark.text = addressModel?.landmark ?? "";
    tc.pinCode.text = addressModel?.pinCode.toString() ?? "";

    //
    var formKey = GlobalKey<FormState>();

    String? editing;

    bool isAllValid() {
      return (fireUser() != null &&
          pin.value.isNotEmpty &&
          tc.phone.text.contains(RegExp(r'^[0-9]{10}$')) &&
          tc.name.text.length > 4 &&
          tc.house.text.length > 2);
    }

    void allValidate() {
      if (pin.value.isEmpty) {
        editing = "pin";
        v.pinCode = "Invalid pin";
      } else if (!tc.phone.text.contains(RegExp(r'^[0-9]{10}$'))) {
        editing = "phone";
        v.phone = "Invalid Phone number";
      } else if (tc.name.text.length < 4) {
        editing = "name";
        v.phone = "Invalid name";
      } else if (tc.house.text.length < 3) {
        editing = "house";
        v.phone = "Invalid house details";
      } else if (postOffice.value.isEmpty) {
        editing = "po";
      } else {
        editing = null;
      }
      formKey.currentState?.validate().toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
        actions: [
          TextButton(
              onPressed: () async {
                isLoading.value = true;
                if (isAllValid()) {
                  var am = AddressModel(
                      name: tc.name.text,
                      phone: tc.phone.text,
                      house: tc.house.text,
                      colony: tc.colony.text,
                      landmark: tc.colony.text,
                      pinCode: pin.value,
                      postOffice: postOffice.value,
                      updatedTime: DateTime.now(),
                      pinCodeModel: PinCodeModel(
                          isValid: true,
                          listAreas: listAreas,
                          city: city.value,
                          district: district.value,
                          state: state.value));
                  if (addressModel?.docRef != null) {
                    await addressModel!.docRef!
                        .set(am.toMap(), SetOptions(merge: true));
                  } else {
                    await addressMOs.addressCR.add(am.toMap());
                  }

                  Get.back();
                } else {
                  allValidate();
                  Get.snackbar(
                    "Error",
                    "Please fill all the required fields",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black12,
                    colorText: Colors.red,
                  );
                }
                isLoading.value = false;
              },
              child: Obx(() => isLoading.value
                  ? const GFLoader(type: GFLoaderType.circle)
                  : Text(
                      addressModel != null ? "Update" : "Add",
                      style: const TextStyle(color: Colors.white),
                    )))
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Reciever Name*',
                  ),
                  controller: tc.name,
                  validator: (value) {
                    if (editing == "name") {
                      return v.name;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length < 5) {
                      editing = "name";
                      v.name = "Please enter valid name";
                      formKey.currentState?.validate().toString();
                    } else if (editing != null) {
                      editing = null;
                      formKey.currentState?.validate().toString();
                    }
                  },
                ),
                //
                //
                TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Reciever Phone number*',
                    counterText: "",
                  ),
                  controller: tc.phone,
                  validator: (value) {
                    if (editing == "phone") {
                      return v.phone;
                    }
                    return null;
                  },
                  onChanged: (txt) {
                    if (!txt.contains(RegExp(r'^[0-9]{10}$'))) {
                      editing = "phone";
                      v.phone = "Please enter valid Phone number";
                      formKey.currentState?.validate().toString();
                    } else if (editing != null) {
                      editing = null;
                      formKey.currentState?.validate().toString();
                    }
                  },
                ),

                //
                TextFormField(
                  controller: tc.house,
                  decoration: const InputDecoration(
                    labelText: 'House No, Street name etc *',
                  ),
                  validator: (value) {
                    if (editing == "house") {
                      return v.house;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length < 5) {
                      editing = "house";
                      v.house = "Please enter valid address";
                      formKey.currentState?.validate().toString();
                    } else if (editing != null) {
                      editing = null;
                      formKey.currentState?.validate().toString();
                    }
                  },
                ),

                //
                TextFormField(
                  controller: tc.colony,
                  decoration: const InputDecoration(
                    // hintText: 'Please enter your referer ID',
                    labelText: 'Colony',
                  ),
                ),

                //
                TextFormField(
                  controller: tc.landmark,
                  decoration: const InputDecoration(
                    // hintText: 'Please enter your referer ID',
                    labelText: 'Landamark',
                  ),
                ),
                //
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          maxLength: 6,
                          controller: tc.pinCode,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Pin',
                              labelText: 'Pin code*',
                              counterText: ""),
                          validator: (value) {
                            if (editing == "pin") {
                              return v.pinCode;
                            }
                            return null;
                          },
                          onChanged: (txt) async {
                            pin.value = "";
                            if (txt.length == 6 &&
                                txt.contains(RegExp(r'^[0-9]{6}$'))) {
                              //
                              editing = "pin";
                              v.pinCode = "Please wait...";
                              formKey.currentState?.validate().toString();

                              //
                              var pinM = await getPinModel(int.parse(txt));
                              if (pinM?.isValid ?? false) {
                                //
                                editing = null;
                                v.pinCode = "";
                                formKey.currentState?.validate().toString();
                                //

                                pin.value = txt;
                                listAreas.value = pinM!.listAreas ?? [];
                                city.value = pinM.city ?? "";
                                district.value = pinM.district ?? "";
                                state.value = pinM.state ?? "";
                              } else {
                                editing = "pin";
                                v.pinCode = "Pin not exist";
                                formKey.currentState?.validate().toString();
                              }
                            } else {
                              editing = "pin";
                              v.pinCode = "Invalid Pin";
                              formKey.currentState?.validate().toString();
                            }
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Obx(() => DropdownButtonFormField(
                            value:
                                listAreas.isNotEmpty ? listAreas.first : null,
                            validator: (po) {
                              if (editing == "po") {
                                return "Select post office";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Post office*",
                              // enabledBorder: OutlineInputBorder(),
                            ),
                            items: listAreas
                                .map((e) => DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) {
                              editing = null;
                              postOffice.value = v?.toString() ?? "";
                            },
                          )),
                    ),
                  ],
                ),
                Obx(() {
                  var cityTC = TextEditingController(text: city.value);
                  cityTC.selection = TextSelection.fromPosition(
                      TextPosition(offset: city.value.length));
                  return TextField(
                    readOnly: true,
                    controller: cityTC,
                    decoration: const InputDecoration(
                      labelText: 'City*',
                    ),
                  );
                }),

                //
                Row(
                  children: [
                    Obx(() => Expanded(
                          flex: 1,
                          child: TextField(
                            readOnly: true,
                            controller:
                                TextEditingController(text: district.value),
                            decoration: const InputDecoration(
                              // hintText: 'Please enter your referer ID',
                              labelText: 'District*',
                            ),
                          ),
                        )),
                    const SizedBox(width: 10),
                    //
                    Obx(() => Expanded(
                          flex: 1,
                          child: TextField(
                            readOnly: true,
                            controller:
                                TextEditingController(text: state.value),
                            decoration: const InputDecoration(
                              // hintText: 'Please enter your referer ID',
                              labelText: 'State*',
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddressTextControllers {
  var name = TextEditingController();
  var phone = TextEditingController();
  var house = TextEditingController();
  var colony = TextEditingController();

  var landmark = TextEditingController();

  var pinCode = TextEditingController();
}

class AddressValidators {
  var name = "";
  var phone = "";
  var house = "";

  var pinCode = "";
}
