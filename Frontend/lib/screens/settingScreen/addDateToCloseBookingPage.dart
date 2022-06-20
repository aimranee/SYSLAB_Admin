import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/service/readData.dart';
import 'package:syslab_admin/service/updateData.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/datePicker.dart';
import 'package:syslab_admin/utilities/dialogBox.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';


class AddDateToCloseBookingPage extends StatefulWidget {
  @override
  _AddDateToCloseBookingPageState createState() =>
      _AddDateToCloseBookingPageState();
}

class _AddDateToCloseBookingPageState extends State<AddDateToCloseBookingPage> {
  List _date = [];
  bool _isEnableBtn = true;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setClosingDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: IAppBars.commonAppBar(context, "Choose Date"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Update",
          isEnableBtn: _isEnableBtn,
          onPressed: _takeConfirmation,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          onPressed: () async {
            final res = await DatePicker.datePicker(context);
            if (res != "") {
              if (_date.contains(res))
                setState(() {
                  _date.remove(res);
                });
              else
                setState(() {
                  _date.add(res);
                });
            }

            print(_date);
          },
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : _date.length == 0
                ? NoDataWidget()
                : ListView.builder(
                    itemCount: _date.length,
                    itemBuilder: (context, index) {
                      return _buildListTileCard(_date[index]);
                    },
                  ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update date", _handleUpdate);
  }

  _handleUpdate() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await UpdateData.updateSettings({"closingDate": _date});
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully updated");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
      _isEnableBtn = true;
    });
  }

  Widget _buildListTileCard(String date) {
    return Card(
      child: ListTile(
        title: Text(date),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: primaryColor,
          ),
          onPressed: () {
            setState(() {
              _date.remove(date);
            });
          },
        ),
      ),
    );
  }

  void _setClosingDate() async {
    setState(() {
      _isLoading = true;
    });
    final res = await ReadData.fetchSettings();
    print(res);
    if (res != null) {
      setState(() {
        _date = res["closingDate"];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
