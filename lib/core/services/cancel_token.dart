import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocCancelToken <E, S> on Bloc<E, S> {
  late final CancelToken cancelToken = CancelToken();

  void safeEmit(S state, Emitter<S> emitter) {
    if (!isClosed) emitter(state);
  }

  @override
  Future<void> close() {
    cancelToken.cancel("Bloc was closed");
    return super.close();
  }
}


