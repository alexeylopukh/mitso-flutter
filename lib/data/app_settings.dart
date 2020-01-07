class AppSettings {
  bool isVibrationEnabled;

  AppSettings({
    this.isVibrationEnabled = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        isVibrationEnabled: json["isVibrationEnabled"] == null
            ? true
            : json["isVibrationEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "isVibrationEnabled":
            isVibrationEnabled == null ? null : isVibrationEnabled,
      };
}
