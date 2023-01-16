import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/delegates/delegates.dart';

import '../models/models.dart';

class SearchMap extends StatelessWidget {
  const SearchMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
          ? const SizedBox()
          : const _SearchMapBody();
      }
    );
  }
}

class _SearchMapBody extends StatelessWidget {
  const _SearchMapBody({super.key});

  onSearchResults( BuildContext context, SearchResult result) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    if( result.manual == true ) {
      searchBloc.add( onActivateManualMarkerEvent() );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 10 ),
      padding: const EdgeInsets.symmetric( horizontal: 30),
      width: double.infinity,
      child: GestureDetector(
        onTap: () async {
          final result = await showSearch(context: context, delegate: SearchDestinationDelegate() );
          if( result == null ) return;
          
          onSearchResults(context, result);
        },
        child: FadeInDown(
          duration: const Duration( milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 13 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5)
                )
              ]
            ),
            child: const Text( '¿ Donde quieres ir?', style: TextStyle( color: Colors.black) )
          ),
        )
      ),
    );
  }
}