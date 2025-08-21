
import '../Models/server_model.dart';

class APIEndPoint{
  static final ServerModel _apiServer = ServerModel(serverIsSecured: true, host: "api.ilibrary.live", apiPrefix: "api");
  static String get _baseURL => _apiServer.baseUrl;
  static String get _baseUrlWithoutPref => _apiServer.baseUrlWithoutPref;




  //=========================== api User ====================================
  static String get test => "$_baseURL/todos";
  static String get home => "$_baseURL/Home/get-home";

  static String get login => "$_baseURL/User/login";
  static String get getUserInfo => "$_baseURL/User/get-profile";
  static String get updateProfile => "$_baseURL/User/edit-profile";
  static String get register => "$_baseURL/User/register";
  static String get verifyOtp => "$_baseURL/User/verify-otp";
  static String get verifyChangeEmailOrPhoneOtp => "$_baseURL/User/verify-change-email-or-phone-otp";
  static String get resendOtp => "$_baseURL/User/send-otp";
  static String get createPassword => "$_baseURL/User/forget-password";
  static String get changePassword => "$_baseURL/User/change-password";
  static String get deleteMyAccount => "$_baseURL/User/delete-account";
  static String get changeEmailOrPhone => "$_baseURL/User/edit-email-or-phone";
  static String get faqsList => "$_baseURL/Faq/ListFaqs";
  static String get createTicket => "$_baseURL/SupportTicket/create-ticket";
  static String get appSettings => "$_baseURL/AppSetting/ListAppSettings";

  static String get privacyPolicyPage => "$_baseUrlWithoutPref/Pages/Policy.html";
  static String get termsConditionsPage => "$_baseUrlWithoutPref/Pages/Terms&Conditions.html";

  static String get homeSection => "$_baseURL/Home/get-home-section";
  static String get category => "$_baseURL/Category/list-category";
  static String get updatePreferredCategories => "$_baseURL/Category/add-preferred-categories";
  static String  bookDetails(String? bookId) => "$_baseURL/Book/$bookId";
  static String  deleteToWishlist(int? bookId) => "$_baseURL/Wishlist/delete-wishlist/$bookId";
  static String get addToWishlist => "$_baseURL/Wishlist/add-to-wishlist";
  static String get rating => "$_baseURL/Rating";
  static String  getBookRating(String?bookId) => "$_baseURL/Rating/ByType?ObjectId=$bookId&ObjectTypeId=1";
  static String  addLike(int?ratingId) => "$_baseURL/Rating/$ratingId/Like";
  static String  ratingById(String?ratingId) => "$_baseURL/Rating/$ratingId";
  static String  desLike(int?ratingId) => "$_baseURL/Rating/$ratingId/DisLike";
  static String getBookHighlights(int bookId) => "$_baseURL/BookHighlights/get-book-highlights?bookid=$bookId";
  static String getBookNotes(int bookId) => "$_baseURL/BookNotes/get-book-notes?bookid=$bookId";
  static String get addNote => "$_baseURL/BookNotes/add-single-book-note";
  static String get editNote => "$_baseURL/BookNotes/update-book-note";
  static String get addHighLight => "$_baseURL/BookHighlights/add-single-book-highlight";
  static String get updateHighLight => "$_baseURL/BookHighlights/update-book-highlight";
  static String deleteBookHighlight(int highLightId) => "$_baseURL/BookHighlights/delete-highlight?highlightId=$highLightId";
  static String deleteBookNote(int noteId) => "$_baseURL/BookNotes/delete-notes?noteId=$noteId";
  static String get translate => "$_baseURL/BookOptions/translate";
  static String get languages => "$_baseURL/Language/ListLanguage";
  static String getBookFile(int bookId) => "$_baseURL/$bookId";
  static String get searchHistory => "$_baseURL/SearchHistory/list-search-history";
  static String get searchBook => "$_baseURL/Book/list-books";
  static String  deleteSearchHistory(int?id) => "$_baseURL/SearchHistory/$id";
  static String getBookPages(int bookId) => "$_baseURL/BookOptions/read-now?bookid=$bookId";
  static String get explain => "$_baseURL/BookExplanations/book-explanation";
  static String get definition => "$_baseURL/BookDefinitions/book-definition";
  static String  saveDefinition(int?id) => "$_baseURL/BookDefinitions/save-definition?Id=$id";
  static String  finishedRead(int?id) => "$_baseURL/Book/Is-Read?bookId=$id";
  static String get updateLastReadTime => "$_baseURL/MyReads/update-last-read-time";
  static String get notification => "$_baseURL/Notification/ListNotifications";
  static String get mostRead => "$_baseURL/Book/list-most-read-books";
  static String get myReads => "$_baseURL/Book/list-my-reads";
  static String  deleteMyReads(int?id) => "$_baseURL/MyReads/delete-myread/$id";
  static String get wishlist => "$_baseURL/Wishlist/list-wishlist";
  static String get listHighlights => "$_baseURL/BookHighlights/get-user-book-highlights";
  static String get listMarks => "$_baseURL/BookMarks/get-marks";
  static String get listUserNotes => "$_baseURL/BookNotes/get-all-user-notes";
  static String get definitions => "$_baseURL/BookDefinitions/definition-list";
  static String  deleteDefinitions(int?deleteId) => "$_baseURL/BookDefinitions/delete-definition?definitoinId=$deleteId";
  static String get bookMark => "$_baseURL/BookMarks/add-book-mark";
  static String deleteBookMark(int markId) => "$_baseURL/BookMarks/delete-mark?markId=$markId";

  static Uri uri({required String path, Map<String, dynamic> queryParameters = const {}}) {
    return Uri.parse(path).replace(queryParameters: {...queryParameters,...Uri.parse(path).queryParameters});
  }
}



