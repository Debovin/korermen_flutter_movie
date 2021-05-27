import 'package:flutter/material.dart';

/* FILES */
import '/src/widgets/card_swiper_widget.dart';
import '/src/providers/movies_provider.dart';
import '/src/widgets/movie_horizontal.dart';
import '/src/search/search_delegate.dart';

class Homepage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();
  @override
  Widget build(BuildContext context) {
    moviesProvider.getTrending();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('KORERMEN'),
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        backgroundColor: Colors.blueGrey[100],
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperCards(), _footer(context)],
          ),
        ));
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getInCinemas(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(movies: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'В тренде',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black
                ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          StreamBuilder(
            stream: moviesProvider.trendingStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getTrending,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
