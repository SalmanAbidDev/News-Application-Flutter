import 'dart:convert';

import 'package:daily_news/models/categories_news_model.dart';
import 'package:daily_news/models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;
class NewsRepository {

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi (String newsChannel) async {

    String url = 'https://newsapi.org/v2/top-headlines?sources=${newsChannel}&apiKey=ee760784b0f641d19c8f23becf12a3ae';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final body =jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);

    }
    throw Exception('Error, News not found!');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {

    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=ee760784b0f641d19c8f23becf12a3ae';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final body =jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);

    }
    throw Exception('Error, News not found!');
  }

}