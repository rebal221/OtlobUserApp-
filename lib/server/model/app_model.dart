class AppModel {
  String primaryColor = '';
  String secondColor = '';
  String appLogo = '';
  String appName = '';
  String appPhone = '';
  String appPrivacy = '';
  String appOnGooglePlay = '';
  String appOnAppstore = '';
  String appFacebook = '';
  String appTwitter = '';
  String appYoutube = '';
  String currency = '';
  bool appActive = true;
  int appVersionGoogle = 1;
  int appVersionAppStore = 1;

  AppModel.data(
      {required this.primaryColor,
      required this.secondColor,
      required this.appLogo,
      required this.appName,
      required this.appPhone,
      required this.appPrivacy,
      required this.appOnGooglePlay,
      required this.appOnAppstore,
      required this.appFacebook,
      required this.appTwitter,
      required this.appYoutube,
      required this.appActive,
      required this.appVersionGoogle,
      required this.appVersionAppStore,
      required this.currency});

  AppModel();

  static AppModel appModelSnapshot(var documentSnapshot) {
    AppModel appModel = AppModel.data(
        primaryColor: documentSnapshot['primaryColor'],
        secondColor: documentSnapshot['secondColor'],
        appLogo: documentSnapshot['appLogo'],
        appName: documentSnapshot['appName'],
        appPhone: documentSnapshot['appPhone'],
        appPrivacy: documentSnapshot['appPrivacy'],
        appOnGooglePlay: documentSnapshot['appOnGooglePlay'],
        appOnAppstore: documentSnapshot['appOnAppstore'],
        appFacebook: documentSnapshot['appFacebook'],
        appTwitter: documentSnapshot['appTwitter'],
        appYoutube: documentSnapshot['appYoutube'],
        appActive: documentSnapshot['appActive'],
        currency: documentSnapshot['currency'],
        appVersionGoogle: documentSnapshot['appVersionGoogle'],
        appVersionAppStore: documentSnapshot['appVersionAppStore']);
    return appModel;
  }
}
