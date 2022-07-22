class Channels{
  final String channelId;
  final String title;

  Channels({required this.channelId, required this.title});
}

List<Channels> channelsCreated = [
  Channels(channelId: "1", title: "department of electrical engineering"),
  Channels(channelId: "2", title: "fire department field agent"),
];

List<Channels> channelsConnected = [
  Channels(channelId: "1", title: "department of construction engineering"),
  Channels(channelId: "2", title: "pipeline fittings and fluid engineering"),
];