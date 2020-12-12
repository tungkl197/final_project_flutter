import 'package:equatable/equatable.dart';

abstract class NcovidInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialEvent extends NcovidInfoEvent {}

class ChangeCountryEvent extends NcovidInfoEvent {
  final String countryCode;
  ChangeCountryEvent(this.countryCode);
}

class RefeshEvent extends NcovidInfoEvent {}

