import 'package:flutter/material.dart';

class Sms {
  final String address, body;
  final DateTime date;
  Sms(this.address, this.body, this.date);
}

// Dữ liệu mẫu (trên Android thay bằng tin nhắn thật, xem ghi chú cuối)
Future<List<Sms>> loadMessages() async {
  final now = DateTime.now();
  DateTime ago(int days, int hour) =>
      DateTime(now.year, now.month, now.day - days, hour, 15);
  return [
    Sms('6505551212', 'Dang test gui tin nhan.', ago(0, 9)),
    Sms('Shop123', '[QC] Giam gia 50% toan bo san pham hom nay', ago(0, 10)),
    Sms('Bank', '[OTP] Ma xac thuc cua ban la 123456. Khong chia se.', ago(1, 8)),
    Sms('6505551212', 'Android is always a sweet treat!', ago(1, 14)),
    Sms('Shop123', '[QC] Mua 1 tang 1 cuoi tuan nay', ago(3, 11)),
    Sms('Grab', '[OTP] 654321 la ma dang nhap cua ban', ago(3, 19)),
    Sms('0987955567', 'Toi nay di an nhe', ago(35, 20)),
    Sms('Bank', '[OTP] Ma giao dich: 246810', ago(40, 7)),
  ];
}

class SmsAnalyzerHome extends StatefulWidget {
  const SmsAnalyzerHome({super.key});
  @override
  State<SmsAnalyzerHome> createState() => _SmsAnalyzerHomeState();
}

class _SmsAnalyzerHomeState extends State<SmsAnalyzerHome> {
  List<Sms> _all = [];
  bool _loading = true;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    loadMessages().then((m) {
      if (!mounted) return;
      setState(() {
        _all = m..sort((a, b) => b.date.compareTo(a.date));
        _loading = false;
      });
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _time(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year} ${_two(d.hour)}:${_two(d.minute)}';

  bool _isQc(Sms m) => m.body.trimLeft().startsWith('[QC]');

  String? _otp(Sms m) {
    if (!m.body.contains('[OTP]')) return null;
    return RegExp(r'(?<!\d)\d{6}(?!\d)').firstMatch(m.body)?.group(0);
  }

  Map<String, int> _count(String Function(DateTime) keyOf) {
    final map = <String, int>{};
    for (final m in _all) {
      map.update(keyOf(m.date), (v) => v + 1, ifAbsent: () => 1);
    }
    return map;
  }

  Widget _tile(Sms m, {VoidCallback? onTap}) => ListTile(
        title: Text(m.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('Từ: ${m.address}  •  ${_time(m.date)}'),
        onTap: onTap,
      );

  Widget _list(List<Sms> list, String empty, {void Function(Sms)? onTap}) {
    if (list.isEmpty) return Center(child: Text(empty));
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) =>
          _tile(list[i], onTap: onTap == null ? null : () => onTap(list[i])),
    );
  }

  Widget _allTab() {
    final list = _all.where((m) => m.address.contains(_filter.trim())).toList();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          decoration: const InputDecoration(
              labelText: 'Lọc theo số điện thoại / người gửi',
              prefixIcon: Icon(Icons.search)),
          onChanged: (v) => setState(() => _filter = v),
        ),
      ),
      Expanded(child: _list(list, 'Không có tin nhắn nào.')),
    ]);
  }

  void _showOtp(Sms m) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mã OTP'),
        content: SelectableText(_otp(m)!,
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))
        ],
      ),
    );
  }

  Widget _statsTab() {
    final byDay = _count((d) => '${_two(d.day)}/${_two(d.month)}/${d.year}');
    final byMonth = _count((d) => '${_two(d.month)}/${d.year}');
    Widget section(String title, Map<String, int> data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ...data.entries.map((e) => ListTile(
                dense: true, title: Text(e.key), trailing: Text('${e.value} tin'))),
          ],
        );
    return ListView(children: [
      Card(
        margin: const EdgeInsets.all(12),
        child: ListTile(
          title: const Text('Tổng số tin nhắn nhận được'),
          trailing: Text('${_all.length}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ),
      section('Theo tháng', byMonth),
      section('Theo ngày', byDay),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Analyzer'),
          bottom: const TabBar(isScrollable: true, tabs: [
            Tab(text: 'Tất cả'),
            Tab(text: 'Quảng cáo'),
            Tab(text: 'OTP'),
            Tab(text: 'Thống kê'),
          ]),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                _allTab(),
                _list(_all.where(_isQc).toList(), 'Không có tin quảng cáo.'),
                _list(_all.where((m) => _otp(m) != null).toList(), 'Không có tin OTP.',
                    onTap: _showOtp),
                _statsTab(),
              ]),
      ),
    );
  }
}