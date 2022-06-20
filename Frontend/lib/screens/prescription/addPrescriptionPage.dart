
import 'package:syslab_admin/model/notificationModel.dart';
import 'package:syslab_admin/model/prescriptionModel.dart';
import 'package:syslab_admin/screens/prescription/shoePrescriptionPage.dart';
import 'package:syslab_admin/service/Notification/handleFirebaseNotification.dart';
import 'package:syslab_admin/service/notificationService.dart';
import 'package:syslab_admin/service/prescriptionService.dart';
import 'package:syslab_admin/service/updateData.dart';
import 'package:syslab_admin/service/uploadImageService.dart';
import 'package:syslab_admin/service/userService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
import 'package:syslab_admin/utilities/imagePicker.dart';
import 'package:syslab_admin/utilities/inputField.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/imageWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

class AddPrescriptionPage extends StatefulWidget {
  final title;
  final serviceName;
  final patientName;
  final date;
  final time;
  final appointmentId;
  final patientId;
  AddPrescriptionPage({ this.title,
 this.patientName,
 this.serviceName,
 this.date,
 this.time,
 this.appointmentId,
 this.patientId});
  @override
  _AddPrescriptionPageState createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  TextEditingController _serviceNameController = new TextEditingController();
  TextEditingController _patientNameController = new TextEditingController();
  TextEditingController _drNameController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();
  ScrollController _scrollController=new ScrollController();
  List<String> _imageUrls=[];
  // List<Asset> _listImages = <Asset>[];
  //String _imageName = "";
  int _successUploaded = 1;
  bool _isUploading = false;
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey=new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _serviceNameController.text=widget.serviceName;
      _patientNameController.text=widget.patientName;
      _drNameController.text="Dr Name";
      _dateController.text=widget.date;
      _timeController.text=widget.time;

    });
    super.initState();
    print(_imageUrls.length);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _serviceNameController..dispose();
    _patientNameController.dispose();
    _drNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  _takeUpdateConfirmation(){
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update details", _handleUpdate);
  }
  _handleUpdate()async {
    if (_formKey.currentState.validate()) {

      setState(() {
        _isUploading = true;
        _isEnableBtn = false;
      });
      // if (_listImages.length == 0) {
      //   String imageUrl = "";
      //   if (_imageUrls.length = 0) {
      //     for (var e in _imageUrls) {
      //       if (imageUrl == "") {
      //         imageUrl = e;
      //       } else {
      //         imageUrl = imageUrl + "," + e;
      //       }
      //     }
      //   }

      //   PrescriptionModel prescriptionModel = PrescriptionModel(
      //       appointmentId:widget.appointmentId,
      //       patientId:widget.patientId,
      //       appointmentTime:widget.time,
      //       appointmentDate:widget.date,
      //       appointmentName:widget.serviceName,
      //       drName: _drNameController.text,
      //       patientName: _patientNameController.text,
      //       imageUrl: imageUrl,
      //       prescription: _messageController.text
      //   );
      //   final res = await PrescriptionService.addData(prescriptionModel);
      //   if (res == "success") {
      //     ToastMsg.showToastMsg("Successfully Added");
      //        await  _sendNotification();
      //     Navigator.of(context).pushNamedAndRemoveUntil(
      //         '/AppointmentListPage', ModalRoute.withName('/'));
      //   }
      //   else
      //     ToastMsg.showToastMsg("Something went wrong");
      // }
      // else {
      //   await _startUploading();
      // }


      setState(() {
        _isUploading = false;
        _isEnableBtn = true;
      });
    }
  }
  _startUploading() async {
    int index = _successUploaded - 1;
    setState(() {
      //_imageName=_listImages[index].name;
    });


    // if (_successUploaded <= _listImages.length) {
    //   final res=await UploadImageService.uploadImages(_listImages[index]); //  represent the progress of uploading task
    //   if(res=="0"){
    //     ToastMsg.showToastMsg("Sorry, ${_listImages[index].name} is not in format only JPG, JPEG, PNG, & GIF files are allowed to upload");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task

    //     } else {

    //     }
    //   }

    //   else if(res=="1")
    //   {ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 2MB");
    //   if (_successUploaded < _listImages.length) {
    //     //check more images for upload
    //     setState(() {
    //       _successUploaded = _successUploaded + 1;
    //     });
    //     _startUploading(); //if images is remain to upload then again run this task

    //   } else {

    //   }
    //   }

    //   else if(res=="2")
    //   { ToastMsg.showToastMsg("Image ${_listImages[index].name} size must be less the 2MB");
    //   if (_successUploaded < _listImages.length) {
    //     //check more images for upload
    //     setState(() {
    //       _successUploaded = _successUploaded + 1;
    //     });
    //     _startUploading(); //if images is remain to upload then again run this task

    //   } else {
    //   }
    //   }

    //   else if(res=="3"|| res=="error")
    //   { ToastMsg.showToastMsg("Something went wrong");
    //   if (_successUploaded < _listImages.length) {
    //     //check more images for upload
    //     setState(() {
    //       _successUploaded = _successUploaded + 1;
    //     });
    //     _startUploading(); //if images is remain to upload then again run this task

    //   } else {

    //   }
    //   }

    //   else if(res==""||res==null)
    //   {ToastMsg.showToastMsg("Something went wrong");
    //   if (_successUploaded < _listImages.length) {
    //     //check more images for upload
    //     setState(() {
    //       _successUploaded = _successUploaded + 1;
    //     });
    //     _startUploading(); //if images is remain to upload then again run this task

    //   } else {
    //   }
    //   }
    //   else{
    //     setState(() {
    //       _imageUrls.add(res);
    //     });

    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task

    //     } else {
    //       // print("***********${_imageUrls.length}");
    //       String imageUrl="";
    //       if(_imageUrls.length=0){
    //         for(var e in _imageUrls){
    //           if(imageUrl==""){
    //             imageUrl =e;
    //           }else{
    //             imageUrl =imageUrl+","+e;
    //           }
    //         }}

    //       PrescriptionModel prescriptionModel=PrescriptionModel(
    //           appointmentId:widget.appointmentId,
    //           patientId:widget.patientId,
    //           appointmentTime:widget.time,
    //           appointmentDate:widget.date,
    //           appointmentName:widget.serviceName,
    //           drName: _drNameController.text,
    //           patientName: _patientNameController.text,
    //           imageUrl: imageUrl,
    //           prescription: _messageController.text
    //       );
    //       final res =await PrescriptionService.addData(prescriptionModel);
    //       if(res=="success"){
    //         ToastMsg.showToastMsg("Successfully Added");
    //         await  _sendNotification();
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //             '/AppointmentListPage', ModalRoute.withName('/'));
    //       }
    //       else ToastMsg.showToastMsg("Something went wrong");
    //     }
    //   }


    // }
    setState(() {
      _isUploading = false;
      _isEnableBtn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: kAppBarTitleStyle,),
        backgroundColor: appBarColor,
        // actions: [
        //   IconButton(onPressed: (){}, icon:Icon(Icons.delete))
        // ],
      ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: _loadAssets
            ),
            backgroundColor:btnColor,
            onPressed: (){}
        ),
      bottomNavigationBar: BottomNavBarWidget(
          title: "Add",
          onPressed:_takeUpdateConfirmation,
          isEnableBtn:_isEnableBtn
      ),

      body: _isUploading?LoadingIndicatorWidget(): Form(
        key: _formKey,
        child: ListView(
          children: [
            InputFields.readableInputField(_serviceNameController, "Service", 1),
            InputFields.commonInputField(_patientNameController, "Patient Name", (item) {
              return item.length > 0 ? null : "Enter patient name";
            }, TextInputType.text, 1),
            InputFields.commonInputField(_drNameController, "Dr Name", (item) {
              return item.length > 0 ? null : "Enter Dr name";
            }, TextInputType.text, 1),
            InputFields.readableInputField(_dateController, "Date", 1),
            InputFields.readableInputField(_timeController, "Time", 1),
            InputFields.commonInputField(_messageController, "Message", (item) {
              return item.length > 0 ? null : "Enter message ";
            }, TextInputType.text, null),
            _imageUrls.length==0?Container(): Padding(
              padding: const EdgeInsets.fromLTRB(20,8,20,8),
              child: Text("Previous attached image",style: TextStyle(
                  fontFamily: "OpenSans-SemiBold",
                  fontSize: 14
              ),),
            ),
            // _buildImageList(),

            // _listImages.length==0? 
            Container()
            // :
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20,8,20,8),
            //   child: Text("New attached image",style: TextStyle(
            //       fontFamily: "OpenSans-SemiBold",
            //       fontSize: 14
            //   ),),
            // ),
            // _buildNewImageList(),
          ],
        ),
      ),
    );
  }
  Future<void> _loadAssets() async {
    // final res = await ImagePicker.loadAssets(
    //     _listImages, mounted, 10); //get images from phone gallery with 10 limit
    setState(() {
      // _listImages = res;
      // if (res.length > 0)
      //   _isEnableBtn = true;
      // else
      //   _isEnableBtn = false;
    });
  }

  // _buildNewImageList() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         controller: _scrollController,
  //         itemCount: _listImages.length,
  //         itemBuilder: (context, index) {
  //           Asset asset = _listImages[index];
  //           return Padding(
  //             padding: const EdgeInsets.only(top:8.0),
  //             child: GestureDetector(
  //               onLongPress: (){
  //                 DialogBoxes.confirmationBox(
  //                     context, "Delete", "Are you sure want to delete selected image", (){
  //                   setState(() {
  //                     _listImages.removeAt(index);
  //                   });
  //                 });

  //               },
  //               child: AssetThumb(
  //                 asset: asset,
  //                 width: 300,
  //                 height: 300,
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  // _buildImageList() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         controller: _scrollController,
  //         itemCount: _imageUrls.length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(bottom: 10.0),
  //             child: GestureDetector(
  //               onTap: (){
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ShowPrescriptionImagePage(
  //                         imageUrls: _imageUrls,
  //                         selectedImagesIndex: index,
  //                         title: "Prescription Image"),
  //                   ),
  //                 );
  //               },
  //               onLongPress: (){
  //                 DialogBoxes.confirmationBox(
  //                     context, "Delete", "Are you sure want to delete selected image", (){
  //                   setState(() {
  //                     _imageUrls.removeAt(index);
  //                   });
  //                 });
  //               },

  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 child:ImageBoxContainWidget(imageUrl:_imageUrls[index] ,),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  // _sendNotification()async {
  //   String title="Prescription Added";
  //   String body="New Prescription has been added for ${widget.serviceName} please check it";
  //   final notificationModel = NotificationModel(
  //       title: title,
  //       body:body,
  //       uId: widget.patientId,
  //       routeTo: "/PrescriptionListPage",
  //       sendBy: "admin",
  //       sendFrom: "Admin",
  //       sendTo: widget.patientName);
  //   final msgAdded = await NotificationService.addData(notificationModel);
  //   if (msgAdded == "success") {
  //     final res = await UserService.getUserById(widget.patientId); //get fcm id of specific user

  //     HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
  //     await UpdateData.updateIsAnyNotification("usersList", widget.patientId, true);
  //   }
  // }

}
