import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/screens/userScreen/confiramtionPage.dart';

class RegisterPatient extends StatefulWidget {
  final userDetails;
  final serviceName;
  final serviceTimeMin;
  final setTime;
  final selectedDate;
  RegisterPatient(
      {Key key,
      this.userDetails,
      this.serviceTimeMin,
      this.selectedDate,
      this.serviceName,
      this.setTime})
      : super(key: key);

  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  String _selectedGender = 'Gender';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _emailController.text = widget.userDetails.email;
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text =
          (widget.userDetails.pNo).toString().substring(3);
      _cityController.text = widget.userDetails.city;
      _ageController.text = widget.userDetails.age;
      _selectedGender = widget.userDetails.gender;
    });
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _desController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IAppBars.commonAppBar(context, "Register Patient"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: true,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (_selectedGender == "Gender") {
              ToastMsg.showToastMsg("Please select gender");
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmationPage(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phoneNumber: _phoneNumberController.text,
                        email: _emailController.text,
                        age: _ageController.text,
                        selectedGender: _selectedGender,
                        city: _cityController.text,
                        des: _desController.text,
                        serviceName: widget.serviceName,
                        serviceTimeMin: widget.serviceTimeMin,
                        setTime: widget.setTime,
                        selectedDate: widget.selectedDate,
                        uId: widget.userDetails.uId,
                        uName: widget.userDetails.firstName +
                            " " +
                            widget.userDetails.lastName,
                        userFcmId: widget.userDetails.fcmId)),
              );
            }
          }
        },
        title: "Next",
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 15, right: 15),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputFields.commonInputField(_firstNameController, "First Name",
                    (item) {
                  return item.length > 0 ? null : "Enter first name";
                }, TextInputType.text, 1),
                InputFields.commonInputField(_lastNameController, "Last Name",
                    (item) {
                  return item.length > 0 ? null : "Enter last name";
                }, TextInputType.text, 1),
                InputFields.commonInputField(
                    _phoneNumberController, "Mobile Number", (item) {
                  return item.length == 10
                      ? null
                      : "Enter a 10 digit mobile number";
                }, TextInputType.phone, 1),
                InputFields.commonInputField(_ageController, "Age", (item) {
                  if (item.length > 0 && item.length <= 3)
                    return null;
                  else if (item.length > 3)
                    return "Enter valid age";
                  else
                    return "Enter age";
                }, TextInputType.number, 1),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 0.0, left: 15, right: 15),
                  child: _genderDropDown(),
                ),
                InputFields.commonInputField(_emailController, "Email", (item) {
                  // Pattern pattern =
                  //     r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                  //     r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                  //     r"{0,253}[a-zA-Z0-9])?)*$";
                  RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?)*$");
                  if (item.length > 0) {
                    if (regex.hasMatch(item) || item == null)
                      return 'Enter a valid email address';
                    else
                      return null;
                  } else
                    return null;
                }, TextInputType.emailAddress, 1),
                InputFields.commonInputField(_cityController, "City", (item) {
                  return item.length > 0 ? null : "Enter a city name";
                }, TextInputType.text, 1),
                InputFields.commonInputField(
                    _desController, "Description, About problem", (item) {
                  if (item.isEmpty)
                    return null;
                  else {
                    return item.length > 0 ? null : "Enter Description";
                  }
                }, TextInputType.text, 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 15),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Gender',
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Select Gender",
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
}
