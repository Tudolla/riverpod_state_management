import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_management_app/providers/pokemon_data_providers.dart';

class PokemonDialog extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonDialog({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return AlertDialog(
      title: const Text("Detail:"),
      content: pokemon.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((e) {
                  return Text("${e.stat?.name?.toUpperCase()}: ${e.baseStat}");
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => CircularProgressIndicator(
          color: Colors.pink.withOpacity(.2),
        ),
      ),
    );
  }
}
