import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:sizer/sizer.dart';

import '../../blocs/home/navbar_cubit.dart';
import 'cart/cart_view.dart';
import 'category/category_view.dart';
import 'home/home_view.dart';
import 'other/other_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NavbarCubit, int>(
            builder: (context, state) {
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: context.read<NavbarCubit>().controller,
                  children: const <Widget>[
                    HomeView(),
                    CategoryView(),
                    CartView(),
                    OtherView(),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 18,
            right: 18,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: BlocBuilder<NavbarCubit, int>(
                builder: (context, state) {
                  return SnakeNavigationBar.color(
                    behaviour: SnakeBarBehaviour.floating,
                    snakeShape: SnakeShape.indicator,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    snakeViewColor: Theme.of(context).colorScheme.onPrimary,
                    selectedItemColor: Theme.of(context).colorScheme.onPrimary,
                    unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
                    selectedLabelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    showUnselectedLabels: false,
                    showSelectedLabels: true,
                    currentIndex: state,
                    onTap: (index) => setState(() {
                      context.read<NavbarCubit>().controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear);
                      context.read<NavbarCubit>().update(index);
                    }),
                    items: [
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage("assets/navbar_icons/home.png"),
                          size: 20.sp,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(0.5.h),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            maxRadius: 4,
                          ),
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage("assets/navbar_icons/categories.png"),
                          size: 20.sp,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(0.5.h),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            maxRadius: 4,
                          ),
                        ),
                        label: 'Category',
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage("assets/navbar_icons/shopping-cart.png"),
                          size: 20.sp,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(0.5.h),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            maxRadius: 4,
                          ),
                        ),
                        label: 'Cart',
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage("assets/navbar_icons/user.png"),
                          size: 20.sp,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(0.5.h),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            maxRadius: 4,
                          ),
                        ),
                        label: 'Other',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
