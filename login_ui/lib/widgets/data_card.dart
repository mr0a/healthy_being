import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../helpers/live_update.dart';
import '../constant.dart';
import '../helpers/http_service.dart';

class DataCard extends StatelessWidget {
  final String title;
  final String dataname;
  final Color iconColor;
  final String asset;
  final String rate;
  const DataCard({
    Key key,
    this.title,
    this.dataname,
    this.iconColor,
    this.asset,
    this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth / 2 - 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      asset,
                      height: 12,
                      width: 12,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HealthData(dataname: dataname, rate: rate),
                  ),
                  // Expanded(child: LineReportChart())
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class HealthData extends StatefulWidget {
  const HealthData({
    Key key,
    @required this.dataname,
    this.rate,
  }) : super(key: key);

  final String dataname;
  final String rate;

  @override
  _HealthDataState createState() => _HealthDataState();
}

class _HealthDataState extends State<HealthData> {
  Map data = {'bsdata': 0, 'bpdata': 0};
  bool liveUpdate = false;

  void updateDataFetchState() {
    setState(() {
      liveUpdate = liveUpdate;
      setUpTimedFetch();
    });
  }

  @override
  void initState() {
    super.initState();
    HttpService.getData().then((value) => setState(() {
          data = jsonDecode(value);
        }));
    setUpTimedFetch();
  }

  Timer timer;
  bool started = false;
  setUpTimedFetch() {
    if (liveUpdate) {
      started = true;
      print('Started $started, liveUpdate $liveUpdate');
      timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
        HttpService.getData().then((value) => setState(() {
              data = jsonDecode(value);
            }));
        if (started && !liveUpdate) {
          print('Timer cancel');
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    liveUpdate = Provider.of<LiveUpdate>(context).getLiveStatus;
    if (liveUpdate) {
      updateDataFetchState();
    }
    // print(liveUpdate);
    return RichText(
      text: TextSpan(
        style: TextStyle(color: kTextColor),
        children: [
          TextSpan(
            text: '${data[widget.dataname]}  ',
            style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          TextSpan(
            text: '${widget.rate}',
            style: TextStyle(
              fontSize: 13,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
