class CreateAssetModel {
  String? name;
  String? description;
  String? serialNo;
  String? status;

  CreateAssetModel({this.name, this.description, this.serialNo, this.status});

  CreateAssetModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    serialNo = json['serialNo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['serialNo'] = this.serialNo;
    data['status'] = this.status;
    return data;
  }
}
