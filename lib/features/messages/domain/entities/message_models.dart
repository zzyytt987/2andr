class Conversation {
  final int id;
  final int userId;
  final int hrUserId;
  final int? jobId;
  final String? jobTitle;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final String? hrName;
  final String? hrAvatarUrl;

  const Conversation({
    required this.id,
    required this.userId,
    required this.hrUserId,
    this.jobId,
    this.jobTitle,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.hrName,
    this.hrAvatarUrl,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      userId: json['userId'] as int? ?? 0,
      hrUserId: json['hrUserId'] as int? ?? 0,
      jobId: json['jobId'] as int?,
      jobTitle: json['jobTitle'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
      unreadCount: json['unreadCount'] as int? ?? 0,
      hrName: json['hrName'] as String?,
      hrAvatarUrl: json['hrAvatarUrl'] as String?,
    );
  }
}

class ChatMessage {
  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final String messageType;
  final bool isRead;
  final String? createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.messageType = 'TEXT',
    this.isRead = false,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      conversationId: json['conversationId'] as int? ?? 0,
      senderId: json['senderId'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'TEXT',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }
}

class AppNotification {
  final int id;
  final String title;
  final String? content;
  final String type;
  final bool isRead;
  final int? relatedId;
  final String? createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    this.content,
    required this.type,
    this.isRead = false,
    this.relatedId,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      type: json['type'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      relatedId: json['relatedId'] as int?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
