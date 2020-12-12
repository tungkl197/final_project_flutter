import 'package:equatable/equatable.dart';
import 'package:final_project_flutter/model/countries.dart';
import 'package:final_project_flutter/model/global.dart';

class NcovidInfoState extends Equatable {
  final List<String> countryName;
  final List<Country> lstCountries;
  final Country countryInfo;
  final Global gbInfo;
  final String errorMessage;
  final String dateUpdate;
  final String selectedCountry;
  final String successMessage;
  NcovidInfoState(
      {this.countryName,
      this.countryInfo,
      this.gbInfo,
      this.lstCountries,
      this.errorMessage,
      this.dateUpdate,
      this.selectedCountry,
      this.successMessage});

  NcovidInfoState copyWith(
          {List<String> countryName,
          Country countryInfo,
          Global gbInfo,
          List<Country> lstCountries,
          String errorMessage,
          String dateUpdate,
          String selectedCountry,
          String successMessage}) =>
      NcovidInfoState(
          countryName: countryName,
          countryInfo: countryInfo,
          gbInfo: gbInfo,
          lstCountries: lstCountries,
          errorMessage: errorMessage,
          dateUpdate: dateUpdate,
          selectedCountry: selectedCountry,
          successMessage: successMessage);

  @override
  // TODO: implement props
  List<Object> get props => [
        countryName,
        countryInfo,
        gbInfo,
        lstCountries,
        errorMessage,
        dateUpdate,
        selectedCountry,
        successMessage
      ];

  @override
  bool operator ==(Object other) {
    if (props == null || props.isEmpty) {
      return false;
    }
    return super == other;
  }

  @override
  bool get stringify {
    return true;
  }

  @override
  int get hashCode {
    return super.hashCode;
  }
}
