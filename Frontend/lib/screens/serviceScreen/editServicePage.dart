import 'package:syslab_admin/model/serviceModel.dart';
import 'package:syslab_admin/service/serviceService.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/boxWidget.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/imagePicker.dart';
import 'package:syslab_admin/utilities///ToastMsg.dart';

class EditServicePage extends StatefulWidget {
  final serviceDetails;
  const EditServicePage({key key, this.serviceDetails}) : super(key: key);

  @override
  _EditServicePageState createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  TextEditingController _serviceNameController = new TextEditingController();
  TextEditingController _subTitleInputController = new TextEditingController();
  TextEditingController _descInputController = new TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all textController values
    _serviceNameController.text = widget.serviceDetails.title;
    _subTitleInputController.text = widget.serviceDetails.subTitle;
    _descInputController.text = widget.serviceDetails.desc;
    //initialize image url
    _imageUrl = widget.serviceDetails.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _serviceNameController..dispose();
    _subTitleInputController.dispose();
    _descInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IAppBars.commonAppBar(context, "Edit Service"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        onPressed: _takeConfirmation,
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
                    // if (_imageUrl == "")
                    //   if (_images.length == 0)
                    //     ECircularCameraIconWidget(
                    //       onTap: _handleImagePicker,
                    //     )
                    //   else
                    //     ECircularImageWidget(
                    //       onPressed: _removeImage,
                    //       images: _images,
                    //       imageUrl: _imageUrl,
                    //     )
                    // else
                    //   ECircularImageWidget(
                    //     onPressed: _removeImage,
                    //     images: _images,
                    //     imageUrl: _imageUrl,
                    //   ),
                    _serviceNameInputField(),
                    _subTitleInputField(),
                    _descInputField(),
                    _deleteServiceBtn()
                  ],
                ),
              ),
            ),
    );
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Update",
          "Are you sure want to update",
          _handleUpdate); //take confirmation form user
    }
  }

  Widget _deleteServiceBtn() {
    return DeleteButtonWidget(
      onPressed: () {
        DialogBoxes.confirmationBox(
            context,
            "Delete",
            "Are you sure want to delete",
            _handleDeleteService); //take confirmation from user
      },
      title: "Delete",
    );
  }

  _handleDeleteService() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await ServiceService.deleteData(widget.serviceDetails.id);
    if (res == "success") {
      //ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/ServicesPage', ModalRoute.withName('/'));
    } else {
      //ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  // void _handleImagePicker() async {
  //   final res = await ImagePicker.loadAssets(
  //       _images, mounted, 1); //1 is number of images user can pick
  //   setState(() {
  //     _images = res;
  //   });
  // }

  _handleUpdate() {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // if (_imageUrl == "" &&
    //     _images.length ==
    //         0) // if user not select any image and initial we have no any image
    //   _updateDetails(""); //update data without image
    // else if (_imageUrl != "") //if initial we have image
    //   _updateDetails(_imageUrl); //update data with image
    // else if (_imageUrl == "" && _images.length > 0) _handleUploadImage();
    //if user select the image then first upload the image then update data in database
    //  _uploadImg(); //upload image in to database
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear(); //clear array
    //   _imageUrl = "";
    // });
  }

  _updateDetails(imageDownloadUrl) async {
    final serviceModel = ServiceModel(
        title: _serviceNameController.text,
        subTitle: _subTitleInputController.text,
        imageUrl: imageDownloadUrl,
        id: widget.serviceDetails.id,
        desc: _descInputController.text);
    final res = await ServiceService.updateData(serviceModel);
    if (res == "success") {
      //ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/ServicesPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      //ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_serviceNameController, "Title*",
        (item) {
      return item.length > 0 ? null : "Enter service name";
    }, TextInputType.text, 1);
  }

  Widget _subTitleInputField() {
    return InputFields.commonInputField(_subTitleInputController, "Sub Title*",
        (item) {
      return item.length > 0 ? null : "Enter Subtitle";
    }, TextInputType.text, 1);
  }

  Widget _descInputField() {
    return InputFields.commonInputField(_descInputController, "Description",
        (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, 8);
  }

  void _handleUploadImage() async {
    // final res = await UploadImageService.uploadImages(_images[0]);
    // if (res == "0")
    //   //ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "1")
    //   //ToastMsg.showToastMsg("Image size must be less the 1MB");
    // else if (res == "2")
    //   //ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "3" || res == "error")
    //   //ToastMsg.showToastMsg("Something went wrong");
    // else if (res == "" || res == null)
    //   //ToastMsg.showToastMsg("Something went wrong");
    // else {
    //   await _updateDetails(res);
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
}
