import 'package:flutter/material.dart';
import 'package:riverpod_management_app/models/pokemon_model.dart';
import 'package:riverpod_management_app/providers/pokemon_data_providers.dart';
import 'package:riverpod_management_app/widgets/pokemon_card.dart';
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

  late List<String> _favoritePokemon;

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

    _favoritePokemon = ref.watch(
      favoritePokemonsProvider,
    );
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
              _favoritePokemonList(context),
              Divider(
                color: Colors.grey.withOpacity(.5),
                thickness: 1.0,
              ),
              _allPokemonList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonList(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: sizeWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Favorite",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: sizeHeight * 0.5,
            width: sizeWidth,
            child: Column(
              children: [
                if (_favoritePokemon.isNotEmpty)
                  SizedBox(
                    // this height is so important, if don't have this - nothing show
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: _favoritePokemon.length,
                        itemBuilder: (context, index) {
                          String pokemonUrl = _favoritePokemon[index];
                          return PokemonCard(pokemonUrl: pokemonUrl);
                        }),
                  ),
                if (_favoritePokemon.isEmpty)
                  const Text("Empty favorite pokemons"),
              ],
            ),
          ),
        ],
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
