import 'package:bloc/bloc.dart';
import 'package:casualbear_website/network/models/event.dart';
import 'package:casualbear_website/screens/repository/generic_repository.dart';
import 'package:meta/meta.dart';

part 'generic_state.dart';

class GenericCubit extends Cubit<GenericState> {
  final GenericRepository genericRepository;
  GenericCubit(this.genericRepository) : super(GenericInitial());

  void getEvents(String eventId) async {
    emit(EventGetLoading());
    try {
      Event response = await genericRepository.getEventDetails(eventId);
      emit(EventGetLoaded(response));
    } catch (e) {
      emit(EventGetError());
    }
  }
}
