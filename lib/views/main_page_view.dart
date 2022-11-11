import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/widgets/chat_bubble_widget.dart';
import 'package:it_class_frontend/util/packets/packets.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            minWidth: size.width / 10,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('First'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.book),
                label: Text('Second'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('Third'),
              ),
            ],
          ),
          const VerticalDivider(),
          // This is the main content.
          Column(
            children: <Widget>[
              Text(
                'Mitter',
                textAlign: TextAlign.start,
                style: loginTitleStyle(size),
              ),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    });
                    return SizedBox(
                      height: size.height / 1.15,
                      width: size.width / 1.2,
                      child: ListView(
                        itemExtent: 75,
                        reverse: true,
                        controller: _scrollController,
                        children: snapshot.data!.map((e) => ChatBubble(e)).toList(),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                stream: Get.find<SocketInterface>().publicMessages.stream,
              ),
              ElevatedButton(
                onPressed: () => Get.find<SocketInterface>().send(DummyPacket()),
                child: const Text('Send message'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
