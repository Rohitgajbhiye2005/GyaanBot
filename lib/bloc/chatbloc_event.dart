part of 'chatbloc_bloc.dart';

@immutable
sealed class ChatblocEvent {}

class ChatGenerateNewTextMessageEvent extends ChatblocEvent{
  final String inputmessage;

  ChatGenerateNewTextMessageEvent({required this.inputmessage});
}
