class LanguageModel{
  final String channelId;
  final String channelType;

  LanguageModel({required this.channelId, required this.channelType});
}

List<LanguageModel> languages = [
  LanguageModel(channelId: "1", channelType: "English"),
  LanguageModel(channelId: "2", channelType: "Hausa"),
  LanguageModel(channelId: "3", channelType: "Igbo"),
  LanguageModel(channelId: "4", channelType: "Yoruba"),
];