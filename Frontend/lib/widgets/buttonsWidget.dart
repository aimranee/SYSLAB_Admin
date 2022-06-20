import 'package:syslab_admin/service/authService/authService.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class LoginButtonsWidget extends StatelessWidget {

  final String title;

  final onPressed;
  LoginButtonsWidget({ this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: Center(
                child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            onPressed: onPressed));
  }
}

class MoreButtonsWidget extends StatelessWidget {

  final String title;
  MoreButtonsWidget({ this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class EditBtnWidget extends StatelessWidget {

  final String title;

  final onPressed;

  EditBtnWidget({ this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(color: primaryColor, fontSize: 12),
          )),
    );
  }
}

class EditIconBtnWidget extends StatelessWidget {

  final onTap;
  EditIconBtnWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
              radius: 15.0,
              backgroundColor: btnColor,
              // foregroundColor: Colors.green,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              )),
        ));
  }
}

class DeleteButtonWidget extends StatelessWidget {

  final String title;

  final onPressed;
  DeleteButtonWidget({this.onPressed,  this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        8,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RoundedBtnWidget extends StatelessWidget {

  final String title;

  final onPressed;
  RoundedBtnWidget({this.onPressed,  this.title});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class SignOutBtnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              AuthService.signOut();
            }),
        Text(
          "LogOut",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class SearchBtnWidget extends StatelessWidget {

  final isEnableBtn;

  final onPressed;
  SearchBtnWidget({this.isEnableBtn, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: primaryColor,
      radius: 20,
      child: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: isEnableBtn ? onPressed : null,
      ),
    );
  }
}
