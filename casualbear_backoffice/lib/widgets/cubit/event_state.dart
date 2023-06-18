part of 'event_cubit.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

class EventCreationLoading extends EventState {}

class EventCreationLoaded extends EventState {}

class EventCreationError extends EventState {}
