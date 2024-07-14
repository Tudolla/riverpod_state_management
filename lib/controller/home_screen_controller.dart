import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_management_app/models/pokemon_model.dart';
import 'package:riverpod_management_app/services/http_service.dart';
import '../models/page_data_model.dart';

class HomeScreenController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpService _httpService;
  HomeScreenController(super._state) {
    _httpService = _getIt.get<HttpService>();
    _setUp();
  }

  Future<void> _setUp() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpService
          .get("https://pokeapi.co/api/v2/pokemon?limit=10&offset=0");

      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        // this: create a new instance of HomePageData
        state = state.copyWith(
          data: data,
        );
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpService.get(
          state.data!.next!,
        );
        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data!);
          state = state.copyWith(
              // ... which connect the next

              data: data.copyWith(results: [
            ...?state.data?.results,
            ...?data.results,
          ]));
        }
      }
    }
  }
}
