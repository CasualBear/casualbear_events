part of 'generic_cubit.dart';

@immutable
abstract class GenericState {}

class GenericInitial extends GenericState {}

// Get
class EventGetLoading extends GenericState {}

class EventGetLoaded extends GenericState {
  final Event event;

  EventGetLoaded(this.event);
}

class EventGetError extends GenericState {}
