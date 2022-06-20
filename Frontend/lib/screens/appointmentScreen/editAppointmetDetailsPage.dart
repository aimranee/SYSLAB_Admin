import 'package:syslab_admin/model/appointmentModel.dart';
import 'package:syslab_admin/model/notificationModel.dart';
import 'package:syslab_admin/screens/appointmentScreen/chooseTimeSlotsPage.dart';
import 'package:syslab_admin/screens/prescription/prescriptionListPage.dart';
import 'package:syslab_admin/service/appointmentService.dart';
import 'package:syslab_admin/service/notificationService.dart';
import 'package:syslab_admin/service/userService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/service/Notification/handleFirebaseNotification.dart';
import 'package:syslab_admin/service/deleteData.dart';
import 'package:syslab_admin/service/updateData.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities///ToastMsg.dart';

class EditAppointmentDetailsPage extends StatefulWidget {
  final appointmentDetails;
  const EditAppointmentDetailsPage({key key, this.appointmentDetails})
      : super(key: key);
  @override
  _EditAppointmentDetailsPageState createState() =>
      _EditAppointmentDetailsPageState();
}

class _EditAppointmentDetailsPageState
    extends State<EditAppointmentDetailsPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isEnableBtn = true;
  bool _isLoading = false;
  int _groupValue = -1;
  String _selectedGender="";


  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _latsNameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _phnController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _serviceNameController = new TextEditingController();
  TextEditingController _serviceTimeController = new TextEditingController();
  TextEditingController _appointmentIdController = new TextEditingController();
  TextEditingController _uIdController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _createdDateTimeController =
  new TextEditingController();
  TextEditingController _lastUpdatedController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    //print(widget.appointmentDetails);
//initialize all input field
    _firstNameController.text = widget.appointmentDetails.pFirstName;
    _latsNameController.text = widget.appointmentDetails.pLastName;
    _ageController.text = widget.appointmentDetails.age;
    _cityController.text = widget.appointmentDetails.pCity;
    _emailController.text = widget.appointmentDetails.pEmail;
    _phnController.text = widget.appointmentDetails.pPhn;
    _dateController.text = widget.appointmentDetails.appointmentDate;
    _timeController.text = widget.appointmentDetails.appointmentTime;
    _serviceNameController.text = widget.appointmentDetails.serviceName;
    _serviceTimeController.text =
        widget.appointmentDetails.serviceTimeMin.toString();
    _appointmentIdController.text = widget.appointmentDetails.id;
    _uIdController.text = widget.appointmentDetails.uId;
    _descController.text = widget.appointmentDetails.description;
    _createdDateTimeController.text =
        widget.appointmentDetails.createdTimeStamp;
    _lastUpdatedController.text =
        widget.appointmentDetails.updatedTimeStamp;
    _selectedGender=widget.appointmentDetails.gender;

    if (widget.appointmentDetails.appointmentStatus == "Rejected"||widget.appointmentDetails.appointmentStatus == "Canceled")
      setState(() {
        _isEnableBtn = false;
      });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _timeController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _firstNameController.dispose();
    _latsNameController.dispose();
    _phnController.dispose();
    _emailController.dispose();
    _serviceNameController.dispose();
    _serviceTimeController.dispose();
    _appointmentIdController.dispose();
    _uIdController.dispose();
    _descController.dispose();
    _createdDateTimeController.dispose();
    _lastUpdatedController.dispose();
    super.dispose();
  }
  _handlePrescriptionBtn(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PrescriptionListByIDPage(
            appointmentId: widget.appointmentDetails.id,
            userId: widget.appointmentDetails.uId,
            patientName: widget.appointmentDetails.pFirstName+" "+ widget.appointmentDetails.pLastName,
            time: widget.appointmentDetails.appointmentTime,
            date: widget.appointmentDetails.appointmentDate,
            serviceName: widget.appointmentDetails.serviceName ,
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: IAppBars.commonAppBar(context, "Edit Details"),
        bottomNavigationBar: BottomNavBarWidget(
          title: widget.appointmentDetails.appointmentStatus ==
              "Visited"?"Prescription": "Update",
          onPressed:widget.appointmentDetails.appointmentStatus ==
              "Visited"?_handlePrescriptionBtn: _takeConfirmation,
          isEnableBtn:widget.appointmentDetails.appointmentStatus ==
              "Visited"?true: _isEnableBtn,
        ),
        floatingActionButton:  widget.appointmentDetails.appointmentStatus  ==
            "Rejected" ||
            widget.appointmentDetails.appointmentStatus ==
                "Visited"||
            widget.appointmentDetails.appointmentStatus =="Canceled"

            ? null: new FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: Icon(Icons.format_list_bulleted_sharp),
              onPressed: showDialogBox,
            ),
            backgroundColor:btnColor,
            onPressed: (){}
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
          key: _formKey,
          child: ListView(

              children: [
                InputFields.commonInputField(_firstNameController, "First Name", (item) {
                  return item.length > 0 ? null : "Enter first name";
                }, TextInputType.text, 1),
                InputFields.commonInputField(_latsNameController, "Last Name", (item) {
                  return item.length > 0 ? null : "Enter last name";
                }, TextInputType.text, 1),
                InputFields.readableInputField(_dateController,  "Appointment Date", 1),
                InputFields.readableInputField(_timeController,  "Appointment Time", 1),
                InputFields.readableInputField(_serviceNameController,  "Service Name", 1),
                InputFields.readableInputField(_serviceTimeController,   "Service Time", 1),
                InputFields.commonInputField(_phnController, "Mobile Number", (item) {
                  return item.length == 10
                      ? null
                      : "Enter a 10 digit mobile number";
                },  TextInputType.phone, 1),
                InputFields.commonInputField(_ageController, "Age",  (item) {
                  if(item.length>0&&item.length<=3)
                    return null;
                  else if(item.length>3)
                    return "Enter valid age";
                  else return "Enter age";
                }, TextInputType.number, 1),
                _genderDropDown(),
                InputFields.commonInputField(_emailController,  "Email",   (item) {
                  Pattern pattern =
                      r"^[a-zA-Z0-9.#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?)*$";
                  RegExp regex =  RegExp(pattern.toString());
                  if(item.length>0){
                    if (regex.hasMatch(item) || item == null)
                      return 'Enter a valid email address';
                    else
                      return null;
                  }else return null;

                },TextInputType.emailAddress, 1),
                InputFields.commonInputField(_cityController,  "City", (item) {
                  return item.length > 0 ? null : "Enter a city name";
                },TextInputType.text, 1),
                InputFields.readableInputField(_appointmentIdController,  "Appointment id", 1),
                InputFields.readableInputField(_uIdController, "User Id", 1),
                InputFields.readableInputField(_createdDateTimeController, "Created on", 1),
                InputFields.readableInputField(_lastUpdatedController, "Last Update On", 1),
                InputFields.commonInputField(_descController, "Description, About problem", (item) {
                  if (item.isEmpty)
                    return null;
                  else {
                    return item.length > 0
                        ? null
                        : "Enter Description";
                  }
                }, TextInputType.text, 5),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      Text("Appointment Status:     "),
                      if ( widget.appointmentDetails.appointmentStatus  ==
                          "Confirmed")
                        _statusIndicator(Colors.green)
                      else if ( widget.appointmentDetails.appointmentStatus  ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (
                        widget.appointmentDetails.appointmentStatus  ==
                            "Rejected")
                          _statusIndicator(Colors.red)
                        else if (
                          widget.appointmentDetails.appointmentStatus  ==
                              "Rescheduled")
                            _statusIndicator(Colors.orangeAccent)
                          else
                            Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                            "${ widget.appointmentDetails.appointmentStatus }",
                            style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 15,
                            )),
                      ),
                    ],
                  ),
                ),
                widget.appointmentDetails.appointmentStatus == "Rejected"||
                    widget.appointmentDetails.appointmentStatus ==
                        "Visited"||
                    widget.appointmentDetails.appointmentStatus =="Canceled"
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                      "Sorry You can not edit this appointment"),
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Divider(),
                ),
                // widget.appointmentDetails.appointmentStatus ==
                //             "Rejected" ||
                //     widget.appointmentDetails.appointmentStatus ==
                //             "Done"
                //     ? Container()
                //     : _roundedDoneBtn("Done", "Done"),
                // widget.appointmentDetails.appointmentStatus ==
                //             "Rejected" ||
                //     widget.appointmentDetails.appointmentStatus ==
                //             "Done"
                //     ? //if rejected then not show anything, now user have to make a new appointment
                //     Container()
                //     : Row(
                //         //if not rejected
                //         children: [
                //           Expanded(
                //               flex: 1,
                //               child: _roundedBtn("Confirmed", "Confirmed")),
                //           Expanded(
                //               flex: 1,
                //               child: _roundedBtn("Pending", "Pending")),
                //         ],
                //       ),
                // widget.appointmentDetails.appointmentStatus  ==
                //             "Rejected" ||
                //     widget.appointmentDetails.appointmentStatus ==
                //             "Done"
                //     ? //if rejected then not show anything, now user have to make a new appointment
                //     Container()
                //     : Row(
                //         //if not rejected
                //         children: [
                //           Expanded(
                //               flex: 1,
                //               child: _roundedReschtBtn(
                //                   "Reschedule", "Rescheduled")),
                //           Expanded(
                //               flex: 1,
                //               child:
                //                   _roundedRejectBtn("Reject", "Rejected"))
                //         ],
                //       ),
              ]),
        ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update", _handleUpdate);
  }

  _handleUpdate() async {

    if (_formKey.currentState.validate()) {
      print("hihihih");
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });

      final pattern = RegExp('\\s+'); //remove all space
      final fullName = _firstNameController.text + _latsNameController.text;
      String searchByName = fullName.toLowerCase().replaceAll(pattern, "");

      final appointmentModel= AppointmentModel(
          id:  widget.appointmentDetails.id,
          pPhn: _phnController.text,
          pCity: _cityController.text,
          age: _ageController.text,
          pFirstName: _firstNameController.text,
          pLastName: _latsNameController.text,
          description: _descController.text,
          pEmail: _emailController.text,
          gender: _selectedGender,
          searchByName: searchByName
      );
      final res=await AppointmentService.updateData(appointmentModel);
      if (res == "success") {
        //ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/'));
      } else if (res == "error") {
        //ToastMsg.showToastMsg("Something wents wrong");
      }
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    }

    // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
  }
  _genderDropDown(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor:Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor:btnColor,
        items: <String>[
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,style:TextStyle(color:Colors.black),),
          );
        }).toList(),
        hint:Text(
          "Gender",

        ),
        onChanged: (String value) {
          setState(() {
            print(value);
            _selectedGender = value;
          });
        },
      ),
    );
  }
  _handleRescheduleBtn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseTimeSlotsPage(
          serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
          appointmentId: widget.appointmentDetails.id,
          appointmentDate: widget.appointmentDetails.appointmentDate,
          uId: widget.appointmentDetails.uId,
          uName: "${widget.appointmentDetails.uName
          }",
          serviceName: widget.appointmentDetails.serviceName,

        ),
      ),
    );
  }

  _handleRejectAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final res = await DeleteData.deleteBookedAppointment(
      widget.appointmentDetails.id,
      widget.appointmentDetails.appointmentDate,
    );
    if (res == "success") {
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Rejected"
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
        await  _sendNotification("Rejected");
        //ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/'));
      } else {
        //ToastMsg.showToastMsg("Something went wrong");
      }

    } else {
      //ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _handleDoneAppointment() async {

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final res = await DeleteData.deleteBookedAppointment(
      widget.appointmentDetails.id,
      widget.appointmentDetails.appointmentDate,
    );
    if (res == "success") {
      final appointmentModel=AppointmentModel(
          id: widget.appointmentDetails.id,
          appointmentStatus: "Visited"
      );
      final isUpdated=await AppointmentService.updateStatus(appointmentModel);
      if(isUpdated=="success"){
        _sendNotification("Visited");
        //ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/'));
      } else {
        //ToastMsg.showToastMsg("Something went wrong");
      }

    } else {
      //ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }


  // _roundedDoneBtn(String title, String status) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: GestureDetector(
  //       onTap: () {
  //         DialogBoxes.confirmationBox(
  //             context,
  //             "Done",
  //             "Are you sure want to done this appointment",
  //             _handleDoneAppointment);
  //
  //         //   _handleAppointmentStatus( widget.appointmentDetails["uId"],widget.appointmentDetails["appointmentId"], status);
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(25.0),
  //             gradient: LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               colors: [
  //                 Color(0xFF0099ff),
  //                 Color(0xFF004272),
  //               ],
  //             )),
  //         child: Center(
  //             child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Text(title, style: TextStyle(color: Colors.white)),
  //         )),
  //       ),
  //     ),
  //   );
  // }

  _handleAppointmentStatus(String appointmentId, String status) async {
    //print(uId + appointmentId + status);
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    final appointmentModel=AppointmentModel(
        id: appointmentId,
        appointmentStatus: status
    );

    final res = await AppointmentService.updateStatus(appointmentModel);
    if (res == "success") {
      await  _sendNotification(status);
      //ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/'));
    } else {
      //ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  _sendNotification(String title) async {
    String body = "";
    switch (title) {
      case "Visited":
        {
          body = "Thank you for visiting. Please visit again";
          break;
        }
      case "Confirmed":
        {
          body =
          "Your appointment has been confirmed for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Pending":
        {
          body =
          "Your appointment has been pending for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Rejected":
        {
          body =
          "Sorry your appointment has been rejected for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      default:
        {
          body = "";
        }
    }
    // final notificationModel = NotificationModel(
    //     title: title,
    //     body:body,
    //     uId: widget.appointmentDetails.uId,
    //     routeTo: "/Appointmentstatus",
    //     sendBy: "admin",
    //     sendFrom: "Admin",
    //     sendTo: widget.appointmentDetails.uName);
    // final msgAdded = await NotificationService.addData(notificationModel);
    // if (msgAdded == "success") {
    //   final res = await UserService.getUserById(widget.appointmentDetails.uId); //get fcm id of specific user

    //   HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
    //   await UpdateData.updateIsAnyNotification("usersList", widget.appointmentDetails.uId, true);
    // }
  }
  showDialogBox() {

    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a status"),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    _myRadioButton(
                        title: "Confirmed",
                        value: 0,
                        onChanged: (newValue)=> setState(() {
                          _groupValue = newValue;
                        })
                    ),
                    _myRadioButton(
                      title: "Visited",
                      value: 1,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Pending",
                      value: 2,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reject",
                      value: 3,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title:"Reschedule",
                      value: 4,
                      onChanged: (newValue) => setState(() => _groupValue = newValue),
                    )

                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed: () {
                    switch (_groupValue){
                      case 0: {
                        Navigator.of(context).pop();
                        _handleAppointmentStatus(
                            widget.appointmentDetails.id, "Confirmed");
                      }


                      break;
                      case 1:{ Navigator.of(context).pop();
                      _handleDoneAppointment();
                      }

                      break;
                      case 2:    { Navigator.of(context).pop();
                      _handleAppointmentStatus(
                          widget.appointmentDetails.id, "Pending");}

                      break;
                      case 3:
                        { Navigator.of(context).pop();
                        _handleRejectAppointment();}
                        break;
                        break;
                      case 4:{
                        Navigator.of(context).pop();
                        _handleRescheduleBtn();
                      }
                      break;
                      default: print(
                          "Not Select");
                      break;
                    }


                  }),
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("Cancel",style: TextStyle(
                      color: Colors.white
                  ),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }
  Widget _myRadioButton({String title, int value, required Function onChanged}) {
    return RadioListTile(
      activeColor: btnColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged(),
      title: Text(title),
    );
  }

}
