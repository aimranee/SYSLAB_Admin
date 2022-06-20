import 'package:syslab_admin/model/drProfielModel.dart';
import 'package:syslab_admin/service/drProfileService.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/boxWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/imagePicker.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isLoading = false;
  String _imageUrl = "";
  // List<Asset> _images = <Asset>[];
  String _id = "";
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _whatsAppNoController = TextEditingController();
  TextEditingController _primaryPhnController = TextEditingController();
  TextEditingController _secondaryPhnController = TextEditingController();
  TextEditingController _aboutUsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserDetails(); //get and set all initial values
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    _subTitleController.dispose();
    _whatsAppNoController.dispose();
    _primaryPhnController.dispose();
    _secondaryPhnController.dispose();
    _aboutUsController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          title: "Update",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        // appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading ?
             LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    // if (_imageUrl == "")
                    //   if (_images.length == 0)
                    //     ECircularCameraIconWidget(onTap: _handleImagePicker)
                    //   else
                    //     ECircularImageWidget(
                    //       onPressed: _removeImage,
                    //       imageUrl: _imageUrl,
                    //       images: _images,
                    //     )
                    // else
                    //   ECircularImageWidget(
                    //     onPressed: _removeImage,
                    //     imageUrl: _imageUrl,
                    //     images: _images,
                    //   ),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),
                    _inputField(
                        "Subtitle", "Enter sub title", _subTitleController),
                    _emailInputField(),
                    _phnNumInputField(
                        _primaryPhnController, "Enter primary phone number"),
                    _phnNumInputField(_secondaryPhnController,
                        "Enter secondary phone number"),
                    _phnNumInputField(
                        _whatsAppNoController, "Enter what'sapp phone number"),
                    _descInputField(_addressController, "Address", 4),
                    _descInputField(_descController, "Description", 6),
                    _descInputField(_aboutUsController, "About us", 15)
                  ],
                ),
              ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _handleUpdate); //take a confirmation form the user
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      //if all input fields are valid
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      // if (_imageUrl == "" &&
      //     _images.length ==
      //         0) // if user not select any image and initial we have no any image
      //   _updateDetails(""); //update data without image
      // else if (_imageUrl = "") //if initial we have image
      //   _updateDetails(_imageUrl); //update data with image
      // else if (_imageUrl == "" &&
      //     _images.length >
      //         0) //if user select the image then first upload the image then update data in database
      //   _handleUploadImage(); //upload image in to database

    }
  }

  _updateDetails(imageDownloadUrl) async {
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<,$imageDownloadUrl");
    final drProfileModel = DrProfileModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        id: _id,
        description: _descController.text,
        subTitle: _subTitleController.text,
        email: _emailController.text,
        aboutUs: _aboutUsController.text,
        address: _addressController.text,
        pNo1: _primaryPhnController.text,
        pNo2: _secondaryPhnController.text,
        profileImageUrl: imageDownloadUrl,
        whatsAppNo: _whatsAppNoController.text);

    final res = await DrProfileService.updateData(drProfileModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something wents wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  // void _handleUploadImage() async {
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
  //   else {
  //     await _updateDetails(res);
  //   }

  //   setState(() {
  //     _isEnableBtn = true;
  //     _isLoading = false;
  //   });
  // }

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, maxLine);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
      // Pattern pattern =
      //     r"^[a-zA-Z0-9.#$%&'*+/=^_`{|}~-]+@[a-zA-Z0-9](:[a-zA-Z0-9-]"
      //     r"{0,253}[a-zA-Z0-9])(:\.[a-zA-Z0-9](:[a-zA-Z0-9-]"
      //     r"{0,253}[a-zA-Z0-9]))*$";
      RegExp regex = RegExp(r"^[a-zA-Z0-9.#$%&'*+/=^_`{|}~-]+@[a-zA-Z0-9](:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])(:\.[a-zA-Z0-9](:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9]))*$");
      if (regex.hasMatch(item) || item == null)
        return 'Enter a valid email address';
      else
        return null;
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField(controller, labelText) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length == 13
          ? null
          : "Enter a 10 digit mobile number with country code";
    }, TextInputType.phone, 1);
  }

  // void _handleImagePicker() async {
  //   final res = await ImagePicker.loadAssets(
  //       _images, mounted, 1); //1 is the number of images that user can pick
  //   //print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

  //   setState(() {
  //     _images = res;
  //   });
  // }

  // void _removeImage() {
  //   setState(() {
  //     _images.clear(); //clear array of the image
  //     _imageUrl = "";
  //   });
  // }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    final res =
        await DrProfileService.getData(); //fetch all details of the doctors
    // print(res["profileImageUrl"]);
    setState(() {
      //set all the values in to text fields
      _emailController.text = res[0].email;
      _lastNameController.text = res[0].lastName;
      _firstNameController.text = res[0].firstName;
      _imageUrl = res[0].profileImageUrl;
      _descController.text = res[0].description;
      _subTitleController.text = res[0].subTitle;
      _whatsAppNoController.text = res[0].whatsAppNo;
      _primaryPhnController.text = res[0].pNo1;
      _secondaryPhnController.text = res[0].pNo2;
      _aboutUsController.text = res[0].aboutUs;
      _addressController.text = res[0].address;
      _id = res[0].id;
    });

    setState(() {
      _isLoading = false;
    });
  }
}
