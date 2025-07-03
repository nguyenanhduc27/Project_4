import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/room_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class AllRoomsPage extends StatelessWidget {
  final List<Room> rooms;

  const AllRoomsPage({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ Padding 2 bên
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                // ✅ HEADER
                SliverToBoxAdapter(
                  child: CustomHeader(),
                ),

                // ✅ KHỐI 1: TIÊU ĐỀ ALL ROOMS có nền
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/resort-title-bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'All Rooms',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ KHỐI 2: GRID PHÒNG
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20), // padding dọc riêng
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 / 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return RoomCard(room: rooms[index]);
                      },
                      childCount: rooms.length,
                    ),
                  ),
                ),

                // ✅ FOOTER
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
                      CustomFooter(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
