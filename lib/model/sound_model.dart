class SoundModel {
  int? status;
  String? message;
  List<SoundData>? data;

  SoundModel({this.status, this.message, this.data});

  SoundModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SoundData>[];
      json['data'].forEach((v) {
        data!.add(SoundData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoundData {
  int? soundCategoryId;
  String? soundCategoryName;
  String? soundCategoryProfile;
  List<SoundList>? soundList;

  SoundData({
    this.soundCategoryId,
    this.soundCategoryName,
    this.soundCategoryProfile,
    this.soundList,
  });

  SoundData.fromJson(Map<String, dynamic> json) {
    soundCategoryId = json['sound_category_id'];
    soundCategoryName = json['sound_category_name'];
    soundCategoryProfile = json['sound_category_profile'];
    if (json['sound_list'] != null) {
      soundList = <SoundList>[];
      json['sound_list'].forEach((v) {
        soundList!.add(SoundList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sound_category_id'] = soundCategoryId;
    data['sound_category_name'] = soundCategoryName;
    data['sound_category_profile'] = soundCategoryProfile;
    if (soundList != null) {
      data['sound_list'] = soundList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoundList {
  int? soundId;
  int? soundCategoryId;
  String? soundTitle;
  String? sound;
  String? duration;
  String? singer;
  String? soundImage;
  String? addedBy;
  int? isDeleted;
  int? createdBy;
  String? recordLabel;
  String? distributeAs;
  String? trackName;
  String? songwriterName;
  String? producers;
  String? featuredArtista;
  String? explicitContent;
  String? instrumental;
  String? createdAt;
  String? updatedAt;

  SoundList({
    this.soundId,
    this.soundCategoryId,
    this.soundTitle,
    this.sound,
    this.duration,
    this.singer,
    this.soundImage,
    this.addedBy,
    this.isDeleted,
    this.createdBy,
    this.recordLabel,
    this.distributeAs,
    this.trackName,
    this.songwriterName,
    this.producers,
    this.featuredArtista,
    this.explicitContent,
    this.instrumental,
    this.createdAt,
    this.updatedAt,
  });

  SoundList.fromJson(Map<String, dynamic> json) {
    soundId = json['sound_id'];
    soundCategoryId = json['sound_category_id'];
    soundTitle = json['sound_title'];
    sound = json['sound'];
    duration = json['duration'];
    singer = json['singer'];
    soundImage = json['sound_image'];
    addedBy = json['added_by'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    recordLabel = json['record_label'];
    distributeAs = json['distribute_as'];
    trackName = json['track_name'];
    songwriterName = json['songwriter_name'];
    producers = json['producers'];
    featuredArtista = json['featured_artista'];
    explicitContent = json['explicit_content'];
    instrumental = json['instrumental'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sound_id'] = soundId;
    data['sound_category_id'] = soundCategoryId;
    data['sound_title'] = soundTitle;
    data['sound'] = sound;
    data['duration'] = duration;
    data['singer'] = singer;
    data['sound_image'] = soundImage;
    data['added_by'] = addedBy;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['record_label'] = recordLabel;
    data['distribute_as'] = distributeAs;
    data['track_name'] = trackName;
    data['songwriter_name'] = songwriterName;
    data['producers'] = producers;
    data['featured_artista'] = featuredArtista;
    data['explicit_content'] = explicitContent;
    data['instrumental'] = instrumental;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
