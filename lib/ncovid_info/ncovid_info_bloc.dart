import 'package:final_project_flutter/model/countries.dart';
import 'package:final_project_flutter/model/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ncovid_info_event.dart';
import 'ncovid_info_state.dart';
import 'package:final_project_flutter/data/data_countries.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class NcovidInfoBloc extends Bloc<NcovidInfoEvent, NcovidInfoState> {
  NcovidInfoBloc() : super(NcovidInfoState()) {}

  @override
  Stream<NcovidInfoState> mapEventToState(NcovidInfoEvent event) async* {
    switch (event.runtimeType) {
      case InitialEvent:
        List<String> lstC = [];
        lstCountryPicker.forEach((element) {
          lstC.add(element.name);
        });
        final url = "https://api.covid19api.com/summary";
        var response = await get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          var globalJson = jsonResponse['Global'];
          var countriesJson = jsonResponse['Countries'];

          var formatter = new DateFormat('dd-MM-yyyy HH:mm');
          String dateUpdate =
              formatter.format(DateTime.parse(jsonResponse['Date'].toString()));
          Global global = Global.fromJson(globalJson);
          List<Country> lstCountries = (countriesJson as List)
              .map((data) => new Country.fromJson(data))
              .toList();
          Country vnInfo;
          lstCountries.forEach((element) {
            if (element.countryCode == 'VN') {
              vnInfo = element;
            }
          });
          yield state.copyWith(
              countryInfo: vnInfo,
              gbInfo: global,
              lstCountries: lstCountries,
              countryName: lstC,
              dateUpdate: dateUpdate);
        } else {
          print("Lỗi");
          yield state.copyWith(
            errorMessage: "Lỗi",
            countryName: lstC,
          );
        }

        break;
      case ChangeCountryEvent:
        final _event = event as ChangeCountryEvent;
        final String countryCode = _event.countryCode;
        Country countryInfo;
        state.lstCountries.forEach((element) {
          if (element.countryCode == countryCode) {
            countryInfo = element;
          }
        });
        yield state.copyWith(
            countryInfo: countryInfo,
            countryName: state.countryName,
            lstCountries: state.lstCountries,
            gbInfo: state.gbInfo,
            dateUpdate: state.dateUpdate);
        break;
      case RefeshEvent:
        final url = "https://api.covid19api.com/summary";
        var response = await get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          var globalJson = jsonResponse['Global'];
          var countriesJson = jsonResponse['Countries'];

          var formatter = new DateFormat('dd-MM-yyyy HH:mm');
          String dateUpdate =
              formatter.format(DateTime.parse(jsonResponse['Date'].toString()));
          Global global = Global.fromJson(globalJson);
          List<Country> lstCountries = (countriesJson as List)
              .map((data) => new Country.fromJson(data))
              .toList();
          Country countryInfo;
          String selectedCountry = 'VN';
          if (state.selectedCountry != null) {
            selectedCountry = state.selectedCountry;
          }
          lstCountries.forEach((element) {
            if (element.countryCode == selectedCountry) {
              countryInfo = element;
            }
          });
          yield state.copyWith(
              countryInfo: countryInfo,
              gbInfo: global,
              lstCountries: lstCountries,
              countryName: state.countryName,
              dateUpdate: dateUpdate,
              successMessage: "Cập nhật thành công");
        } else {
          print("Lỗi");
          yield state.copyWith(
            errorMessage: "Lỗi",
            countryName: state.countryName,
          );
        }

        break;
      default:
        break;
    }
  }
}
