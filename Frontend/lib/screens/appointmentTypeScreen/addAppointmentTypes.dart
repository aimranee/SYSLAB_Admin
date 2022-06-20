import 'package:syslab_admin/model/appointmentTypeModel.dart';
import 'package:syslab_admin/service/appointmentTypeService.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/boxWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/imagePicker.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

import 'package:time_range_picker/time_range_picker.dart';

class AddAppointmentTypesPage extends StatefulWidget {
  final disableStartTime;
  final disableEndTime; //QueryDocumentSnapshot
  const AddAppointmentTypesPage({
    Key key,
    this.disableStartTime,
    this.disableEndTime,
  }) : super(key: key);
  @override
  _AddAppointmentTypesPageState createState() =>
      _AddAppointmentTypesPageState();
}

class _AddAppointmentTypesPageState extends State<AddAppointmentTypesPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _subTitleController = new TextEditingController();
  TextEditingController _timeTakesController = new TextEditingController();
  TextEditingController _openingTimeController = new TextEditingController();
  TextEditingController _closingTimeController = new TextEditingController();
  int disableStartTimeHour;
  int disableEndTimeHour;
  int disableStartTimeMin;
  int disableEndTimeMin;

  List _dayCode = [];
  bool _monCheckedValue = false;
  bool _tueCheckedValue = false;
  bool _wedCheckedValue = false;
  bool _thuCheckedValue = false;
  bool _friCheckedValue = false;
  bool _satCheckedValue = false;
  bool _sunCheckedValue = false;

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _openingTimeController.text = widget.disableStartTime;
      _closingTimeController.text = widget.disableEndTime;
      disableStartTimeHour =
          int.parse((widget.disableStartTime).substring(0, 2));
      disableEndTimeHour = int.parse((widget.disableEndTime).substring(0, 2));
      disableStartTimeMin =
          int.parse((widget.disableStartTime).substring(3, 5));
      disableEndTimeMin = int.parse((widget.disableEndTime).substring(3, 5));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _timeTakesController.dispose();
    _subTitleController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IAppBars.commonAppBar(context, "Add Appointment Types"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        title: "Add",
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // _images.length == 0
                    //     ? CircularCameraIconWidget(
                    //         onTap: _handleImagePicker,
                    //       )
                    //     : CircularImageWidget(
                    //         onPressed: _removeImage,
                    //         images: _images,
                    //       ),
                    _nameInputField(),
                    _subTitleInputField(),
                    _timeTakeInputField(),
                    _timingInputField("Opening Time", _openingTimeController),
                    _timingInputField("Closing Time", _closingTimeController),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                            "Select any days where you want to close booking in every week",
                            style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 14,
                            )),
                      ),
                    ),
                    _buildDayCheckedBox("Monday", _monCheckedValue, "1"),
                    _buildDayCheckedBox("Tuesday", _tueCheckedValue, "2"),
                    _buildDayCheckedBox("Wednesday", _wedCheckedValue, "3"),
                    _buildDayCheckedBox("Thursday", _thuCheckedValue, "4"),
                    _buildDayCheckedBox("Friday", _friCheckedValue, "5"),
                    _buildDayCheckedBox("Saturday", _satCheckedValue, "6"),
                    _buildDayCheckedBox("Sunday", _sunCheckedValue, "7"),
                  ],
                ),
              ),
            ),
    );
  }

  _buildDayCheckedBox(String title, bool checkedValue, String dayCode) {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(title),
      value: checkedValue,
      onChanged: (newValue) {
        switch (dayCode) {
          case "1":
            {
              setState(() {
                _monCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "2":
            {
              setState(() {
                _tueCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "3":
            {
              setState(() {
                _wedCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "4":
            {
              setState(() {
                _thuCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "5":
            {
              setState(() {
                _friCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "6":
            {
              setState(() {
                _satCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case "7":
            {
              setState(() {
                _sunCheckedValue = newValue;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
                print(_dayCode);
              });
            }
        }
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Add Types",
        "Are you sure want to add new appointment type",
        _handleUpload); //take a confirmation from the user
  }

  // void _handleImagePicker() async {
  //   final res = await ImagePicker.loadAssets(
  //       _images, mounted, 1); //get limited 1 number of images images
  //   // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

  //   setState(() {
  //     _images = res;
  //   });
  // }

  _handleUpload() {
    if (_formKey.currentState.validate() && _timeTakesController.text != "0") {
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      // _images.length > 0 ? _uploadImg() : _uploadData("");
    }
  }

  void _removeImage() {
    setState(() {
      // _images.clear(); //clear array
    });
  }

  // _uploadImg() async {
  //   final res = await UploadImageService.uploadImages(_images[0]);
  //   if (res == "0")
  //     ToastMsg.showToastMsg(
  //         "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
  //   else if (res == "1")
  //     ToastMsg.showToastMsg("Image size must be less the 1MB");
  //   else if (res == "2")
  //     ToastMsg.showToastMsg(
  //         "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
  //   else if (res == "3" || res == "error")
  //     ToastMsg.showToastMsg("Something went wrong");
  //   else if (res == "" || res == null)
  //     ToastMsg.showToastMsg("Something went wrong");
  //   else
  //     await _uploadData(res);

  //   setState(() {
  //     setState(() {
  //       _isEnableBtn = true;
  //       _isLoading = false;
  //     });
  //   });
  // }

  _uploadData(imageDownloadUrl) async {
    String day = "";
    if (_dayCode.length > 0) {
      for (int i = 0; i < _dayCode.length; i++) {
        if (i == 0) {
          day = _dayCode[i];
        } else {
          day = day + "," + _dayCode[i];
        }
      }
    }

    final appointmentTypeModel = AppointmentTypeModel(
        imageUrl: imageDownloadUrl,
        title: _titleController.text,
        forTimeMin: int.parse(_timeTakesController.text),
        subTitle: _subTitleController.text,
        openingTime: _openingTimeController.text,
        closingTime: _closingTimeController.text,
        day: day);
    final res = await AppointmentTypeService.addData(
        appointmentTypeModel); //upload data with all  details
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Uploaded");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentTypesPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _subTitleInputField() {
    return InputFields.commonInputField(
        _subTitleController, "Appointment Subtitle", (item) {
      return item.length > 0 ? null : "Enter Appointment Subtitle";
    }, TextInputType.text, 1);
  }

  Widget _nameInputField() {
    return InputFields.commonInputField(_titleController, "Appointment Name",
        (item) {
      return item.length > 0 ? null : "Enter Appointment Name";
    }, TextInputType.text, 1);
  }

  Widget _timeTakeInputField() {
    return InputFields.commonInputField(
        _timeTakesController, "How Much Time will take (in minute)", (item) {
      if (item.length == 0)
        return "Enter Time";
      else if (item.length > 0 && item == "0")
        return "Enter valid time";
      else
        return null;
    }, TextInputType.number, 1);
  }

  Widget _timingInputField(title, controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        onTap: _timePicker,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            labelText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _timePicker() async {
    TimeRange result = await showTimeRangePicker(
      disabledTime: TimeRange(
          startTime:
              TimeOfDay(hour: disableEndTimeHour, minute: disableEndTimeMin),
          endTime: TimeOfDay(
              hour: disableStartTimeHour, minute: disableStartTimeMin)),
      start: TimeOfDay(
          hour: int.parse(_openingTimeController.text.substring(0, 2)),
          minute: int.parse(_openingTimeController.text.substring(3, 5))),
      end: TimeOfDay(
          hour: int.parse(_closingTimeController.text.substring(0, 2)),
          minute: int.parse(_closingTimeController.text.substring(3, 5))),
      strokeColor: primaryColor,
      handlerColor: primaryColor,
      selectedColor: primaryColor,
      context: context,
    );

    if (result = null) {
      setState(() {
        if (result.toString().substring(17, 22) ==
            result.toString().substring(37, 42)) {
          ToastMsg.showToastMsg("please select different times");
        } else {
          _openingTimeController.text = result.toString().substring(17, 22);
          _closingTimeController.text = result.toString().substring(37, 42);
        }
      });
    }
  }
}
