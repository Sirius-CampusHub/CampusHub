import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 5,),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_left)),
              Expanded(
                child: SizedBox(
                  height: 60,
                    child: Center(child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(width: index != 5 ? 6 : 0,),
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            );
                      }),
                    ),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
            ],
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 15,),
                itemCount: 8,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(height: 15,);
                  } else if (index % 2 == 1) {
                    return Container(
                      color: Colors.grey,
                      height: 160,
                      width: double.infinity,
                    );
                  } else {
                    return Container(
                      color: Colors.grey,
                      height: 60,
                      width: double.infinity,
                    );
                  }
            }),
          ),
          ),
        ],
      ),
    );
  }
}
