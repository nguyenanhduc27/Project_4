import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../widgets/hotel_card.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class AllHotelsPage extends StatelessWidget {
  final List<Hotel> hotels;

  const AllHotelsPage({Key? key, required this.hotels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CustomHeader(),
                ),

                // Tiêu đề ALL HOTELS với background
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
                        'All Hotels',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Grid hotel cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 / 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return HotelCard(hotel: hotels[index], checkInDate: DateTime.now(), checkOutDate: DateTime.now().add(Duration(days: 1)));
                      },
                      childCount: hotels.length,
                    ),
                  ),
                ),

                // Footer
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
