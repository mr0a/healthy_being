import 'package:flutter/material.dart';

import '../widgets/data_card.dart';
import '../widgets/info_card.dart';

class DataDisplay extends StatelessWidget {
  const DataDisplay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        InfoCard(
          title: "Heartbeat Rate",
          iconColor: Color(0xFFFF9C00),
          dataname: 'hrdata',
          asset: 'assets/icons/running.svg',
          rate: 'beats/min',
        ),
        InfoCard(
          title: "SpO2 Rate",
          iconColor: Color(0xFFFF9D55),
          dataname: 'srdata',
          asset: 'assets/icons/blood-oxygen.svg',
          rate: 'Percent',
        ),
        InfoCard(
          title: "Blood Pressure",
          iconColor: Color(0xFF501590),
          dataname: 'bpdata',
          asset: 'assets/icons/Blood_Pressure.svg',
          rate: 'mmHg',
        ),
        InfoCard(
          title: "Blood Sugar",
          iconColor: Color(0xFF5856D6),
          dataname: 'bsdata',
          asset: 'assets/icons/diabetes.svg',
          rate: 'mg/dL',
        ),
        DataCard(
          title: "Body Temperature",
          iconColor: Color(0xFF553412),
          dataname: 'respdata',
          asset: 'assets/icons/temperature.svg',
          rate: 'Degree Celcius',
        ),
        DataCard(
          title: "Respiration Rate",
          iconColor: Color(0xFF58A85C),
          dataname: 'btdata',
          asset: 'assets/icons/breath.svg',
          rate: 'respiration/min',
        ),
      ],
    );
  }
}
