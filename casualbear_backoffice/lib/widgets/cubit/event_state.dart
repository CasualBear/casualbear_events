part of 'event_cubit.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

// Create
class EventCreationLoading extends EventState {}

class EventCreationLoaded extends EventState {}

class EventCreationError extends EventState {}

// Get
class EventGetLoading extends EventState {}

class EventGetLoaded extends EventState {
  final List<Event> events;

  EventGetLoaded(this.events);
}

class EventGetError extends EventState {}

/// Delete

class EventDeleteLoading extends EventState {}

class EventDeleteLoaded extends EventState {}

class EventDeleteError extends EventState {}
