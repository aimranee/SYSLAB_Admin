import 'package:syslab_admin/service/appointmentService.dart';
import 'package:syslab_admin/service/notificationService.dart';
import 'package:syslab_admin/model/appointmentModel.dart';
import 'package:syslab_admin/model/notificationModel.dart';
import 'package:syslab_admin/service/Notification/handleFirebaseNotification.dart';
import 'package:syslab_admin/service/updateData.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
import 'package:syslab_admin/utilities///ToastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  final firstName;
  final lastName;
  final phoneNumber;
  final email;
  final age;
  final selectedGender;
  final city;
  final des;
  final serviceName;
  final serviceTimeMin;
  final setTime;
  final selectedDate;
  final uName;
  final uId;
  final userFcmId;
  ConfirmationPage(
      {Key key,
      this.serviceTimeMin,
      this.setTime,
      this.selectedDate,
      this.serviceName,
      this.phoneNumber,
      this.lastName,
      this.email,
      this.firstName,
      this.city,
      this.age,
      this.des,
      this.selectedGender,
      this.uId,
      this.uName,
      this.userFcmId})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String _adminFCMid;
  bool _isLoading = false;
  String _isBtnDisable = "false";
  String _uId = "";
  String _uName = "";
  String _userFCMid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _uId = widget.uId;
      _uName = widget.firstName + " " + widget.lastName;
      _userFCMid = widget.userFcmId;
    });
    _setAdminFcmId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IAppBars.commonAppBar(context, "Confirm"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: _isBtnDisable=="false"true:false,
        title: "Confirm Appointment",
        onPressed: () {
          //  Service.myfb(); //if you want to add something in all documents of one collection then you can invoke this method. this is for only the developing part.
          _updateBookedSlot(); // Method handles all the booking system operation.
        },
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                  child: _isLoading
                       Center(child: LoadingIndicatorWidget())
                      : Center(
                          child: Container(
                              height: 250,
                              width: double.infinity,
                              child: _cardView()),
                        )),
            ],
          ),
        ),
      ),
    );

    //    Container(
    //       color: bgColor,
    //       child: _isLoading
    //            Center(child: CircularProgressIndicator())
    //           : Center(
    //               child: Container(
    //                   height: 250,
    //                   width: double.infinity,
    //                   child: _cardView(patientDetailsArgs)),
    //             )),
    // );
  }

  Widget _cardView() {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: btnColor,
              ),
              child: Center(
                child: Text(
                  "Please Confirm All Details",
                  style: TextStyle(
                    fontFamily: 'OpenSans-SemiBold',
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Divider(),
            Text(
              "Patient Name - ${widget.firstName} " + "${widget.lastName}",
              style: kCardSubTitleStyle,
            ),
            SizedBox(height: 10),
            Text("Service Name - ${widget.serviceName}",
                style: kCardSubTitleStyle),
            SizedBox(height: 10),
            Text("Service Time - ${widget.serviceTimeMin} Minute",
                style: kCardSubTitleStyle),
            SizedBox(height: 10),
            Text("Date - ${widget.selectedDate}", style: kCardSubTitleStyle),
            SizedBox(height: 10),
            Text("Time - ${widget.setTime}", style: kCardSubTitleStyle),
            SizedBox(height: 10),
            Text("Mobile Number - ${widget.phoneNumber}",
                style: kCardSubTitleStyle)
          ],
        ),
      ),
    );
  }

  void _updateBookedSlot() async {
    setState(() {
      _isLoading = true;
      _isBtnDisable = "";
    });
    final pattern = RegExp('\\s+'); //remove all space
    final patientName = widget.firstName + widget.lastName;
    String searchByName = patientName
        .toLowerCase()
        .replaceAll(pattern, ""); //lowercase all letter and remove all space

    final appointmentModel = AppointmentModel(
        pFirstName: widget.firstName,
        pLastName: widget.lastName,
        pPhn: widget.phoneNumber,
        pEmail: widget.email,
        age: widget.age,
        gender: widget.selectedGender,
        pCity: widget.city,
        description: widget.des,
        serviceName: widget.serviceName,
        serviceTimeMin: widget.serviceTimeMin,
        appointmentTime: widget.setTime,
        appointmentDate: widget.selectedDate,
        appointmentStatus: "Pending",
        searchByName: searchByName,
        uId: _uId,
        uName: _uName); //initialize all values
    final insertStatus = await AppointmentService.addData(appointmentModel);

    if (insertStatus != "error") {
      print(":::::::::::::::::::::;$insertStatus");
      final updatedTimeSlotsStatus = await UpdateData.updateTimeSlot(
          widget.serviceTimeMin,
          widget.setTime,
          widget.selectedDate,
          insertStatus);
      //if appoint details added successfully added
      // if (updatedTimeSlotsStatus == "") {
      //   final notificationModel = NotificationModel(
      //       title: "Successfully Booked",
      //       body:
      //           "Appointment has been booked on ${widget.selectedDate}. Waiting for confirmation",
      //       uId: _uId,
      //       routeTo: "/Appointmentstatus",
      //       sendBy: "user",
      //       sendFrom: _uName,
      //       sendTo: "Admin");
      //   final notificationModelForAdmin = NotificationModel(
      //       title: "New Appointment",
      //       body:
      //           "${widget.firstName} ${widget.lastName} booked an appointment on ${widget.selectedDate} at ${widget.setTime}",
      //       uId: _uId,
      //       sendBy: _uName);

      //   final msgAdded = await NotificationService.addData(notificationModel);

      //   if (msgAdded == "success") {
      //     await NotificationService.addDataForAdmin(notificationModelForAdmin);
      //     //ToastMsg.showToastMsg("Successfully Booked");
      //     // _handleSendNotification(widget.firstName, widget.lastName,
      //     //     widget.serviceName, widget.selectedDate, widget.setTime);
      //     // Navigator.of(context).pushNamedAndRemoveUntil(
      //     //     '/UsersListPage', ModalRoute.withName('/'));
      //   } else if (msgAdded == "error") {
      //     //ToastMsg.showToastMsg("Something went wrong. try again");
      //     Navigator.pop(context);
      //   }
      // } else {
      //   //ToastMsg.showToastMsg("Something went wrong. try again");
      //   Navigator.pop(context);
      // }
    } else {
      //ToastMsg.showToastMsg("Something went wrong. try again");
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
      _isBtnDisable = "false";
    });
  }

  void _setAdminFcmId() async {
    //loading if data till data fetched
    setState(() {
      _isLoading = true;
    });
    //fetch admin fcm id for sending messages to admin
    final fcmId = await FirebaseMessaging.instance.getToken();
    setState(() {
      _adminFCMid = fcmId;
    });
    setState(() {
      _isLoading = false;
    });
  }

  // void _handleSendNotification(String firstName, String lastName,
  //     String serviceName, String selectedDate, String setTime) async {
  //   //send notification to user
  //   await HandleFirebaseNotification.sendPushMessage(
  //     _userFCMid, //admin fcm
  //     "Successfully Booked", //title
  //     "Appointment has been booked on $selectedDate. Waiting for confirmation", // body
  //   );
  //   await UpdateData.updateIsAnyNotification("usersList", _uId, true);

  //   //send notification to admin app for booking confirmation
  //   print("++++++++++++admin$_adminFCMid");
  //   await HandleFirebaseNotification.sendPushMessage(
  //       _adminFCMid, //admin fcm
  //       "New Appointment", //title
  //       "$firstName $lastName booked an appointment on $selectedDate at $setTime" //body
  //       );

  //   await UpdateData.updateIsAnyNotification("profile", "profile", true);
  // }
}
