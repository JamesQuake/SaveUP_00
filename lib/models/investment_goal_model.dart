class InvestmentModel {
  String _url, _key, _amount, _goal, _time, _goalAmount, _defaultIcon;
  String _goalId;
  num _created;

  InvestmentModel.fromJson(this._key, Map data) {
    _url = data["photo"];
    _created = data['created'];
    _goal = data['investFor'];
    _amount = data['investAmount'].toString();
    _goalAmount = data['investGoal'].toString();
    _time = data['investTime'];
    _goalId = data['goalId'];
  }

  set url(String value) {
    _url = value;
  }

  set amount(String value) {
    _amount = value;
  }

  set goal(String value) {
    _goal = value;
  }

  set time(String value) {
    _time = value;
  }

  set goalAmount(String value) {
    _goalAmount = value;
  }

  set defaultIcon(String value) {
    _defaultIcon = value;
  }

  set goalId(String value) {
    _goalId = value;
  }

  String get defaultIcon => _defaultIcon;
  String get amount => _amount;
  String get goalAmount => _goalAmount;
  String get goalId => _goalId;
  num get created => _created;
  String get key => _key;
  String get goal => _goal;
  String get url => _url;
  String get time => _time;
}
