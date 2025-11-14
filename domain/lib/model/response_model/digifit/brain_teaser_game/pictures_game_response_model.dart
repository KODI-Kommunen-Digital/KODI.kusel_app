import 'package:core/base_model.dart';

class PicturesGameResponseModel extends BaseModel<PicturesGameResponseModel> {
  final PicturesGameData? data;
  final String? status;

  PicturesGameResponseModel({this.data, this.status});

  @override
  PicturesGameResponseModel fromJson(Map<String, dynamic> json) {
    return PicturesGameResponseModel(
      data: json['data'] != null
          ? PicturesGameData().fromJson(json['data'])
          : null,
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'status': status,
      };
}

class PicturesGameData extends BaseModel<PicturesGameData> {
  final int? sourceId;
  final List<PictureGrid>? pictureGrid;
  final List<MemorizePair>? memorizePairs;
  final List<CheckPair>? checkPairs;

  /// existing ones (string only)
  final List<String>? allImages;
  final List<String>? displayImages;
  final String? missingImage;

  /// ✅ newly added lists with id + image objects
  final List<ImageWithId>? allImagesList;
  final List<ImageWithId>? displayImagesList;
  final List<ImageWithId>? missingImageList;

  final int? timer;
  final int? sessionId;
  final int? activityId;

  PicturesGameData({
    this.sourceId,
    this.pictureGrid,
    this.memorizePairs,
    this.checkPairs,
    this.allImages,
    this.displayImages,
    this.missingImage,
    this.allImagesList,
    this.displayImagesList,
    this.missingImageList,
    this.timer,
    this.sessionId,
    this.activityId,
  });

  @override
  PicturesGameData fromJson(Map<String, dynamic> json) {
    final pictureGridRaw = json['pictureGrid'];
    final memorizePairsRaw = json['memorizePairs'];
    final checkPairsRaw = json['checkPairs'];
    final allImagesRaw = json['allImages'];
    final displayImagesRaw = json['displayImages'];
    final missingImageRaw = json['missingImage'];

    return PicturesGameData(
      sourceId: json['sourceId'],
      pictureGrid: pictureGridRaw is List
          ? pictureGridRaw.map((e) => PictureGrid().fromJson(e)).toList()
          : null,
      memorizePairs: memorizePairsRaw is List
          ? memorizePairsRaw.map((e) => MemorizePair().fromJson(e)).toList()
          : null,
      checkPairs: checkPairsRaw is List
          ? checkPairsRaw.map((e) => CheckPair().fromJson(e)).toList()
          : null,

      // old (string only)
      allImages: allImagesRaw is List
          ? allImagesRaw.map((e) => e.toString()).toList()
          : null,
      displayImages: displayImagesRaw is List
          ? displayImagesRaw.map((e) => e.toString()).toList()
          : null,
      missingImage: missingImageRaw != null ? missingImageRaw.toString() : null,

      // ✅ new (object based)
      allImagesList: allImagesRaw is List
          ? allImagesRaw.map((e) => ImageWithId().fromJson(e)).toList()
          : null,
      displayImagesList: displayImagesRaw is List
          ? displayImagesRaw.map((e) => ImageWithId().fromJson(e)).toList()
          : null,
      missingImageList: missingImageRaw != null
          ? [ImageWithId().fromJson(missingImageRaw)]
          : null,

      timer: json['timer'],
      sessionId: json['sessionId'],
      activityId: json['activityId'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'pictureGrid': pictureGrid?.map((e) => e.toJson()).toList(),
        'memorizePairs': memorizePairs?.map((e) => e.toJson()).toList(),
        'checkPairs': checkPairs?.map((e) => e.toJson()).toList(),
        'allImages': allImages,
        'displayImages': displayImages,
        'missingImage': missingImage,
        'allImagesList': allImagesList?.map((e) => e.toJson()).toList(),
        'displayImagesList': displayImagesList?.map((e) => e.toJson()).toList(),
        'missingImageList': missingImageList?.map((e) => e.toJson()).toList(),
        'timer': timer,
        'sessionId': sessionId,
        'activityId': activityId,
      };
}

class PictureGrid extends BaseModel<PictureGrid> {
  final int? id;
  final String? image1;

  PictureGrid({this.id, this.image1});

  @override
  PictureGrid fromJson(Map<String, dynamic> json) {
    return PictureGrid(
      id: json['id'],
      image1: json['image1'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'image1': image1,
      };
}

class MemorizePair extends BaseModel<MemorizePair> {
  final int? id;
  final String? image1;
  final String? image2;

  MemorizePair({this.id, this.image1, this.image2});

  @override
  MemorizePair fromJson(Map<String, dynamic> json) {
    return MemorizePair(
      id: json['id'],
      image1: json['image1'],
      image2: json['image2'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'image1': image1,
        'image2': image2,
      };
}

class CheckPair extends BaseModel<CheckPair> {
  final int? id;
  final String? image1;
  final String? image2;
  final bool? isCorrect;

  CheckPair({this.id, this.image1, this.image2, this.isCorrect});

  @override
  CheckPair fromJson(Map<String, dynamic> json) {
    return CheckPair(
      id: json['id'],
      image1: json['image1'],
      image2: json['image2'],
      isCorrect: json['isCorrect'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'image1': image1,
        'image2': image2,
        'isCorrect': isCorrect,
      };
}

/// ✅ For lists that include both id and image
class ImageWithId extends BaseModel<ImageWithId> {
  final dynamic id;
  final String? image;

  ImageWithId({this.id, this.image});

  @override
  ImageWithId fromJson(Map<String, dynamic> json) {
    return ImageWithId(
      id: json['id'],
      image: json['image'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };
}
