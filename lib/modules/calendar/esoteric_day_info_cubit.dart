import 'package:bloc/bloc.dart';

abstract class DayInfoState {}

class EsotericDayInfoCubit extends Cubit<DayInfoState> {
  EsotericDayInfoCubit(DayInfoState initialState) : super(initialState);
}
