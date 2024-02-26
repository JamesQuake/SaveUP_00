class CouponeModel {
  String _url, _timeStamp, _description, _title, _key, _userName;
  int _created;

  CouponeModel (this._url);

  CouponeModel.fromJson(this._key, Map data){
    _url = data["photo"];
    _description = data["description"];
    _userName = data['userName'];
    _created = data['created'];
    _title = data['tittle'];
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get description => _description;
  int get created => _created;
  String get timeStamp => _timeStamp;
  String get key => _key;
  String get username => _userName;
  String get title => _title;
}