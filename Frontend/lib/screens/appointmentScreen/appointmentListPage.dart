import 'package:syslab_admin/screens/appointmentScreen/editAppointmetDetailsPage.dart';
import 'package:syslab_admin/service/appointmentService.dart';
import 'package:syslab_admin/service/appointmentTypeService.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';

import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/errorWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:intl/intl.dart';

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  bool _isEnableBtn = true;
  int limit = 20;
  int itemLength = 0;
  bool isMoreData = false;
  List<String> _appointmentTypes = [];
  List<String> _selectedTypes = [];
  List<String> _allStatus = [
    "Pending",
    "Rescheduled",
    "Rejected",
    "Confirmed",
    "Visited",
    "Canceled"
  ];
  String _firstDate = "All";
  String _lastDate = "All";
  var _selectedFirstDate = new DateTime.now();
  var _selectedLastDate = new DateTime.now();
  List<String> _selectedStatus = [];
  bool _isLoading = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollListener();
    _getSetData();

    super.initState();
  }

  _getSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AppointmentTypeService.getData();
    for (var type in res) {
      setState(() {
        _appointmentTypes.add(type.title);
      });
    }
    setState(() {
      _selectedTypes.addAll(_appointmentTypes);
      _selectedStatus.addAll(_allStatus);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: _filteredAppBar(context, "Appointment"),
        bottomNavigationBar: BottomNavTwoBarWidget(
          secondTitle: "Search By ID",
          secondBtnOnPressed: _handleByIdBtn,
          isenableBtn: _isEnableBtn,
          firstTitle: "Search By Name",
          firstBtnOnPressed: _handleByNameBtn,
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: Icon(Icons.filter_alt_sharp),
              onPressed: showDialogBox,
            ),
            backgroundColor: btnColor,
            onPressed: () {}),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Container(child: cardListBuilder()));
  }

  _handleByIdBtn() {
    Navigator.pushNamed(context, "/SearchAppointmentByIdPage");
  }

  _handleByNameBtn() {
    Navigator.pushNamed(context, "/SearchAppointmentByNamePage");
  }

  Widget _filteredAppBar(context, String title) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        title,
        style: kAppBarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(Icons.date_range), onPressed: _openDialogForDate)),
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(Icons.merge_type_sharp),
                onPressed: showDialogBoxByType))
      ],
    );
  }

  Widget cardListBuilder() {
    return FutureBuilder(
        future: AppointmentService.getData(
            _selectedStatus,
            _selectedTypes,
            _firstDate,
            _lastDate,
            limit), // a previously-obtained Future<String> or null
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 0){
              return NoDataWidget();
            } else {
              // itemLength = snapshot.data;
              return ListView.builder(
                controller: _scrollController,
                // itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return patientDetailsCard(snapshot.data);
                },
              );
            }
          }
          else if (snapshot.hasError) {
            return IErrorWidget();
          } else {
            return LoadingIndicatorWidget();
          }
        });
  }

  showDialogBox() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedStatus);
    return showDialog(
      barrierDismissible: false,
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
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _allStatus.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: primaryColor,
                        title: Text(_allStatus[index]),
                        value: newStatus.contains(_allStatus[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue) {
                              newStatus.add(_allStatus[index]);
                            } else {
                              newStatus.remove(_allStatus[index]);
                            }
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK"),
                  onPressed: () {
                    _handleStatus(newStatus);
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  showDialogBoxByType() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedTypes);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a type"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _appointmentTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: primaryColor,
                        title: Text(_appointmentTypes[index]),
                        value: newStatus.contains(_appointmentTypes[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (newStatus.contains(_appointmentTypes[index])) {
                              newStatus.add(_appointmentTypes[index]);
                            } else {
                              newStatus.remove(_appointmentTypes[index]);
                            }
                            print(newStatus.length);
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK"),
                  onPressed: () {
                    _handleTypes(newStatus);
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  _handleTypes(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("please Select at least one");
    } else if (newStatus.length > 0) {
      _selectedTypes.clear();
      setState(() {
        _selectedTypes.addAll(newStatus);
      });
    }
  }

  _handleStatus(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("please Select at least one");
    } else if (newStatus.length > 0) {
      _selectedStatus.clear();
      setState(() {
        _selectedStatus.addAll(newStatus);
      });
    }
  }

  String _subTitleWithSpace(String subTitle) {
    String string = subTitle;

    for (int i = 0; i < 24 - subTitle.length; i++) {
      string = string + "  ";
    }
    return string;
  }

  Widget patientDetailsCard(appointmentDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListTile(
            isThreeLine: true,
            title: Text(
              "${appointmentDetails.pFirstName + " " + appointmentDetails.pLastName}",
              style: kCardTitleStyle,
            ),
            trailing: editBtn(appointmentDetails),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8.0), child: Divider()),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Id:")}${appointmentDetails.id}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Gender:")}${appointmentDetails.gender}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Age:")}${appointmentDetails.age}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Mobile Number:")}${appointmentDetails.pPhn}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Date:")}${appointmentDetails.appointmentDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Time:")}${appointmentDetails.appointmentTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Type:")}${appointmentDetails.serviceName}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("${_subTitleWithSpace("Appointment Status:")} "),
                      if (appointmentDetails.appointmentStatus == "Confirmed")
                        _statusIndicator(Colors.green)
                      else if (appointmentDetails.appointmentStatus ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rejected")
                        _statusIndicator(Colors.red)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rescheduled")
                        _statusIndicator(Colors.orangeAccent)
                      else
                        Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("${appointmentDetails.appointmentStatus}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget editBtn(appointmentDetails) {
    return EditIconBtnWidget(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAppointmentDetailsPage(
                appointmentDetails: appointmentDetails),
          ),
        );
      },
    );
  }

  // _dateRangePicker() async {
  //   final List<DateTime> picked = await DateRangePicker.showDatePicker(
  //       context: context,
  //       initialFirstDate: _selectedFirstDate,
  //       initialLastDate: _selectedLastDate,
  //       firstDate: new DateTime(2021),
  //       lastDate: new DateTime(2050));
  //   if (picked = null) {
  //     setState(() {
  //       _selectedFirstDate = picked.first;
  //       _selectedLastDate = picked.last;
  //       _firstDate = _setTodayDateFormat(picked.first);
  //       _lastDate = _setTodayDateFormat(picked.last);
  //     });
  //   }
  // }

  String _setTodayDateFormat(date) {
    final DateFormat formatter = DateFormat('M-d-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  _openDialogForDate() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text("Choose"),
          content: Text(
              "Tap on All to get appointment of all dates\n\nTap on Date to pick a date range"),
          actions: <Widget>[
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text("All", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    _firstDate = "All";
                    _lastDate = "All";
                  });
                  Navigator.pop(context);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text(
                  "Date",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // onPressed();
                  Navigator.pop(context);
                  // _dateRangePicker();
                })
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      // print("length" $itemLength $limit");
      if (itemLength >= limit) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            limit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }
}
