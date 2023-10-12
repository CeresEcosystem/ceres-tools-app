class PageMeta {
  final int pageNumber;
  final int pageSize;
  int totalCount;
  final int pageCount;
  final bool hasPreviousPage;
  bool hasNextPage;

  PageMeta(
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.pageCount,
    this.hasPreviousPage,
    this.hasNextPage,
  );

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        json['pageNumber'],
        json['pageSize'],
        json['totalCount'],
        json['pageCount'],
        json['hasPreviousPage'],
        json['hasNextPage'],
      );
}
