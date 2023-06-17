part of 'event_cubit.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

class FileCreationLoading extends EventState {}

class FileCreationLoaded extends EventState {}

class FileCreationError extends EventState {}
