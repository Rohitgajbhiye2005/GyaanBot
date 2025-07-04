import 'dart:convert';

class Chatmodel {
  /// The role of the message sender - must be either 'user' or 'model'
  final String role;
  
  /// List of content parts (currently only text is supported)
  final List<ChatPart> parts;

  Chatmodel({
    required this.role,
    required this.parts,
  }) {
    // Validate role
    if (role != 'user' && role != 'model') {
      throw ArgumentError('Role must be either "user" or "model"');
    }
    
    // Validate parts
    if (parts.isEmpty) {
      throw ArgumentError('Parts cannot be empty');
    }
  }

  /// Creates a user message (convenience factory)
  factory Chatmodel.userMessage(String text) {
    return Chatmodel(
      role: 'user',
      parts: [ChatPart(text: text)],
    );
  }

  /// Creates a model message (convenience factory)
  factory Chatmodel.modelMessage(String text) {
    return Chatmodel(
      role: 'model',
      parts: [ChatPart(text: text)],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'parts': parts.map((e) => e.toMap()).toList(),
    };
  }

  factory Chatmodel.fromMap(Map<String, dynamic> map) {
    return Chatmodel(
      role: map['role'] as String,
      parts: map['parts'] != null
          ? List<ChatPart>.from(
              (map['parts'] as List).map((x) => ChatPart.fromMap(x)))
          : throw ArgumentError('Parts cannot be null'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatmodel.fromJson(String source) =>
      Chatmodel.fromMap(json.decode(source));
}

class ChatPart {
  final String text;

  ChatPart({required this.text}) {
    if (text.isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory ChatPart.fromMap(Map<String, dynamic> map) {
    return ChatPart(
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatPart.fromJson(String source) =>
      ChatPart.fromMap(json.decode(source));
}