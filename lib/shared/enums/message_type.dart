enum MessageType {
  text('TEXT'),
  image('IMAGE'),
  system('SYSTEM');

  final String value;
  const MessageType(this.value);
}
