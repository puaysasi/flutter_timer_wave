import 'package:equatable/equatable.dart';

/*
TimerState are:
Ready:
  >StartTimer->Running
Running:
  >Pause->Paused
  >Reset->Ready
Paused:
  >Resume->Running
  >Reset->Ready
Finished
  >Reset->Ready

 */
abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];

}

class Ready extends TimerState {

  const Ready(int duration) : super(duration);

  @override
  String toString() => "Ready { duration : $duration }";


}

class Running extends TimerState {
  const Running(int duration) : super(duration);

  @override
  String toString() {
    return "Running { duration : $duration }";
  }


}

class Paused extends TimerState {
  const Paused(int duration) : super(duration);

  @override
  String toString() {
    return "Paused { duration : $duration }";
  }
}

class Finished extends TimerState {
  const Finished() : super(0);

  @override
  String toString() {
    return "Finished { duration : $duration }";
  }
}