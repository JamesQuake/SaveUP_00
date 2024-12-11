class SavingModel {
  String _url, _key, _amount, _goal, _time, _goalAmount, _defaultIcon;
  num _created;
  String _goalId;

  SavingModel.fromJson(this._key, Map data) {
    _url = data["photo"];
    _created = data['created'];
    _goal = data['savingFor'].toString();
    _goalAmount = data['savingGoal'].toString();
    _amount = data['savingAmount'].toString();
    _time = data['savingTime'];
    _goalId = data['goalId'].toString();
  }

  set url(String value) {
    _url = value;
  }

  set defaultIcon(String value) {
    _defaultIcon = value;
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

  set goalId(String value) {
    _goalId = value;
  }

  String get amount => _amount;
  String get defaultIcon => _defaultIcon;
  String get goalAmount => _goalAmount;
  num get created => _created;
  String get key => _key;
  String get goal => _goal;
  String get goalId => _goalId;
  String get url => _url;
  String get time => _time;
}
