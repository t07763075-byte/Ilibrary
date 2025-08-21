class FAQModel {
  final String? question;
  final String? answer;
  final int? id;

  FAQModel({
    this.question,
    this.answer,
    this.id,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
    question: json["question"],
    answer: json["answer"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "id": id,
  };
}
