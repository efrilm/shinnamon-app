import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shinnamon/services/api.dart';
import 'package:shinnamon/thema.dart';
import 'package:shinnamon/widgets/button_custom.dart';
import 'package:shinnamon/widgets/input_field.dart';
import 'package:http/http.dart' as http;
import 'package:shinnamon/widgets/loading_button.dart';

class ChangeNoTelpPage extends StatefulWidget {
  const ChangeNoTelpPage({Key? key}) : super(key: key);

  @override
  _ChangeNoTelpPageState createState() => _ChangeNoTelpPageState();
}

class _ChangeNoTelpPageState extends State<ChangeNoTelpPage> {
  var isLoading = false;

  TextEditingController noTelpController = TextEditingController();

  handleNoTelp() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.put(Uri.parse(AppUrl.editNoTelp), body: {
      'id': pref.getString('userId'),
      'no_telp': noTelpController.text,
    });
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        print(data);
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/markom-main', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Berhasil!',
            style: whiteTextStyle,
          ),
          backgroundColor: Colors.green[600],
          duration: const Duration(milliseconds: 1500),
          width: 200.0, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar header() {
      return AppBar(
        centerTitle: true,
        title: Text(
          "Ganti No. Whatsapp",
          style: primaryTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: kPrimaryColor,
          ),
        ),
        backgroundColor: kWhiteColor,
        elevation: 1,
      );
    }

    Widget inputText() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
          left: hMargin,
          right: hMargin,
        ),
        child: InputField(
          controller: noTelpController,
          hintText: "No. Whatsapp",
        ),
      );
    }

    Widget button() {
      return Container(
        margin: EdgeInsets.only(
          top: 35,
          left: hMargin,
          right: hMargin,
        ),
        child: isLoading
            ? LoadingButton()
            : CustomButton(
                onPressed: () {
                  handleNoTelp();
                },
                text: "Ganti",
              ),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          header(),
          inputText(),
          button(),
        ],
      ),
    );
  }
}
