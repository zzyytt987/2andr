import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/message_models.dart';

class MessageRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<List<Conversation>> getConversations() async {
    final response = await _dio.get(ApiConstants.conversations);
    return (response.data['data'] as List<dynamic>)
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessage>> getMessages(int conversationId) async {
    final response = await _dio.get(ApiConstants.conversationMessages(conversationId));
    return (response.data['data'] as List<dynamic>)
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendMessage(int conversationId, String content) async {
    await _dio.post(ApiConstants.conversationMessages(conversationId), data: {
      'conversationId': conversationId,
      'content': content,
    });
  }

  Future<void> createConversation(int hrUserId, int jobId) async {
    await _dio.post(ApiConstants.conversations, data: {
      'hrUserId': hrUserId,
      'jobId': jobId,
    });
  }

  // Notifications
  Future<List<AppNotification>> getNotifications() async {
    final response = await _dio.get(ApiConstants.notifications);
    return (response.data['data'] as List<dynamic>)
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiConstants.unreadCount);
    return response.data['data']['count'] ?? 0;
  }

  Future<void> markAsRead(int id) async {
    await _dio.put('${ApiConstants.notifications}/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _dio.put('${ApiConstants.notifications}/read-all');
  }
}
