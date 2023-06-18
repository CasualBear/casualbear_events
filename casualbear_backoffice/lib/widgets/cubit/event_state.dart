part of 'event_cubit.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

class EventCreationLoading extends EventState {}

class EventCreationLoaded extends EventState {}

class EventCreationError extends EventState {}

class EventGetLoading extends EventState {}

class EventGetLoaded extends EventState {
  final List<Event> events;

  EventGetLoaded(this.events);
}

class EventGetError extends EventState {}
