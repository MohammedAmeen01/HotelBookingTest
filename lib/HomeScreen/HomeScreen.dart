import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:room_service_x/HomeScreen/HomeModal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  final bool _isloading = false;
  final now = DateTime.now();

  HomeModal? modal;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    // selectedStartDate = now;
    // selectedEndDate = selectedStartDate?.add(const Duration(days: 1));
    loadjsonData().then((data) {
      setState(() {
        modal = HomeModal.fromJson(data);
      });
    });
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<dynamic> loadjsonData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/homescreentest.json',
    );
    final dynamic data = jsonDecode(jsonString);
    return data;
  }

  int getListCount() {
    return modal?.roomsAvailable.length ?? 0;
  }

  IntrinsicHeight getRowContent(int index) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 8),
          Expanded(child: getColumnContent(index)),
          Text("capacity ${modal?.roomsAvailable[index].maxguests} guests"),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  IntrinsicHeight getFormatedText(String str) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 2),
          Text(
            str,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }

  Column getColumnContent(int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFormatedText(modal?.roomsAvailable[index].roomtype ?? ""),
        const SizedBox(height: 2),
        getFormatedText(
          "rs ${modal?.roomsAvailable[index].pricepernight} per night",
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  Future pickStartDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedStartDate = date;
        if (selectedEndDate == null ||
            isSameDate(selectedStartDate!, selectedEndDate!) ||
            selectedEndDate!.isBefore(selectedStartDate!)) {
          selectedEndDate = selectedStartDate!.add(const Duration(days: 1));
        }

        modal?.nightsSelected = selectedEndDate!
            .difference(selectedStartDate!)
            .inDays;
      });
    }
  }

  Future pickEndDate(BuildContext context) async {
    if (selectedStartDate == null) {
      showAlertDialog(
        context,
        "Select Check-In Date",
        "Please select your check-in date first.",
      );
      return;
    }

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedStartDate!.add(const Duration(days: 1)),
      firstDate: selectedStartDate!.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedEndDate = date;
        modal?.nightsSelected = selectedEndDate!
            .difference(selectedStartDate!)
            .inDays;
      });
    }
  }

  void showAlertDialog(
    BuildContext context,
    String alertTitle,
    String alertMessage,
  ) {
    Widget okButton = TextButton(
      child: const Text("proceed"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(alertMessage),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar navigationBar = AppBar(
      centerTitle: true,
      title: Text(modal?.pageTitle ?? ""),
      backgroundColor: Colors.white,
    );

    Expanded verticalList = Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        itemCount: getListCount() + 1,
        itemBuilder: (BuildContext context, int index) {
          return (index == 0)
              ? Row(
                  children: [
                    Column(
                      children: [
                        Text("Check-In Date"),
                        SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () => pickStartDate(context),
                          child: Text(
                            selectedStartDate == null
                                ? 'Select Date'
                                : '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        Text(
                          ((modal?.nightsSelected ?? 0) > 1)
                              ? "- Nights -"
                              : "- Night -",
                        ),
                        SizedBox(height: 4),
                        Text('${modal?.nightsSelected}'),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        Text("Check-Out Date"),
                        SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () => pickEndDate(context),
                          child: Text(
                            selectedEndDate == null
                                ? 'Select Date'
                                : '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}',
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsetsGeometry.only(top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showAlertDialog(
                            context,
                            "Great Choice!!\n**${modal?.roomsAvailable[index - 1].roomtype}**",
                            "your price for opted ${modal?.nightsSelected} night is ${modal!.nightsSelected * modal!.roomsAvailable[index - 1].pricepernight} ",
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: getRowContent(index - 1),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
        },
      ),
    );

    return Scaffold(
      appBar: navigationBar,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          verticalList,
          _isloading
              ? Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height / 2.15),
                    Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                )
              : SizedBox(height: 0),
        ],
      ),
    );
  }
}
