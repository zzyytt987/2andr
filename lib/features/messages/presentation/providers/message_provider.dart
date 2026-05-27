import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message_models.dart';
import '../../data/datasources/message_remote_datasource.dart';

final messageDataSourceProvider = Provider<MessageRemoteDataSource>((ref) => MessageRemoteDataSource());

final conversationsProvider = FutureProvider<List<Conversation>>((ref) {
  return ref.read(messageDataSourceProvider).getConversations();
});

final unreadCountProvider = FutureProvider<int>((ref) {
  return ref.read(messageDataSourceProvider).getUnreadCount();
});

final messagesProvider = FutureProvider.family<List<ChatMessage>, int>(
  (ref, conversationId) {
    return ref.read(messageDataSourceProvider).getMessages(conversationId);
  },
);
