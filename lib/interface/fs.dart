import 'package:wangpan_client/constants/file.dart';

class FsContent {
  final String name;
  final int size;
  final bool is_dir;
  final String modified;
  final String sign;
  final String thumb;
  final int type;
  final String id;
  final String path;
  final String? created;
  final Map<String, dynamic>? hashinfo;
  final Map<String, dynamic>? hash_info;

  const FsContent({
    required this.name,
    required this.size,
    required this.is_dir,
    required this.modified,
    required this.sign,
    required this.thumb,
    required this.type,
    required this.id,
    required this.path,
    this.created,
    this.hashinfo,
    this.hash_info,
  });

  factory FsContent.fromJson(Map<String, dynamic> json) {
    dynamic hashinfo = json['hashinfo'] is String ? null : json['hashinfo'];
    dynamic hash_info = json['hash_info'] is String ? null : json['hash_info'];
    return FsContent(
      name: json['name'],
      size: json['size'],
      is_dir: json['is_dir'],
      modified: json['modified'],
      sign: json['sign'],
      thumb: json['thumb'],
      type: json['type'],
      id: json['id'],
      path: json['path'],
      created: json['created'],
      hashinfo: hashinfo,
      hash_info: hash_info,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'is_dir': is_dir,
      'modified': modified,
      'sign': sign,
      'thumb': thumb,
      'type': type,
      'id': id,
      'path': path,
      'created': created,
      'hashinfo': hashinfo,
      'hash_info': hash_info,
    };
  }

  String toString() {
    return 'FsContent(name: $name, size: $size, is_dir: $is_dir, modified: $modified, sign: $sign, thumb: $thumb, type: $type, id: $id, path: $path, created: $created, hashinfo: $hashinfo, hash_info: $hash_info)';
  }
}

class FsListResponseData {
  final List<FsContent> content;
  final int total;
  final String readme;
  final bool write;
  final String provider;
  final String header;

  const FsListResponseData({
    required this.content,
    required this.total,
    required this.readme,
    required this.write,
    required this.provider,
    required this.header,
  });

  factory FsListResponseData.fromJson(Map<String, dynamic> json) {
    return FsListResponseData(
      content: List<FsContent>.from(
        json['content'].map(
          (x) => FsContent.fromJson(x),
        ),
      ),
      total: json['total'],
      readme: json['readme'],
      write: json['write'],
      provider: json['provider'],
      header: json['header'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((x) => x.toJson()).toList(),
      'total': total,
      'readme': readme,
      'write': write,
      'provider': provider,
      'header': header,
    };
  }
}

class FsListRequest {
  final String? path;
  final String? password;
  final int page;
  final int per_page; // 每页数目
  final bool refresh; // 是否强制刷新

  const FsListRequest({
    required this.path,
    required this.page,
    required this.per_page,
    required this.refresh,
    this.password,
  });

  factory FsListRequest.fromJson(Map<String, dynamic> json) {
    return FsListRequest(
      path: json['path'],
      page: json['page'],
      per_page: json['per_page'],
      refresh: json['refresh'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'page': page,
      'per_page': per_page,
      'refresh': refresh,
      'password': password,
    };
  }
}

class GetFsDataRequest {
  final String path;
  final String? password;
  final int? page;
  final int? per_page;
  final bool? refresh; // 是否强制刷新

  const GetFsDataRequest({
    required this.path,
    this.password,
    this.page,
    this.per_page,
    this.refresh,
  });

  factory GetFsDataRequest.fromJson(Map<String, dynamic> json) {
    return GetFsDataRequest(
      path: json['path'],
      password: json['password'],
      page: json['page'],
      per_page: json['per_page'],
      refresh: json['refresh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'password': password,
      'page': page,
      'per_page': per_page,
      'refresh': refresh,
    };
  }
}

class GetFsDataResponse {
  final String name;
  final int size;
  final bool is_dir;
  final String modified;
  final String sign;
  final String thumb;
  final int type;
  final String raw_url; // 原始链接
  final String readme;
  final String provider;
  final Null related;
  final String created;
  final String hashinfo;
  final Map<String, dynamic>? hash_info;
  final String header;

  const GetFsDataResponse({
    required this.name,
    required this.size,
    required this.is_dir,
    required this.modified,
    required this.sign,
    required this.thumb,
    required this.type,
    required this.raw_url,
    required this.readme,
    required this.provider,
    required this.related,
    required this.created,
    required this.hashinfo,
    required this.hash_info,
    required this.header,
  });

  factory GetFsDataResponse.fromJson(Map<String, dynamic> json) {
    String hashinfo = json['hashinfo'] is String ? '' : json['hashinfo'];
    dynamic hash_info = json['hash_info'] is String ? '' : json['hash_info'];
    return GetFsDataResponse(
      created: json['created'],
      name: json['name'],
      size: json['size'],
      is_dir: json['is_dir'],
      modified: json['modified'],
      sign: json['sign'],
      thumb: json['thumb'],
      type: json['type'],
      raw_url: json['raw_url'],
      readme: json['readme'],
      provider: json['provider'],
      related: json['related'],
      hashinfo: hashinfo,
      hash_info: hash_info,
      header: json['header'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'name': name,
      'size': size,
      'is_dir': is_dir,
      'modified': modified,
      'sign': sign,
      'thumb': thumb,
      'type': type,
      'raw_url': raw_url,
      'readme': readme,
      'provider': provider,
      'related': related,
      'hashinfo': hashinfo,
      'hash_info': hash_info,
      'header': header,
    };
  }
}

class FileViewRouterParams {
  // final MyFileType fileType;
  final String path;
  // final String name;
  final String? password;
  
  const FileViewRouterParams({
    // required this.fileType,
    required this.path,
    // required this.name,
    this.password,
  });

  factory FileViewRouterParams.fromJson(Map<String, dynamic> json) {
    return FileViewRouterParams(
      // fileType: FileTypeExtension.fromExtension(json['fileType']),
      path: json['path'],
      // name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'fileType': fileType.name,
      'path': path,
      // 'name': name,
      'password': password,
    };
  }
}