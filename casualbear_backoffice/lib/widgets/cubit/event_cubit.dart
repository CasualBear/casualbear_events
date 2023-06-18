import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:flutter/material.dart';
part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;
  EventCubit(this.repository) : super(EventInitial());

  void createEvent(List<int> selectedFile, String name, String description, String color) async {
    emit(EventCreationLoading());
    try {
      await repository.createEvent(selectedFile, name, description, color);
      emit(EventCreationLoaded());
    } catch (e) {
      emit(EventCreationError());
    }
  }
}
