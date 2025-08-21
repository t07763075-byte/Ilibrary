enum LibraryFilterType {
  myReads,
  bookmarks,
  wishlist,
  downloads,
  highlights,
  notes,
  words,
}

enum GeneralFilterType {
  sort,
  rating,
  language,
}

enum LibraryType { removeDownload, viewSeries, markAsFinished, aboutILibrary }

enum SortType { trending, highestRating, lowestRating }

enum RatingType {
  all,
  v5,
  v4_0_plus,
  v3_0_plus,
  v2_0_plus,
  v1_0_plus,
}

enum HomeType { _empty, continueReading, recommendedForYou, mostRead }
enum RatingFilterType {
  all,
  one,
  two,
  three,
  four,
  five,
}

enum RatingActionType{edit,delete}

enum BookGenreType {
  romance,
  fantasy,
  sciFi,
  horror,
  mystery,
  thriller,
  psychology,
  inspiration,
  comedy,
  action,
  adventure,
  comics,
  childrens,
  artAndPhotography,
  foodAndDrink,
  biography,
  scienceAndTechnology,
  guideAndHowTo,
  travel,
}


enum ContactIssueType {appNotWorking,problemWithABook,cantReadOffline,accountIssue,other}