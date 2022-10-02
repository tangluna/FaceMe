// Walkthrough Slide Class for onboarding process
class WTSlide {
  String imagePath;
  String title;
  String desc;

  WTSlide({required this.imagePath, required this.title, required this.desc});

  void setImagePath(String getImagePath) {
    imagePath = getImagePath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImagePath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}