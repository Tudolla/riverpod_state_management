import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_management_app/models/pokemon_model.dart';
import 'package:riverpod_management_app/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response? res = await _httpService.get(
    url,
  );
  if (res != null && res.data != null) {
    return Pokemon.fromJson(
      res.data,
    );
  }
  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider(
    [], // empty cause the first lunch app, user does't have any favorite
  );
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  FavoritePokemonsProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {}

  void addFavoritePokemon(String url) {
    state = [...state, url];
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
  }
}
