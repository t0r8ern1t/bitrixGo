import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final List<Item> items = [
    Item(id: 1, name: "Зелье", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/potion.png"),
    Item(id: 2, name: "Покебол", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png"),
    Item(id: 3, name: "Супербол", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/great-ball.png"),
    Item(id: 4, name: "Ультрабол", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/ultra-ball.png"),
    Item(id: 5, name: "Оживление", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/revive.png"),
    Item(id: 6, name: "Макс зелье", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/max-potion.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Инвентарь", style: TextStyle(fontSize: 24)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Возврат на предыдущий экран
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => ItemCard(item: items[index]),
        ),
      ),
    );
  }
}

class Item {
  final int id;
  final String name;
  final String imageUrl;

  Item({required this.id, required this.name, required this.imageUrl});
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showItemDetails(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              item.imageUrl,
              height: 100,
              width: 100,
              loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress == null
                    ? child
                    : CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 50, color: Colors.red);
              },
            ),
            SizedBox(height: 8),
            Text(
              item.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("Кол-во: ${item.id}", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(item.imageUrl, height: 120),
            SizedBox(height: 20),
            Text("ID: ${item.id}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Описание предмета...", style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Закрыть"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}