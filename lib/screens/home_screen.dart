import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_news/models/news_channel_headlines_model.dart';
import 'package:daily_news/screens/categories_screen.dart';
import 'package:daily_news/screens/news_detail_screen.dart';
import 'package:daily_news/view_model/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  String name = 'bbc-news';
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'General';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
          },
          icon: const Icon(Icons.add_chart),
        ),
        title: Center(
          child: Text(
            'Daily News',
            style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: const Icon(Icons.more_vert, color: Colors.white,),
              onSelected: (FilterList item) {
                if (FilterList.bbcNews == item) {
                  name = 'bbc-news';
                } else if (FilterList.aryNews == item) {
                  name = 'ary-news';
                } else if (FilterList.reuters == item) {
                  name = 'reuters';
                } else if (FilterList.cnn == item) {
                  name = 'cnn';
                } else if (FilterList.alJazeera == item) {
                  name = 'al-jazeera-english';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                const PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews,
                  child: Text('BBC News'),
                ),
                const PopupMenuItem<FilterList>(
                  value: FilterList.aryNews,
                  child: Text('ARY News'),
                ),
                const PopupMenuItem<FilterList>(
                  value: FilterList.reuters,
                  child: Text('Reuters News'),
                ),
                const PopupMenuItem<FilterList>(
                  value: FilterList.cnn,
                  child: Text('CNN News'),
                ),
                const PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera,
                  child: Text('A-Jazeera News'),
                ),
              ]
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: height * .55,
                width: width,
                child: FutureBuilder<NewsChannelHeadlinesModel>(
                  future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitFadingCircle(
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    }
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w200, color: Colors.white),),
                      );
                    }
                    else if(snapshot.hasData && snapshot.data!.articles != null){
                      return ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: snapshot.data!.articles!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    NewsDetailScreen(
                                        newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                        newsTitle: snapshot.data!.articles![index].title.toString(),
                                        newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                        newsAuthor: snapshot.data!.articles![index].author.toString(),
                                        newsDescription: snapshot.data!.articles![index].description.toString(),
                                        newsContent: snapshot.data!.articles![index].content.toString(),
                                        newsSource: snapshot.data!.articles![index].source!.name.toString()))
                                );
                              },
                              child: SizedBox(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: height * .6,
                                      width: width * .9,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: height * .01,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(child: spinKit2,),
                                          errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.white,),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      child: Card(
                                        elevation: 10,
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
                                              SizedBox(
                                                width: width * .7,
                                                child: Text(snapshot.data!.articles![index].title.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: width * .7,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(snapshot.data!.articles![index].source!.name.toString(),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(format.format(dateTime),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                    else {
                      return Center(
                        child: Text(
                          'No News Available',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w200, color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      '$categoryName News',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: FutureBuilder<CategoriesNewsModel>(
                      future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitFadingCircle(
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        }
                        else if (snapshot.hasError) {
                          return Center(
                            child: Text('${snapshot.error}' ,style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w200, color: Colors.white),),
                          );
                        }
                        else if(snapshot.hasData && snapshot.data!.articles != null){
                          return ListView.builder(
                              itemCount: snapshot.data!.articles!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          NewsDetailScreen(
                                              newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                              newsTitle: snapshot.data!.articles![index].title.toString(),
                                              newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                              newsAuthor: snapshot.data!.articles![index].author.toString(),
                                              newsDescription: snapshot.data!.articles![index].description.toString(),
                                              newsContent: snapshot.data!.articles![index].content.toString(),
                                              newsSource: snapshot.data!.articles![index].source!.name.toString()))
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                            fit: BoxFit.cover,
                                            height: height * .18,
                                            width: width * .3,
                                            placeholder: (context, url) => Container(
                                              child: const Center(
                                                child: SpinKitFadingCircle(
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * .18,
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                Text(snapshot.data!.articles![index].title.toString(),
                                                  maxLines: 3,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(format.format(dateTime),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        }
                        else {
                          return Center(
                            child: Text(
                              'No News Available',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w200, color: Colors.white),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                childCount: 1, // Adjust this count according to your data
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.white,
  size: 50,
);
