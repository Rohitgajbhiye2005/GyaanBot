import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gyaanbot/model/chatmodel.dart';
import 'package:gyaanbot/repos/chatrepo.dart';

part 'chatbloc_event.dart';
part 'chatbloc_state.dart';

class ChatblocBloc extends Bloc<ChatblocEvent, ChatblocState> {
  ChatblocBloc() : super(ChatSuccessState(message: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  final List<Chatmodel> message = [];

  FutureOr<void> chatGenerateNewTextMessageEvent(
  ChatGenerateNewTextMessageEvent event,
  Emitter<ChatblocState> emit,
) async {
  // 1. Add user message
  final userMessage = Chatmodel(
    role: "user",
    parts: [ChatPart(text: event.inputmessage)],
  );
  message.add(userMessage);

  // 2. Emit user message immediately
  emit(ChatSuccessState(message: List.from(message)));

  // ✅ 3. Prepare valid history with only valid alternating messages
  List<Chatmodel> validMessages = [];

  for (int i = 0; i < message.length; i++) {
    final msg = message[i];
    if (msg.role == 'user' || msg.role == 'model') {
      validMessages.add(msg);
    }
  }

  // 4. Call Gemini API
  final geminiReply = await ChatRepo.chatTextGenerationRepo(validMessages);

  // 5. Add model response if valid
  if (geminiReply != null) {
    final modelMessage = Chatmodel(
      role: "model",
      parts: [ChatPart(text: geminiReply)],
    );
    message.add(modelMessage);
    emit(ChatSuccessState(message: List.from(message)));
  }
}

}
