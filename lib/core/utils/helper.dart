class Helper {
  static int calculateReadingTime(String content) {
    var wordCount = content.split(RegExp(r'\s+')).length;
    var readingTime = wordCount / 200;
    return readingTime.ceil();
  }
}
