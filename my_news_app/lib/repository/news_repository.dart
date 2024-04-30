import 'dart:convert';

import 'package:flutter/foundation.dart';
import'package:http/http.dart' as http;
import 'package:my_news_app/models/news_channel_headlines_model.dart';

class NewsRepository
{
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName)async{

    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=23354789d20549bf9b78848356cc9876';
    print(url);
    final response = await http.get(Uri.parse(url));
    if(kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
}