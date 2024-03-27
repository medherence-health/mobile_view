import 'package:flutter/material.dart';
import 'package:medherence/core/constants_utils/color_utils.dart';

class ProgressStreak extends StatelessWidget {
  final int progress;

  const ProgressStreak({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.progressBarFill,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Stack(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width:
                            (progress / 10) * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.navBarColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Positioned(
                        left: (progress / 10) *
                                MediaQuery.of(context).size.width -
                            20,
                        child: Image.asset(
                          'assets/images/avatar_image.png',
                          // width: 3,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10,
                  top: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    10,
                    (index) {
                      return Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index < progress
                              ? AppColors.navBarColor
                              : Colors.grey,
                          fontWeight: FontWeight.w200,
                          fontSize: 8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
