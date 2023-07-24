class AudioModel {
  dynamic id, path;
  AudioModel({this.id, this.path});
  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(id: json["id"], path: json["path"]);
  Map<String, dynamic> toJson() => {'id': id, 'path': path};
}