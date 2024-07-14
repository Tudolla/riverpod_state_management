import 'package:flutter/material.dart';
import 'package:riverpod_management_app/models/pokemon_model.dart';
import 'package:riverpod_management_app/widgets/pokemon_list_tile.dart';
import '../controller/home_screen_controller.dart';
import '../models/page_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScreenControllerProvider =
    StateNotifierProvider<HomeScreenController, HomePageData>((ref) {
  return HomeScreenController(HomePageData.initial());
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _allPokemonScrollController = ScrollController();
  late HomeScreenController _homeScreenController;
  late HomePageData _homePageData;

  // call before build();
  @override
  void initState() {
    super.initState();
    _allPokemonScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonScrollController.removeListener(_scrollListener);
    _allPokemonScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonScrollController.offset >=
            _allPokemonScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonScrollController.position.outOfRange) {
      _homeScreenController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homeScreenController = ref.watch(homeScreenControllerProvider.notifier);
    _homePageData = ref.watch(homeScreenControllerProvider);
    return Scaffold(
      body: _buildHomeScreenUI(context),
    );
  }

  Widget _buildHomeScreenUI(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: sizeWidth,
          padding: EdgeInsets.symmetric(
            horizontal: sizeWidth * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _allPokemonList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "All Pokemon Go",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
              controller: _allPokemonScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonUrl: pokemon.url!);
              }),
        ),
      ]),
    );
  }
}
