class Country {
  String countryName;
  String countryCode;
  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;

  Country(
      {this.countryName,
      this.countryCode,
      this.newConfirmed,
      this.totalConfirmed,
      this.newDeaths,
      this.totalDeaths,
      this.newRecovered,
      this.totalRecovered});

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
      countryName: parsedJson['Country'].toString(),
      countryCode: parsedJson['CountryCode'].toString(),
      newConfirmed: int.parse(parsedJson['NewConfirmed'].toString()),
      totalConfirmed: int.parse(parsedJson['TotalConfirmed'].toString()),
      newDeaths: int.parse(parsedJson['NewDeaths'].toString()),
      totalDeaths: int.parse(parsedJson['TotalDeaths'].toString()),
      newRecovered: int.parse(parsedJson['NewRecovered'].toString()),
      totalRecovered: int.parse(parsedJson['TotalRecovered'].toString()),
    );
  }
}
