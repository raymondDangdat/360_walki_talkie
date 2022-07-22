class ChannelTypeModel{
  final String channelId;
  final String channelType;

  ChannelTypeModel({required this.channelId, required this.channelType});
}

List<ChannelTypeModel> channelTypes = [
  ChannelTypeModel(channelId: "1", channelType: "Open (any one can talk)"),
  ChannelTypeModel(channelId: "2", channelType: "close circle(Only approved users can talk, any one else can listen)"),
  ChannelTypeModel(channelId: "3", channelType: "semi close circle (only approved users can talk and listen)"),
  ChannelTypeModel(channelId: "4", channelType: "close corridor (only moderators can talk, anyone can only listen)"),
];