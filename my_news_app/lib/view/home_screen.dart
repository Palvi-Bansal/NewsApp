import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_news_app/models/news_channel_headlines_model.dart';
import 'package:my_news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, bbcSport, abcNews, cbcNews, cnnNews, googleNews }

class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){},
           icon: Image.asset('images/category_icon.png',
               height: 30,
               width: 30)),
        title: Text('News',
          style: GoogleFonts.poppins(fontSize: 25,
        fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item){
              if (item == FilterList.bbcNews) {
                name = 'bbc-news';
              }
              else if (item == FilterList.bbcSport) {
                name = 'bbc-sport';
              }
              else if (item == FilterList.abcNews) {
                name = 'abc-news';
              }
              else if (item == FilterList.cbcNews) {
                name = 'cbc-news';
              }
              else if (item == FilterList.cnnNews) {
                name = 'cnn';
              }
              else if (item == FilterList.googleNews) {
                name = 'google-news';
              }
            setState(() {
              selectedMenu = item;
            });
            },

            itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
              PopupMenuItem(
                  value: FilterList.bbcNews,
                  child: Text('BBC News'),
              ),
              PopupMenuItem(
                value: FilterList.bbcSport,
                child: Text('BBC Sports'),
              ),
              PopupMenuItem(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
              PopupMenuItem(
                value: FilterList.cbcNews,
                child: Text('CBC News'),
              ),
              PopupMenuItem(
                value: FilterList.cnnNews,
                child: Text('CNN News'),
              ),
              PopupMenuItem(
                value: FilterList.googleNews,
                child: Text('GOOGLE News'),
              ),
            ],
          )

        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 50,
                      ),
                    );
                  }
                  else
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: height * .02,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(child: spinKit2),
                                        errorWidget: (context, url, error) => Icon(
                                            Icons.error_outline, color: Colors.red),
                                      ),
                                    )
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.all(15),
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17
                                            ),),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * .7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13
                                                  ),),
                                                Text(format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12
                                                  ),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          );
                        }
                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
