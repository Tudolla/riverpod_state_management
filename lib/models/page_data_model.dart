import '../models/pokemon_model.dart';

// 22p
class HomePageData {
  PokemonListData? data;

  HomePageData({
    required this.data,
  });

  HomePageData.initial() : data = null;

  HomePageData copyWith({PokemonListData? data}) {
    return HomePageData(
      data: data ?? this.data,
    );
  }
}