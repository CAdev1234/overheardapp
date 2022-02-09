import 'dart:io';
class MediaType{
  final int? type; // 0: image, 1: video
  final File? file;
  final String? url;
  MediaType({this.file, this.type, this.url});
}