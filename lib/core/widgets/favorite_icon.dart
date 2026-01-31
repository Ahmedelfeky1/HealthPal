import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/features/fovorites/logic/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteIcon extends StatelessWidget {
  final int doctorId;
  const FavoriteIcon({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FavoritesCubit>().toggleFavorite(doctorId);
      },

      child: Container(
        // height: 30,
        // width: 30,
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   color: ColorsManager.lighterGray,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.1),
        //       blurRadius: 5,
        //       offset: const Offset(0, 2),
        //     ),
        //   ],
        // ),
        child: Center(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final favorites = context.read<FavoritesCubit>().favoriteIds;
              final isFavorite = favorites.contains(doctorId);

              return Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? ColorsManager.favoriteRed
                    : ColorsManager.gray,
                size: 20,
              );
            },
          ),
        ),
      ),
    );
  }
}
