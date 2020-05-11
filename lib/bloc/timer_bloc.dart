import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:fluttertimerwave/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int _duration = 60;
  final Ticker _ticker;

  StreamSubscription _tickerSubscription;

  // things after colon is initializer. can be many, seperated by comma.
  // it's the list of expression
  TimerBloc({@required Ticker ticker}) : assert(ticker!=null), _ticker=ticker;


  @override
  TimerState get initialState => Ready(_duration);


  @override
  Future<Function> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    // TODO: Add Logic
    if (event is Start) {
      yield* mapStartToState(event);
    } else if (event is Tick) {
      yield* mapTickToState(event);
    } else if (event is Pause) {
      yield* mapPauseToState(event);
    } else if (event is Resume) {
      yield* mapResumeToState(event);
    } else if (event is Reset) {
      yield* mapResetToState(event);
    }
  }

  Stream<TimerState> mapStartToState(Start start) async* {
    yield Running(start.duration);
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) {
          add(Tick(duration: duration));
    });
  }


  Stream<TimerState> mapTickToState(Tick tick) async* {
    yield tick.duration > 0? Running(tick.duration) : Finished();

  }

  Stream<TimerState> mapPauseToState(Pause pause) async* {
    if (state is Running) {
      _tickerSubscription?.pause();
      yield Paused(state.duration);
    }
  }
  Stream<TimerState> mapResumeToState(Resume resume) async* {
    if(state is Paused) {
      _tickerSubscription?.resume();
      yield Running(state.duration);
    }
  }

  Stream<TimerState> mapResetToState(Reset event) async* {

      _tickerSubscription?.cancel();
      yield Ready(_duration);

  }



}
