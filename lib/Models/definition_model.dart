class DefinitionModel {
  final int? id;
  final String? word;
  final DateTime? date;
  final String? partOfSpeech;
  final List<String> definitions;
  final List<String> examples;
  final List<String> synonyms;
  final List<String> antonyms;

  DefinitionModel({
    this.id,
    this.word,
    this.partOfSpeech,
    this.date,
    this.definitions = const [],
    this.examples = const [],
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory DefinitionModel.fromJson(Map<String, dynamic> json) => DefinitionModel(
    id: json["id"],
    word: json["word"],
    partOfSpeech: json["partOfSpeech"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    definitions: json["definitions"] == null ? [] : List<String>.from(json["definitions"].map((x) => x)),
    examples: json["examples"] == null ? [] : List<String>.from(json["examples"].map((x) => x)),
    synonyms: json["synonyms"] == null ? [] : List<String>.from(json["synonyms"].map((x) => x)),
    antonyms: json["antonyms"] == null ? [] : List<String>.from(json["antonyms"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "word": word,
    "partOfSpeech": partOfSpeech,
    "date": date?.toIso8601String(),
    "definitions": List<dynamic>.from(definitions.map((x) => x)),
    "examples": List<dynamic>.from(examples.map((x) => x)),
    "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
    "antonyms": List<dynamic>.from(synonyms.map((x) => x)),
  };
}
