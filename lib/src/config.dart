
class Config {
  Map _raw;
  Config([this._raw]){
    if (this._raw == null) {
      this._raw = {
        'titleToken': '=',
        'upperToken': '*',
        'lowerToken': '_',
      };
    }
  }
  void set(String key, dynamic value){
    _raw[key] = value;
  }

  bool has(String key){
    return _raw[key] != null;
  }

  T get<T extends dynamic>(String key){
    return _raw[key];
  }
}