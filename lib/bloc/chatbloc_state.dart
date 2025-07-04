part of 'chatbloc_bloc.dart';

@immutable
sealed class ChatblocState {}

final class ChatblocInitial extends ChatblocState {}

class ChatSuccessState extends ChatblocState{
  final List<Chatmodel>message;

  ChatSuccessState({required this.message});
}
