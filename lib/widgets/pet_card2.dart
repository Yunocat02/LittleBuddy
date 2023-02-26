import 'package:get/get.dart';

import '../utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../views/Chatbot_view.dart';
import '../views/map_view.dart';

class PetCard2 extends StatefulWidget {
  final double? height;
  final String petPath;
  final String petName;
  const PetCard2(
      {Key? key, required this.petPath, required this.petName, this.height})
      : super(key: key);

  @override
  State<PetCard2> createState() => _PetCard2State();
}

class _PetCard2State extends State<PetCard2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const Mapnaja()));
        },
        child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) {
              return Container(
                width: double.infinity,
                height: 205.0 * value,
                decoration: BoxDecoration(
                    color: Styles.bgColor,
                    borderRadius: BorderRadius.circular(27)),
                child: FittedBox(
                  child: Column(
                    children: [
                      const Gap(15),
                      SizedBox(
                          height: 95.0 * value,
                          child: SvgPicture.asset(widget.petPath,
                              height: widget.height ?? 95)),
                      const Gap(10),
                      Text(
                        widget.petName,
                        style: TextStyle(
                            color: Styles.highlightColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Gap(5),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chatbot(),
                            ),
                          );
                        },
                        color: Styles.bgWithOpacityColor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Styles.highlightColor,
                              ),
                            ),
                            const Gap(5),
                            SvgPicture.asset(
                              'assets/svg/arrow_right.svg',
                              height: 14,
                              width: 14,
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}