import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonContact {
  final String name, phone, email;
  final Uint8List? avatar;
  PersonContact(this.name, this.phone, this.email, [this.avatar]);
}

// Dữ liệu mẫu (thay phần này bằng danh bạ thật khi chạy trên Android)
final List<PersonContact> _store = [
  PersonContact('Bich Ngan', '(908) 765-7765', 'ngan@gmail.com'),
  PersonContact('Van Vinh', '(890) 754-4468', 'vinh@gmail.com'),
  PersonContact('Tam Dinh', '0987955567', ''),
  PersonContact('Hoa Mi', '098976552', ''),
];

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});
  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  Future<void> _add() async {
    final c = await Navigator.push<PersonContact>(
        context, MaterialPageRoute(builder: (_) => const AddContactScreen()));
    if (c != null) setState(() => _store.add(c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh bạ'), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _add),
      ]),
      body: _store.isEmpty
          ? const Center(child: Text('Không có danh bạ nào.'))
          : ListView.builder(
              itemCount: _store.length,
              itemBuilder: (_, i) {
                final c = _store[i];
                return ListTile(
                  leading: c.avatar != null
                      ? CircleAvatar(backgroundImage: MemoryImage(c.avatar!))
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(c.name),
                  subtitle: Text(
                      '${c.phone}\n${c.email.isEmpty ? 'Không có email' : c.email}'),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});
  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  Uint8List? _avatar;

  Future<void> _pick(ImageSource source) async {
    final f = await ImagePicker().pickImage(source: source);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    if (!mounted) return;
    setState(() => _avatar = bytes);
  }

  void _chooseSource() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Chọn từ Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pick(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Chụp ảnh'),
            onTap: () {
              Navigator.pop(context);
              _pick(ImageSource.camera);
            },
          ),
        ]),
      ),
    );
  }

  void _save() {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tên và số điện thoại không được để trống!')));
      return;
    }
    Navigator.pop(context,
        PersonContact(_name.text.trim(), _phone.text.trim(), _email.text.trim(), _avatar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm danh bạ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          GestureDetector(
            onTap: _chooseSource,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _avatar != null ? MemoryImage(_avatar!) : null,
              child: _avatar == null ? const Icon(Icons.camera_alt, size: 50) : null,
            ),
          ),
          const SizedBox(height: 16),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Tên')),
          TextField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone),
          TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: const Text('Lưu')),
        ]),
      ),
    );
  }
}