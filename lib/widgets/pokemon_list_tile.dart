import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_management_app/models/pokemon_model.dart';
import 'package:riverpod_management_app/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemon;
  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemon = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : CircleAvatar(),
        title: Text(pokemon != null
            ? "${pokemon.id} - ${pokemon.name!.toUpperCase()}"
            : "No name"),
        subtitle: Text("${pokemon?.moves?.length ?? 0} skills"),
        trailing: IconButton(
          onPressed: () {
            if (_favoritePokemon.contains(pokemonUrl)) {
              _favoritePokemonsProvider.removeFavoritePokemon(pokemonUrl);
            } else {
              _favoritePokemonsProvider.addFavoritePokemon(pokemonUrl);
            }
          },
          icon: const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
