import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infox/model/pincode_response_model.dart';
import 'package:infox/providers/pincode_provider.dart';
import 'package:infox/services/notification_services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String pinCode = "";
  NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Infox Pin Code Checker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<PinCodeProvider>(builder: (context, provider, child) {
            return Column(
              children: [
                const SizedBox(height: 10),
                TextField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: "Enter Pin Code",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    setState(() {
                      pinCode = value;
                      if (pinCode == "") {
                        provider.postOffices = null;
                      }
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!provider.isFetching) {
                      if (pinCode != "") {
                        await provider.fetchPinCodeData(pinCode);
                        notificationService.showNotification(
                          title: "Pin Code Checker",
                          content: provider.postOffices != null
                              ? "Data fetched for $pinCode"
                              : "No data found with that pin code",
                        );
                      }
                    }
                  },
                  child: provider.isFetching
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Search",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                provider.postOffices != null
                    ? ListView.separated(
                        separatorBuilder: ((context, index) => const Divider()),
                        itemCount: provider.postOffices!.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(provider.postOffices![index].name!),
                          );
                        }),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text("No Data Found"),
                      )
              ],
            );
          }),
        ),
      ),
    );
  }
}
