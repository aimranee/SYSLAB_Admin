import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/service/readData.dart';
import 'package:syslab_admin/service/updateData.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities///ToastMsg.dart';

class EditSettingPage extends StatefulWidget {
  @override
  _EditSettingPageState createState() => _EditSettingPageState();
}

class _EditSettingPageState extends State<EditSettingPage> {
  bool _isEnableAllBtn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IAppBars.commonAppBar(context, "Settings"),
      body: StreamBuilder(
          stream: ReadData.fetchSettingsStream(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? LoadingIndicatorWidget()
                : ListView(
                    children: [
                      _stopBookingWidget(snapshot.data),
                      SizedBox(height: 10),
                      _technicalIssueWidget(snapshot.data),
                      SizedBox(height: 10),
                      _addDateToCloseBookingWidget()
                    ],
                  );
          }),
    );
  }

  Widget _stopBookingWidget(bookingDetail) {
    return ListTile(
      title: Text("online booking"),
      subtitle: bookingDetail["stopBooking"]
          ? Text("turn off to start online booking")
          : Text("turn on to stop online booking"),
      trailing: IconButton(
        icon: bookingDetail["stopBooking"]
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: !_isEnableAllBtn
            ? null
            : () {
                _handleUpdate("stopBooking", !bookingDetail["stopBooking"]);
              },
      ),
    );
  }

  Widget _technicalIssueWidget(data) {
    return ListTile(
      title: Text("Technical issue"),
      subtitle: data["technicalIssue"]
          ? Text("turn off to hide technical issue msg in client app")
          : Text("turn on to show technical issue msg in client app"),
      trailing: IconButton(
        icon: data["technicalIssue"]
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: !_isEnableAllBtn
            ? null
            : () {
                _handleUpdate("technicalIssue", !data["technicalIssue"]);
              },
      ),
    );
  }

  _handleUpdate(String name, bool value) async {
    setState(() {
      _isEnableAllBtn = false;
    });
    final res = await UpdateData.updateSettings(
        {name: value}); //update settings in firebase
    if (res == "success") {
      //ToastMsg.showToastMsg("Successfully changed");
    } else {
      //ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableAllBtn = true;
    });
  }

  Widget _addDateToCloseBookingWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/AddDateToCloseBookingPage");
      },
      child: ListTile(
        title: Text("Close Date"),
        subtitle: Text("Manage date where you want to close booking"),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }
}
