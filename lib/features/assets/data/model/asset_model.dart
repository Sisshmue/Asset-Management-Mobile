class Asset {
  int? id;
  String? name;
  String? description;
  String? serialNo;
  bool? isDeleted;
  String? status;
  String? createdAt;

  Asset({
    this.id,
    this.name,
    this.description,
    this.serialNo,
    this.isDeleted,
    this.status,
    this.createdAt,
  });

  Asset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    serialNo = json['serialNo'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['serialNo'] = this.serialNo;
    data['isDeleted'] = this.isDeleted;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
