// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class PostSerializer
// **************************************************************************

abstract class _$PostSerializer implements Serializer<Post> {
  Map toMap(Post model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.title != null) {
        ret["title"] = model.title;
      }
      if (model.message != null) {
        ret["message"] = model.message;
      }
      if (model.likes != null) {
        ret["likes"] = model.likes;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  Post fromMap(Map map, {Post model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Post) {
      model = createModel();
    }
    model.id = map["id"];
    model.title = map["title"];
    model.message = map["message"];
    model.likes = map["likes"];
    return model;
  }

  String modelString() => "Post";
}
