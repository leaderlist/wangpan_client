class FsContent {
  final String name;
  final int size;
  final bool is_dir;
  final String modified;
  final String sign;
  final String thumb;
  final int type;
  final String id;
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
      'created': created,
      'hashinfo': hashinfo,
      'hash_info': hash_info,
    };
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