class Article {
  final String? title; // Title of the article
  final String? description; // Short description of the article
  final String? imageUrl; // URL of the article's image (newly added field)
  final String? publishedAt; // The publication date of the article

  // Constructor to initialize an Article object.
  // All fields are optional (nullable) based on the data that might be received.
  Article({this.title, this.description, this.imageUrl, this.publishedAt});

  // Factory method to create an Article instance from a JSON map.
  // This is used to convert the raw JSON response into an Article object.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  // Optionally, you can add a `toJson` method to convert an Article instance back to JSON
  // if you need to send it back to the server or save it.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt,
    };
  }

  // Logging for debugging: Print the Article details
  void logArticleDetails() {
    print('Article:');
    print('Title: $title');
    print('Description: $description');
    print('Image URL: $imageUrl');
    print('Published At: $publishedAt');
  }
}
