import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.width() - 100,
      width: context.width() - 100,
      child: Column(
        children: [
          Image.asset('images/empty_screen.png'),
          const SizedBox(height: 30),
          const Text(
            'No Data',
            style: TextStyle(fontSize: 22),
          )
        ],
      ),
    );
  }
}
