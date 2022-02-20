import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final HomeRepository homeRepository;
  int currentTabIndex = 0;

  HomeBloc({required this.homeRepository}) : super(null as HomeState) {
    on<HomeEvent>(
      (event, emit) {
        if (event is ChangeTabIndexEvent) {_mapChangeTabIndex(event);}
      }
    );
  }

  @override
  Future<void> close() async {
    super.close();
  }

  void _mapChangeTabIndex(ChangeTabIndexEvent changeTabIndexEvent) async {
    currentTabIndex = changeTabIndexEvent.tabIndex;
    emit(TabIndexState(tabIndex: changeTabIndexEvent.tabIndex));
  }
}