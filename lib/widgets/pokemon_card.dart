import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_management_app/providers/pokemon_data_providers.dart';
import 'package:riverpod_management_app/widgets/pokemon_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon_model.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonUrl),
    );
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    return pokemon.when(
      data: (data) {
        return _card(context, false, data);
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => _card(context, true, null),
    );
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonDialog(pokemonUrl: pokemonUrl);
                });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.01,
            vertical: MediaQuery.of(context).size.width * 0.02,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.01,
            vertical: MediaQuery.of(context).size.width * 0.03,
          ),
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      pokemon?.name?.toUpperCase() ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "#${pokemon?.id?.toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon.sprites!.frontDefault!)
                      : null,
                  radius: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${pokemon?.moves?.length} skills",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavoritePokemon(
                        pokemonUrl,
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
