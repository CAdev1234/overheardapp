import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/ui/home/repository/home.repository.dart';

import 'home.event.dart';
import 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final HomeRepository homeRepository;
  int currentTabIndex = 0;

  HomeBloc({required this.homeRepository}) : super(null as HomeState);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is ChangeTabIndexEvent){
      yield* _mapChangeTabIndex(event);
    }
  }

  Stream<HomeState> _mapChangeTabIndex(ChangeTabIndexEvent changeTabIndexEvent) async* {
    this.currentTabIndex = changeTabIndexEvent.tabIndex;
    yield new TabIndexState(tabIndex: changeTabIndexEvent.tabIndex);
  }
}