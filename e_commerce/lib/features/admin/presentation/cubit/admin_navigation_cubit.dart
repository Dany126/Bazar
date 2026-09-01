import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNavigationCubit extends Cubit<int> {
  AdminNavigationCubit() : super(0);

  void updateIndex(int newIndex) {
    emit(newIndex);
  }
}
