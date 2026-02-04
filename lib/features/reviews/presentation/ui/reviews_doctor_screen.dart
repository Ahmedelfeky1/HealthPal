import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/reviews/data/repo/reviews_repo.dart';
import 'package:doctor_appointment/features/reviews/data/services/reviews_service.dart';
import 'package:doctor_appointment/features/reviews/logic/cubit/reviews_cubit.dart';
import 'package:doctor_appointment/features/reviews/presentation/widget/add_review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsDoctorScreen extends StatelessWidget {
  final int doctorId;
  const ReviewsDoctorScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReviewsCubit(ReviewsRepo(reviewsService: ReviewsService()))
            ..getReviews(doctorId),
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            backgroundColor: ColorsManager.darkTeal,
            onPressed: () {
              final cubit = context.read<ReviewsCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: ColorsManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                builder: (context) {
                  return BlocProvider.value(
                    value: cubit,
                    child: AddReviewBottomSheet(
                      doctorId: doctorId,
                      appointmentId: 0,
                    ),
                  );
                },
              ).then((_) {
                context.read<ReviewsCubit>().getReviews(doctorId);
              });
            },
            icon: Icon(Icons.edit, color: ColorsManager.white),
            label: const Text(
              "Add Review",
              style: TextStyle(
                color: ColorsManager.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ReviewsCubit, ReviewsState>(
            builder: (context, state) {
              if (state is ReviewsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.darkTeal,
                  ),
                );
              } else if (state is ReviewsError) {
                return Center(child: Text(state.erorr));
              } else if (state is ReviewsSuccess) {
                final reviews = state.reviews;

                double averageRating = 0;
                if (reviews.isNotEmpty) {
                  final total = reviews.fold(
                    0.0,
                    (sum, item) => sum + item.rating,
                  );
                  averageRating = total / reviews.length;
                }

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ColorsManager.darkTeal,
                      expandedHeight: 250.h,
                      pinned: true,
                      leading: const BackButton(color: Colors.white),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          padding: EdgeInsets.all(20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 30.h),
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < averageRating.round()
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: Colors.amber,
                                    size: 28.sp,
                                  );
                                }),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Based on ${reviews.length} reviews",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          "Reviews",
                          style: TextStyles.font18BlackBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        centerTitle: true,
                      ),
                    ),

                    reviews.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.rate_review_outlined,
                                    size: 60.sp,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "No reviews yet",
                                    style: TextStyles.font18BlackBold.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Be the first to share your experience!",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: EdgeInsets.all(20.h),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final review = reviews[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20.r,
                                            backgroundColor:
                                                ColorsManager.lighterGray,
                                            child: Text(
                                              review.userName[0].toUpperCase(),
                                              style: TextStyle(
                                                color: ColorsManager.darkTeal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review.userName,
                                                  style: TextStyles
                                                      .font18BlackBold,
                                                ),
                                                Text(
                                                  review.createdAt,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.amber,
                                                  size: 16.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  review.rating.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber[800],
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      Divider(color: Colors.grey.shade100),
                                      SizedBox(height: 8.h),

                                      Text(
                                        review.comment.isEmpty
                                            ? "No comment provided."
                                            : review.comment,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }, childCount: reviews.length),
                            ),
                          ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
