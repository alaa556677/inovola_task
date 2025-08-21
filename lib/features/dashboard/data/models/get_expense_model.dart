import 'package:inovola_task/features/dashboard/domain/entities/get_expenses_entity.dart';

class GetExpenseModel extends GetExpenseEntity{
  GetExpenseModel({required super.id, required super.title, required super.body});

  factory GetExpenseModel.fromJson(Map<String, dynamic> json){
    return GetExpenseModel(id: json['id'], title: json['title'],  body: json['body']);
  }

  Map <String, dynamic> toJson(){
    return {
      'id' : id,
      'title' : title,
      'body' : body
    };
  }
}

