import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/doctor_list_tile.dart';
import 'package:doctor_appointment/features/fovorites/logic/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsManager.white,
        title: Text("Favorites", style: TextStyles.font18BlackBold),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsManager.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<DoctorCubit, DoctorState>(
        builder: (context, doctorState) {
          if (doctorState is DoctorsSuccess) {
            final allDoctors = doctorState.doctors;
            return BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, favState) {
                if (favState is FavoritesSuccess) {
                  final favIds = favState.favoriteIds;
                  final favoriteDoctors = allDoctors
                      .where((doctor) => favIds.contains(doctor.id))
                      .toList();
                  if (favoriteDoctors.isEmpty) {
                    return Center(
                      child: Text(
                        "No favorite doctors yet.",
                        style: TextStyles.font18BlackBold,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: favoriteDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = favoriteDoctors[index];
                      return DoctorListTile(doctorModel: doctor);
                    },
                  );
                } else if (favState is FavoritesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.darkTeal,
                    ),
                  );
                } else {
                  return Center(child: Text("Error loading favorites."));
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.darkTeal),
            );
          }
        },
      ),
    );
  }
}
