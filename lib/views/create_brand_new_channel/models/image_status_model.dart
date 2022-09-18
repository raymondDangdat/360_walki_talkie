class ImageStatusModel{
  final String channelId;
  final String image;
  final String slug;

  ImageStatusModel({required this.channelId,
    required this.image, required this.slug});
}

List<ImageStatusModel> imageStatuses = [
  ImageStatusModel(channelId: "1", image: "Disable - Nobody can send images",
      slug: "disabled"),
  ImageStatusModel(channelId: "2", image: "Enable - Anyone can send images",
      slug: "enabled"
  ),
  ImageStatusModel(channelId: "3",
    image: "Pre-Moderated - Images are approved by admin",
      slug: "pre-moderated"),
];