import 'package:whatsapp/whatsapp.dart';

import 'global_var.dart';
import 'history.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io';
import 'home.dart';

class graph extends StatelessWidget {
  const graph({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: SizedBox(
        height: 180,
        width: 500,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                maxContentWidth: 100,
                tooltipBgColor: Colors.white30,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final textStyle = TextStyle(
                      color: touchedSpot.bar.gradient?.colors[0] ??
                          touchedSpot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    );
                    return LineTooltipItem(
                      '${touchedSpot.x},${touchedSpot.y.toStringAsFixed(2)}',
                      textStyle,
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
              getTouchLineStart: (data, index) => 2,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> indicators) {
                return indicators.map(
                  (int index) {
                    final line = FlLine(
                        color: Colors.grey, strokeWidth: 0, dashArray: [2, 4]);
                    return TouchedSpotIndicatorData(
                      line,
                      FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                  radius: 8,
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.3),
                                  strokeWidth: 0)),
                    );
                  },
                ).toList();
              },
            ),
            minY: 0,
            maxY: 20,
            borderData: FlBorderData(show: false),
            clipData: FlClipData.all(),
            backgroundColor: Colors.white,
            gridData: FlGridData(
                show: false,
                drawVerticalLine: false,
                horizontalInterval: 0.5,
                verticalInterval: 5),
            lineBarsData: [
              LineChartBarData(
                  isStrokeCapRound: true,
                  show: true,
                  spots: [
                    FlSpot(0, 10),
                    FlSpot(1, 5),
                    FlSpot(2, 10),
                    FlSpot(3, 1.2),
                    FlSpot(4, 15),
                    FlSpot(5, 10),
                    FlSpot(6, 0),
                    FlSpot(7, 5),
                    FlSpot(8, 4),
                    FlSpot(9, 15),
                    FlSpot(10, 15),
                    FlSpot(11, 3),
                  ],
                  color: Colors.lightBlueAccent.withOpacity(0.1),
                  barWidth: 0,
                  isCurved: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment(5, 0),
                      end: Alignment(0, 5),
                      colors: <Color>[
                        Colors.lightBlueAccent.withOpacity(0.9),
                        Colors.lightBlueAccent.withOpacity(0.9),
                        Colors.lightBlueAccent.withOpacity(0.3),
                        Colors.lightBlueAccent.withOpacity(0.2),
                        Colors.lightBlueAccent.withOpacity(0.1),
                        Colors.lightBlueAccent.withOpacity(0.1),
                      ],
                    ),
                  ),
                  dotData: FlDotData(show: false)),
            ],
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 20,
                  interval: 0.5,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitleWidgets,
                  reservedSize: 40,
                  interval: 1,
                ),
              ),
            ),
          ),
          swapAnimationDuration: Duration(milliseconds: 800), // Optional
          swapAnimationCurve: Curves.bounceIn, // Optional
        ),
      ),
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 5,
      decoration: TextDecoration.none);
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('JAN', style: style);
      break;
    case 1:
      text = const Text('FEB', style: style);
      break;
    case 2:
      text = const Text('MAR', style: style);
      break;
    case 3:
      text = const Text('APRIL', style: style);
      break;
    case 4:
      text = const Text('MAY', style: style);
      break;
    case 5:
      text = const Text('JUN', style: style);
      break;
    case 6:
      text = const Text('JUL', style: style);
      break;
    case 7:
      text = const Text('AUG', style: style);
      break;
    case 8:
      text = const Text('SEP', style: style);
      break;
    case 9:
      text = const Text('OCT', style: style);
      break;
    case 10:
      text = const Text('NOV', style: style);
      break;
    case 11:
      text = const Text('DEC', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      decoration: TextDecoration.none);
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10K';
      break;
    case 3:
      text = '30k';
      break;
    case 4:
      text = '50k';
      break;
    default:
      return Container();
  }
  return Text(text, style: style, textAlign: TextAlign.right);
}

class sep_containers extends StatefulWidget {
  int amt;
  String status;
  String date;
  sep_containers(
      {required this.amt, required this.status, required this.date}) {}
  @override
  State<sep_containers> createState() => _sep_containersState();
}

class _sep_containersState extends State<sep_containers> {
  @override
  Widget build(BuildContext context) {
    int amount = widget.amt;
    String date = widget.date;
    String status = widget.status;
    Color color;
    if (status == "pending") {
      color = Colors.yellow;
    } else {
      color = Colors.green;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: 0.5,
        child: SizedBox(
          height: 70,
          width: 380,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined),
                    SizedBox(
                      width: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Rs.$amount",
                        style: TextStyle(fontFamily: "Mulish", fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Text(
                      status,
                      style: TextStyle(color: color),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Download extends StatefulWidget {
  const Download({Key? key}) : super(key: key);

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text("Delete"),
    );
  }
}

SalomonBottomBar Navigate(_currentIndex, context) {
  return SalomonBottomBar(
    currentIndex: _currentIndex,
    onTap: (i) {
      _currentIndex = i;
      if (_currentIndex == 0 && globals.current == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home()));
      }
      if (_currentIndex == 1 && globals.current == 0 && globals.counter == 1) {
        globals.counter = 2;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => history()));
      } else if (_currentIndex == 1 &&
          globals.current == 0 &&
          globals.counter > 1) {
        Navigator.pop(context);
        _currentIndex = 0;
        globals.current = 1;
      }
    },
    items: [
      SalomonBottomBarItem(
        icon: Icon(Icons.home),
        title: Text("Home"),
        selectedColor: Colors.teal.withOpacity(0.7),
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.history),
        title: Text("History"),
        selectedColor: Colors.teal.withOpacity(0.7),
      ),
    ],
  );
}

class invoice_pdf extends StatefulWidget {
  invoice_pdf({Key? key, required this.no}) : super(key: key);
  String no;
  @override
  State<invoice_pdf> createState() => _invoice_pdfState();
}

class _invoice_pdfState extends State<invoice_pdf> {
  @override
  Widget build(BuildContext context) {
    String number = widget.no;
    return TextButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            "#$number",
            style: TextStyle(color: Colors.black, fontSize: 15),
          )
        ],
      ),
    );
  }
}

class date_fn extends StatelessWidget {
  date_fn({super.key, required this.d});
  String d;
  @override
  Widget build(BuildContext context) {
    String date = d;

    return Center(child: Text(date, style: TextStyle(fontSize: 10)));
  }
}

class status_fn extends StatelessWidget {
  status_fn({Key? key, required this.statu}) : super(key: key);
  String statu;
  @override
  Widget build(BuildContext context) {
    String s = statu;
    Color color = Colors.green;
    if (s == "Pending") {
      color = Colors.red;
    }
    return Center(
      child: Text(
        s,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}

class amount_fn extends StatelessWidget {
  amount_fn({required this.amt});
  String amt;
  @override
  Widget build(BuildContext context) {
    String amount = amt;
    return Center(child: Text("$amount", style: TextStyle(fontSize: 12)));
  }
}

// class DataTableWidget extends StatelessWidget {
//   const DataTableWidget({Key? key}) : super(key: key);
//
//   final List<String> pdf_name = [];
//
//   final List<String> pdfDates = [];
//
//   final List<String> pdfAmounts = [];
//
//   final List<String> pdfDue = [];
//
//   final List<DataRow> rows = [];
//
//   int j = 0;
//
//   _getpdfs() async {
//     FirebaseStorage storageRef = FirebaseStorage.instance;
//     final ListResult result =
//         await storageRef.ref().child('kaccha_pdf/').listAll();
//     final List<Reference> allFiles = result.items;
//
//     await Future.forEach<Reference>(allFiles, (file) async {
//       final String name = await file.name;
//       pdf_name.add(name);
//       pdfDates.add(await _getpdfdate("kaccha_pdf/$name"));
//       pdfAmounts.add(await readPdfAmountFromFirebase("kaccha_pdf/$name"));
//       pdfDue.add(await readPdfDuefromFirebase("kaccha_pdf/$name"));
//       pdf_name.sort((a, b) {
//         final aNum = int.tryParse(a.split("invoice")[1].split(".")[0]);
//         final bNum = int.tryParse(b.split("invoice")[1].split(".")[0]);
//         return aNum!.compareTo(bNum!);
//       });
//       j++;
//     });
//     _updaterows();
//   }
//
//   int i = 0;
//
//   _updaterows() {
//     pdf_name.forEach(
//       (element) {
//         rows.add(
//           DataRow(
//             cells: [
//               DataCell(TextButton(
//                 child: Text("${element.split('.')[0]}"),
//                 onPressed: () {
//                   openPDF("kaccha_pdf/$element");
//                 },
//               )),
//               DataCell(date(
//                 d: pdfDates[i],
//               )),
//               DataCell(amount(
//                 amt: pdfAmounts[i],
//               )),
//               DataCell(status(
//                 statu: pdfDue[i],
//               )),
//             ],
//           ),
//         );
//         i++;
//       },
//     );
//   }
//
//   Future<void> openPDF(String filePath) async {
//     final ref = FirebaseStorage.instance.ref().child(filePath);
//     String url = await ref.getDownloadURL();
//     Dio dio = Dio();
//     var dir = await getTemporaryDirectory();
//     var fileName = 'pdf_file.pdf';
//     var filePaths = '${dir.path}/$fileName';
//     await dio.download(url, filePaths);
//     OpenFilex.open(filePaths, type: "application/pdf");
//   }
//
//   _getpdfdate(String filePath) async {
//     final ref = FirebaseStorage.instance.ref().child(filePath);
//     final metadata = await ref.getMetadata();
//     final DateTime? lastModified = metadata.updated;
//     return lastModified?.toString().split(' ')[0] ?? 'Not Available';
//   }
//
//   readPdfAmountFromFirebase(String filePath) async {
//     final ref = FirebaseStorage.instance.ref().child(filePath);
//     String url = await ref.getDownloadURL();
//     PDFDoc doc = await PDFDoc.fromURL(url);
//     String docText = await doc.text;
//     String amount = docText.split('Total - ')[1].split('\n')[0];
//     doc.deleteFile();
//     return amount;
//   }
//
//   readPdfDuefromFirebase(String filePath) async {
//     final ref = FirebaseStorage.instance.ref().child(filePath);
//     String url = await ref.getDownloadURL();
//     PDFDoc doc = await PDFDoc.fromURL(url);
//     String docText = await doc.text;
//     String status = "Pending";
//
//     try {
//       String due = docText.split('Due - ')[1];
//     } on RangeError catch (_) {
//       status = "Paid";
//     } finally {
//       doc.deleteFile();
//     }
//     return status;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!dataloaded) {
//       return CircularProgressIndicator();
//     }
//     return DataTable(
//       columnSpacing: 18,
//       columns: [
//         DataColumn(label: Center(child: Text('    Invoice'))),
//         DataColumn(label: Text('Date')),
//         DataColumn(label: Text('Amount')),
//         DataColumn(label: Text('Status')),
//       ],
//       rows: rows,
//     );
//   }
// }
final storageRef = FirebaseStorage.instance.ref();

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  List<DataRow> rows = [];
  WhatsApp whatsapp = WhatsApp();

  @override
  void initState() {
    whatsapp.setup(
        accessToken:
            "EAAKTZCc6cp9sBAGhxmXzZAU6D9SiSb1urdt6eCeDREo8CrdICjFrBWK17jn1DKGRoGXsE6QyjQmCErpcVFrjg7oDQjN6fyJ1fS25snYIGnVDf3xCoXZBSCEuWLE9vZBU9rDorYxguofyYVicHCCY8ZB07KYprVJ4gTJhiOe9Y7psKSFNnrmsfrjlQCGcKd2Gx5CP9hSZAnJ83gDf0tS0nZA",
        fromNumberId: 15551010170);
    super.initState();
    _getData().then((data) {
      setState(() {
        rows = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 18,
      rows: rows,
      columns: [
        DataColumn(label: Text('Invoice')),
        DataColumn(label: Text('  Date')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Status')),
      ],
    );
  }

  List<String> dates = [];
  List<String> amounts = [];
  List<String> statuses = [];
  List<String> names = [];
  late String mobileno;
  _getpdfdate(String filePath) async {
    final ref = storageRef.child(filePath);
    final metadata = await ref.getMetadata();
    final DateTime? lastModified = metadata.updated;
    dates.add(lastModified?.toString().split(' ')[0] ?? 'Not Available');

    String url = await ref.getDownloadURL();
    PDFDoc doc = await PDFDoc.fromURL(url);
    String docText = await doc.text;
    String amount = docText.split('Total - ')[1].split('\n')[0];
    amounts.add(amount);

    String name = docText.split('Name- ')[1].split("Date")[0];
    names.add(name);

    String status = "Pending";

    try {
      String due = docText.split('Due - ')[1];
    } on RangeError catch (_) {
      status = "Paid";
    } finally {
      doc.deleteFile();
    }
    statuses.add(status);
  }

  sendmessage(String filePath) async {
    final ref = storageRef.child(filePath);
    String url = await ref.getDownloadURL();
    PDFDoc doc = await PDFDoc.fromURL(url);
    String docText = await doc.text;
    mobileno = "91" + docText.split('Mobile No- ')[1].split('No')[0];
    print(mobileno);
    whatsapp.messagesMediaByLink(
      to: int.parse(mobileno),
      mediaType: "application/pdf",
      mediaLink: url,
      caption: "Your Payment is due",
    );
    doc.deleteFile();
  }

  Future<void> openPDF(String filePath) async {
    final ref = storageRef.child(filePath);
    String url = await ref.getDownloadURL();
    Dio dio = Dio();
    var dir = await getTemporaryDirectory();
    var fileName = 'pdf_file.pdf';
    var filePaths = '${dir.path}/$fileName';
    await dio.download(url, filePaths);
    OpenFilex.open(filePaths, type: "application/pdf");
  }

  int k = 0;
  Future<List<DataRow>> _getData() async {
    final ListResult result = await storageRef.child('kaccha_pdf/').listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String name = await file.name;
      await _getpdfdate("kaccha_pdf/$name");
      final date = dates[k];
      final amount = amounts[k];
      final status = statuses[k];
      final n = names[k];
      rows.add(DataRow(
        onSelectChanged: (selected) {
          if (selected!) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Are you sure you want to proceed?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        // Perform the action
                        sendmessage("kaccha_pdf/$name");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        cells: [
          DataCell(
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                "$n",
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                openPDF("kaccha_pdf/$name");
              },
            ),
          ),
          DataCell(date_fn(d: date)),
          DataCell(amount_fn(amt: amount)),
          DataCell(status_fn(statu: status)),
        ],
      ));
      k++;
    });
    return rows;
  }
}
// readPdfAmountFromFirebase(String filePath) async {
//   final ref = storageRef.child(filePath);
//   String url = await ref.getDownloadURL();
//   PDFDoc doc = await PDFDoc.fromURL(url);
//   String docText = await doc.text;
//   String amount = docText.split('Total - ')[1].split('\n')[0];
//   doc.deleteFile();
//   return amount;
// }

// readPdfDuefromFirebase(String filePath) async {
//   final ref = storageRef.child(filePath);
//   String url = await ref.getDownloadURL();
//   PDFDoc doc = await PDFDoc.fromURL(url);
//   String docText = await doc.text;
//   String status = "Pending";
//
//   try {
//     String due = docText.split('Due - ')[1];
//   } on RangeError catch (_) {
//     status = "Paid";
//   } finally {
//     doc.deleteFile();
//   }
//   return status;
// }
