import 'package:flutter/foundation.dart';

class LiveUpdate with ChangeNotifier, DiagnosticableTreeMixin {
  bool _liveUpdate = false;

  bool get getLiveStatus => _liveUpdate;

  void changeLiveStatus() {
    _liveUpdate = !_liveUpdate;
    notifyListeners();
  }

  // Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('LiveUpdate', getLiveStatus.toString()));
  }
}
