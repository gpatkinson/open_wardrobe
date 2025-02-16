import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/brick/models/user_profile.model.dart';
import 'package:openwardrobe/controllers/home_controller.dart';
import 'package:openwardrobe/ui/widgets/dashboard/link.dart';
import 'package:openwardrobe/ui/widgets/user_profile/user_profile_component.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SingleChildScrollView(
            child: Align(
          alignment: Alignment.topCenter,
          child: IntrinsicHeight(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: BlocBuilder<HomeController, List<UserProfile>>(
                    builder: (context, userProfile) {
                      if (userProfile.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return UserProfileComponent(item: userProfile.first);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        onTap: () {},
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
        )
      )

    );
  }
}
