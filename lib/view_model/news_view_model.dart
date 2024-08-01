
import 'package:daily_news/models/categories_news_model.dart';
import 'package:daily_news/models/news_channel_headlines_model.dart';
import 'package:daily_news/repository/news_repository.dart';

class NewsViewModel {

  final _rep = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String newsChannel) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(newsChannel);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }

}