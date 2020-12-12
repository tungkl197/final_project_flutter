class Global {
  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;

  Global({this.newConfirmed, this.totalConfirmed, this.newDeaths, this.totalDeaths, this.newRecovered, this.totalRecovered});

  factory Global.fromJson(Map<String, dynamic> parsedJson) {
    return Global(
      newConfirmed: int.parse(parsedJson['NewConfirmed'].toString()),
      totalConfirmed: int.parse(parsedJson['TotalConfirmed'].toString()),
      newDeaths: int.parse(parsedJson['NewDeaths'].toString()),
      totalDeaths: int.parse(parsedJson['TotalDeaths'].toString()),
      newRecovered: int.parse(parsedJson['NewRecovered'].toString()),
      totalRecovered: int.parse(parsedJson['TotalRecovered'].toString()),
    );
  }
}