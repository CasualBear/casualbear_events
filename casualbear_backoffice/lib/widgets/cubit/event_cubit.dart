import 'dart:convert';
import 'dart:html' as html;
import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:flutter/material.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;
  EventCubit(this.repository) : super(EventInitial());

  void createFile(html.File formData) async {
    emit(FileCreationLoading());
    try {
      // TODO send
      //await repository.createFile(formData);
      emit(FileCreationLoaded());
    } catch (e) {
      emit(FileCreationError());
    }
  }
}
