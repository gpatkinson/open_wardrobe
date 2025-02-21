import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/presentation/blocs/home/home_cubit.dart';
import 'package:openwardrobe/presentation/blocs/home/home_state.dart';
import 'package:openwardrobe/ui/widgets/dashboard/link.dart';
import 'package:openwardrobe/ui/widgets/user_profile/user_profile_component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchUserProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return switch (state) {
                          HomeLoading() => const Center(child: CircularProgressIndicator()),
                          HomeError(message: var message) => Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text('Error: $message'),
                                ],
                              ),
                            ),
                          HomeUserProfileLoaded(userProfiles: var profiles) when profiles.isEmpty => 
                            const Center(child: Text('No profile found')),
                          HomeUserProfileLoaded(userProfiles: var profiles) => 
                            UserProfileComponent(item: profiles.first),
                          _ => const SizedBox(),
                        };
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        DashboardLink(
                          text: 'Add Items',
                          icon: Icons.add,
                          color: Colors.blue,
                          onTap: () => context.push("/camera"),
                        ),
                        DashboardLink(
                          text: 'Create Outfit',
                          color: Colors.red,
                          icon: Icons.list,
                          onTap: () => context.push("/wardrobe"),
                        ),
                        DashboardLink(
                          text: 'Schedule Outfit',
                          color: Colors.green,
                          icon: Icons.calendar_today,
                          onTap: () {},
                        ),
                        DashboardLink(
                          text: 'View Stats',
                          color: Colors.purple,
                          icon: Icons.bar_chart,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
