import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_news/models/categories_news_model.dart';
import 'package:daily_news/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  String categoryName = 'General';
  final format = DateFormat('MMMM dd, yyyy');

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          categoryName = categoriesList[index];
                          setState(() {});
                        },
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: categoryName == categoriesList[index] ? Colors.blue : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            categoryName = categoriesList[index];
                            setState(() {});
                          },
                          child: Center(
                            child: getCategoryIcon(categoriesList[index]),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(color: Colors.white, thickness: 1),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      categoryName,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
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
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context , index){
                            DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context , url) => Container(
                                          child: const Center(
                                            child: SpinKitFadingCircle(
                                            size: 50,
                                            color: Colors.white,
                                        ),
                                      ),
                                      ),
                                      errorWidget: (context, url ,error) => const Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: height * .18,
                                        padding: const EdgeInsets.only(left: 20),
                                        child: InkWell(
                                          onTap: (){
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
                                          child: Column(
                                            children: [
                                              Flexible(
                                                child: Text(snapshot.data!.articles![index].title.toString(),
                                                  maxLines: 3,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
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
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(format.format(dateTime),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
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
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    }
                    else {
                      return Center(
                        child: Text('No news available.', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w200, color: Colors.white),),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Icon getCategoryIcon(String category) {
    switch (category) {
      case 'Entertainment':
        return const Icon(Icons.music_note_outlined, color: Colors.black);
      case 'Health':
        return const Icon(Icons.health_and_safety, color: Colors.black);
      case 'Sports':
        return const Icon(Icons.sports, color: Colors.black);
      case 'Business':
        return const Icon(Icons.business, color: Colors.black);
      case 'Technology':
        return const Icon(Icons.biotech_outlined, color: Colors.black);
    // Add more cases for other categories
      default:
        return const Icon(Icons.all_inbox, color: Colors.black); // Default icon
    }
  }
}
