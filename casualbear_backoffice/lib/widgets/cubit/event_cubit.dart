import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
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

  void updateEvent(List<int> selectedFile, String name, String description, String color, String eventId) async {
    emit(EventCreationLoading());
    try {
      await repository.updateEvent(selectedFile, name, description, color, eventId);
      emit(EventCreationLoaded());
    } catch (e) {
      emit(EventCreationError());
    }
  }

  void getEvents() async {
    emit(EventGetLoading());
    try {
      List<Event> response = await repository.getEvent();
      emit(EventGetLoaded(response));
    } catch (e) {
      emit(EventGetError());
    }
  }

  void deleteEvent(String eventId) async {
    emit(EventDeleteLoading());
    try {
      await repository.deleteEvent(eventId);
      emit(EventDeleteLoaded());
    } catch (e) {
      emit(EventDeleteError());
    }
  }
}
