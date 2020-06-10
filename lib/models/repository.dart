class Repository {
  final String author;
  final String repoName;
  final String avatarUrl;
  final String repoUrl;
  final String description;
  final String language;
  final String languageColor;
  final int stars;
  final int forks;
  final int currentPeriodStars;

  Repository({
    this.author,
    this.repoName,
    this.avatarUrl,
    this.repoUrl,
    this.description,
    this.language,
    this.languageColor,
    this.stars,
    this.forks,
    this.currentPeriodStars,
  });
}