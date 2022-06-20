import 'package:syslab_admin/service/serviceService.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/buttonsWidget.dart';
import 'package:syslab_admin/widgets/errorWidget.dart';
import 'package:syslab_admin/widgets/imageWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:syslab_admin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/screens/serviceScreen/editServicePage.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';

class ServicesPage extends StatefulWidget {
  ServicesPage({key key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _isEnableBtn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: IAppBars.commonAppBar(context, "Edit Service"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Add Service",
          onPressed: () {
            Navigator.pushNamed(context, "/AddServicePage");
          },
          isEnableBtn: _isEnableBtn,
        ),
        body: Container(
            child: FutureBuilder(
                future: ServiceService.getData(), //fetch all service details
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return 
                    // snapshot.data.length == 0
                    //     ? NoDataWidget()
                    //     : 
                        buildGridView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return IErrorWidget();
                  } else {
                    return LoadingIndicatorWidget();
                  }
                })));
  }

  Widget buildGridView(service) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: .8,
        crossAxisCount: 2,
        children: List.generate(service.length, (index) {
          return cardImg(service[index]);
        }),
      ),
    );
  }

  Widget cardImg(serviceDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.yellowAccent,
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              top: 0,
              child: Card(
                // color: Colors.red,
                // color: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      // child: ClipOval(
                      //     child: Padding(
                      //         padding: const EdgeInsets.all(00.0),
                      //         child: serviceDetails.imageUrl == ""
                      //             ? Icon(
                      //                 Icons.category_outlined,
                      //                 color: primaryColor,
                      //               )
                      //             : ImageBoxFillWidget(
                      //                 imageUrl: serviceDetails.imageUrl))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(serviceDetails.title,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 12.0,
                          )),
                    ),
                    Text(serviceDetails.subTitle,
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 12.0,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: EditBtnWidget(
                  title: "Edit",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicePage(
                            serviceDetails:
                                serviceDetails), //send to data to the next screen
                      ),
                    );
                  },
                )),
            Positioned.fill(
              //bottom: -10,

              child: Align(
                alignment: Alignment.bottomCenter,
                child: MoreButtonsWidget(title: "More"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
