import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shinnamon/const.dart';
import 'package:shinnamon/services/api.dart';
import 'package:shinnamon/thema.dart';
import 'package:shinnamon/widgets/data_not_found.dart';
import 'package:shinnamon/widgets/loading.dart';

class AllMonthPage extends StatefulWidget {
  const AllMonthPage({Key? key}) : super(key: key);

  @override
  _AllMonthPageState createState() => _AllMonthPageState();
}

class _AllMonthPageState extends State<AllMonthPage> {
var isLoading = false;
  var isData = false;

  List<dynamic> list = [];

  Future<void> getMonth() async {
    setState(() {
      isLoading = true;
    });
    list.clear();
    final response =
        await http.get(Uri.parse(AppUrl.getMonth + AppCode.project));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          isLoading = false;
          isData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          list = data;
          isLoading = false;
          isData = true;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        isData = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMonth();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : isData
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final l = list[i];
                  return Container(
                    margin: EdgeInsets.only(
                      top: 15,
                      left: hMargin,
                      right: hMargin,
                    ),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      boxShadow: [
                        shadow,
                      ],
                      borderRadius: BorderRadius.circular(dRadius),
                    ),
                    padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 30,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          l['month'],
                          style: blackTextStyle,
                        ),
                        Spacer(),
                        Text(
                          l['count_month'],
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : DataNotFound();
  }
}
