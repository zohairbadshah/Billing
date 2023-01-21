import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'history.dart';
import 'widgets.dart';
import 'global_var.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:spelling_number/spelling_number.dart';

List<String> types = [];
List<String> bharis = [];
List<String> weights = [];
List<String> rates = [];
List<String> loading = [];
List<String> unloading = [];

final myController = TextEditingController();

Widget _field() {
  return SizedBox(
    height: 60,
    child: Row(
      children: [
        SizedBox(
          height: 140,
          width: 100,
          child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              showSelectedItems: true,
            ),
            items: [
              "6MM  ",
              "8MM  ",
              "10MM",
              '12MM',
              '16MM',
              ' B/W  ',
              ' KEEL'
            ],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "ITEM",
              ),
            ),
            onChanged: (type) {
              types.add(type!);
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          height: 85,
          width: 45,
          child: TextFormField(
            onChanged: (bhari) {
              if (bhari.isNotEmpty) {
                bharis.add(bhari);
              } else {
                bharis.add("0");
              }
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(hintText: "Bhari"),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 85,
          width: 50,
          child: TextFormField(
            onChanged: (weight) {
              weights.add(weight);
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(hintText: "Weight"),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 85,
          width: 50,
          child: TextFormField(
            onChanged: (rate) {
              rates.add(rate);
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(hintText: "Rate"),
          ),
        ),
      ],
    ),
  );
}

List<pw.Widget> pdf_widgets = [];
pw.Widget _pdffield(int i) {
  int amount =
      int.parse(items[1][i]) * int.parse(items[2][i]) * int.parse(items[3][i]);

  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 40),
    child: pw.Row(
      children: [
        pw.Center(
          child: pw.Text(
            items[0][i],
            style: pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(width: 40),
        pw.Center(
          child: pw.Text(
            items[1][i],
            style: pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(width: 60),
        pw.Center(
          child: pw.Text(
            items[2][i],
            style: pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(width: 65),
        pw.Center(
          child: pw.Text(
            items[3][i],
            style: pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(width: 60),
        pw.Center(
          child: pw.Text(
            "$amount",
            style: pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(height: 8)
      ],
    ),
  );
}

class home extends StatelessWidget {
  home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globals.current = 0;
    return Home();
  }
}

_generatekacchaPdf() async {
  final storageRef = FirebaseStorage.instance.ref().child("kaccha_pdf");
  final taskSnapshot = await storageRef.listAll();
  final int numberOfFiles = taskSnapshot.items.length;

  for (var i = 0; i < widgets.length - 1; i++) {
    pdf_widgets.add(_pdffield(i));
  }
  var labour_loading;
  var labour_unloading;
  if (isLoadingChecked) {
    labour_loading = 15;
  } else {
    labour_loading = 0;
  }
  if (isUnloadingChecked) {
    labour_unloading = 15;
  } else {
    labour_unloading = 0;
  }
  String payment_type = payment_due[0];
  String due = payment_due[1];
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Padding(
          padding: pw.EdgeInsets.all(50),
          child: pw.Column(
            children: [
              pw.Text(
                "Z&H Steels",
                style: pw.TextStyle(fontSize: 30),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(left: 30),
                      child:
                          pw.Text("Name- ", style: pw.TextStyle(fontSize: 20))),
                  pw.Text(inputs[0], style: pw.TextStyle(fontSize: 20)),
                  pw.SizedBox(width: 100),
                  pw.Text("Date- ", style: pw.TextStyle(fontSize: 20)),
                  pw.Text(inputs[2], style: pw.TextStyle(fontSize: 20))
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(left: 30),
                      child: pw.Text("Mobile No- ",
                          style: pw.TextStyle(fontSize: 20))),
                  pw.Text(inputs[1], style: pw.TextStyle(fontSize: 20)),
                  pw.SizedBox(width: 100),
                  pw.Text("No- ", style: pw.TextStyle(fontSize: 20)),
                  pw.Text("${numberOfFiles + 1}",
                      style: pw.TextStyle(fontSize: 20))
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Padding(
                padding: pw.EdgeInsets.only(left: 30),
                child: pw.Row(
                  children: [
                    pw.Text(
                      "Type",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      "Bhari",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      "Weight",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      "Rate",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      "Amount",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: pdf_widgets,
              ),
              pw.SizedBox(height: 10),
              pw.Padding(
                  padding: pw.EdgeInsets.only(left: 50),
                  child: pw.Row(children: [
                    pw.Text("Total Weight - ",
                        style: pw.TextStyle(fontSize: 20)),
                    pw.Text("$final_weight", style: pw.TextStyle(fontSize: 20)),
                  ])),
              pw.SizedBox(height: 30),
              pw.Padding(
                padding: pw.EdgeInsets.only(left: 220),
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Sub-Total - ",
                            style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 70),
                        pw.Text("$final_sub_total",
                            style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Labour Loading - ",
                            style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 27),
                        pw.Text("$labour_loading",
                            style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Labour Unloading - ",
                            style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 10),
                        pw.Text("$labour_unloading",
                            style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Total - ", style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 116),
                        pw.Text("$total", style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Payment Type - ",
                            style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 33),
                        pw.Text(payment_type,
                            style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text("Due  - ", style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(width: 125),
                        pw.Text("$due", style: pw.TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
  pdf.save();
  final kacchaRef = FirebaseStorage.instance
      .ref()
      .child("kaccha_pdf/${numberOfFiles + 1}.pdf");
  kacchaRef.putFile(file);
  OpenFilex.open('${output.path}/example.pdf');
}

_generatepakkaPdf() async {
  final storageRef = FirebaseStorage.instance.ref().child("pakka_pdf");
  final taskSnapshot = await storageRef.listAll();
  final int numberOfFiles = taskSnapshot.items.length;
  final pdf = pw.Document();
  for (var i = 0; i < widgets.length - 1; i++) {
    pdf_widgets.add(_pdffield(i));
  }
  double CGST = (9 * total) / 100;
  double total_plus_tax = total + CGST + CGST;
  pw.TextStyle style = pw.TextStyle(fontSize: 12);
  String spelled = SpellingNumber(
          lang: "en",
          wholesUnit: "Rs",
          fractionUnit: "paisa",
          digitsLengthW2F: 2,
          decimalSeperator: "and")
      .convert(total_plus_tax);
  pdf.addPage(
    pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Column(
                          children: [
                            pw.Text(
                              "Ezzi Steels and Batteries",
                              style: pw.TextStyle(
                                  fontSize: 25, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text("68, Bhayaji Road, Mhow", style: style),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text("Phone- ", style: style),
                                  pw.Text("9425073896", style: style),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text("Email- ", style: style),
                                  pw.Text("zaki.badshah21@gmail.com",
                                      style: style),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text("GSTIN- ", style: style),
                                  pw.Text("23ACDPB7186K1ZL", style: style),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: pw.Column(children: [
                              pw.Row(
                                children: [
                                  pw.Text("Bill To- ", style: style),
                                  pw.Text(inputs[0], style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("GSTIN - ", style: style),
                                  pw.Text(inputs[3], style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("State - ", style: style),
                                  pw.Text("23-Madhya Pradesh", style: style),
                                ],
                              ),
                            ]),
                          )),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text("Invoice No. - ", style: style),
                                  pw.Text(inputs[4], style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Date - ", style: style),
                                  pw.Text(inputs[1], style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("State of Supply - ", style: style),
                                  pw.Text("23-Madhya Pradesh", style: style),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text("EWay Bill - ", style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("LR No. - ", style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("LR Date - ", style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text("Date of Issue - ", style: style),
                                  pw.Text(inputs[1], style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Date of Removal of Good - ",
                                      style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Vehicle No. - ", style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Transporter Name - ", style: style),
                                  pw.Text("", style: style),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder(
                    left: pw.BorderSide(color: PdfColors.black),
                    right: pw.BorderSide(color: PdfColors.black),
                    top: pw.BorderSide(color: PdfColors.black)),
                children: [
                  pw.TableRow(children: [
                    pw.Column(children: [
                      pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: pw.Row(children: [
                            pw.Text("Item",
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 15),
                            pw.Text("Bhari",
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 15),
                            pw.Text("Weight",
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 15),
                            pw.Text("Rate",
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 15),
                            pw.Text("Amount",
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                          ])),
                    ])
                  ]),
                ],
              ),
              pw.Table(
                  border: pw.TableBorder(
                      left: pw.BorderSide(color: PdfColors.black),
                      right: pw.BorderSide(color: PdfColors.black),
                      bottom: pw.BorderSide(color: PdfColors.black)),
                  children: [
                    pw.TableRow(children: [
                      pw.Column(
                        children: pdf_widgets,
                      ),
                    ]),
                  ]),
              pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                          padding:
                              pw.EdgeInsets.only(left: 330, top: 3, bottom: 3),
                          child: pw.Row(children: [
                            pw.Text("Total(Rs.)- "),
                            pw.Text("$total")
                          ]))
                    ])
                  ]),
              pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                            flex: 1,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: pw.Column(children: [
                                pw.Text("Amount in Words: ", style: style),
                                pw.SizedBox(height: 7),
                                pw.Center(
                                    child: pw.Padding(
                                        padding: pw.EdgeInsets.symmetric(),
                                        child: pw.Text("$spelled")))
                              ]),
                            )),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text("Sub-Total - ", style: style),
                                    pw.SizedBox(width: 20),
                                    pw.Text("$final_sub_total", style: style),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text("CGST 9.00% - ", style: style),
                                    pw.SizedBox(width: 3),
                                    pw.Text("$CGST", style: style),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text("SGST 9.00% - ", style: style),
                                    pw.SizedBox(width: 3),
                                    pw.Text("$CGST", style: style),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text("Total - ", style: style),
                                    pw.SizedBox(width: 50),
                                    pw.Text("$total_plus_tax", style: style),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
              pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text("Pay To - ", style: style),
                                  pw.SizedBox(width: 20),
                                  pw.Text("Ezzi Steels and Batteries",
                                      style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Bank Name - ", style: style),
                                  pw.SizedBox(width: 3),
                                  pw.Text("Axis Bank", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("Bank A/C No. - ", style: style),
                                  pw.SizedBox(width: 3),
                                  pw.Text("915020052728258", style: style),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("IFSC - ", style: style),
                                  pw.SizedBox(width: 3),
                                  pw.Text("UTIB0000650", style: style),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                  ]),
              pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                          padding:
                              pw.EdgeInsets.only(left: 0, top: 5, bottom: 5),
                          child: pw.Column(children: [
                            pw.Text("Declaration: "),
                            pw.SizedBox(height: 5),
                            pw.Text(
                                "We declare that this invoice shpws the actual price of goods\n"
                                "describe and that all particulars are true and correct")
                          ])),
                      pw.Column(children: [
                        pw.Text("For null"),
                        pw.SizedBox(height: 60),
                        pw.Text("Authorised Signatory")
                      ])
                    ]),
                  ])
            ],
          );
        }),
  );
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/examples.pdf');
  await file.writeAsBytes(await pdf.save());
  pdf.save();
  final pakkaRef = FirebaseStorage.instance
      .ref()
      .child("pakka_pdf/invoice${numberOfFiles + 1}.pdf");
  pakkaRef.putFile(file);
  OpenFilex.open('${output.path}/examples.pdf');
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<Widget> widgets = [_field()];

List<Widget> per_item = [Text("$per_item_total")];
List<int> int_weights = [];
List<int> int_rates = [];
List<int> int_bhari = [];
List<int> rate_x_weight_x_bhari = [];
double sub_total = 0.0;
double final_sub_total = 0.0;
double total = 0.0;
bool isLoadingChecked = false;
bool isUnloadingChecked = false;
List<int> per_item_total = [];
List<String> payment_due = [];
List<String> inputs = [];
List<List<String>> items = [];
List<int> labour = [];
double final_weight = 0.0;
List<String> payments = [];
List<String> dueAmounts = [];

class _HomeState extends State<Home> {
  List<String> names = [];
  List<String> dates = [];
  List<String> numbers = [];
  List<String> GSTINS = [];
  List<String> InvoiceNumbers = [];

  TextEditingController dateInputController = TextEditingController();
  double weight = 0.0;
  int total_bhari = 0;

  @override
  Widget build(BuildContext context) {
    weight = final_weight;
    sub_total = final_sub_total;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Row(
            children: [
              Text(
                "INVOICE",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 300,
              ),
              TextButton(
                onPressed: () async {
                  if (names.isEmpty) {
                    names.add("null");
                  }
                  if (numbers.isEmpty) {
                    numbers.add("null");
                  }

                  if (dates.isEmpty) {
                    dates.add("null");
                  }
                  if (InvoiceNumbers.isEmpty) {
                    InvoiceNumbers.add("null");
                  }
                  if (GSTINS.isEmpty) {
                    GSTINS.add("0");
                  }

                  if (payments.isEmpty) {
                    payments.add("null");
                  }

                  if (dueAmounts.isEmpty) {
                    dueAmounts.add("");
                  }
                  inputs.insert(0, names[names.length - 1]);
                  inputs.insert(1, numbers[numbers.length - 1]);
                  inputs.insert(2, dates[dates.length - 1]);
                  inputs.insert(3, GSTINS[GSTINS.length - 1]);
                  inputs.insert(4, InvoiceNumbers[InvoiceNumbers.length - 1]);

                  payment_due.insert(0, payments[payments.length - 1]);
                  payment_due.insert(1, dueAmounts[dueAmounts.length - 1]);

                  if (inputs[3] == "0") {
                    await _generatekacchaPdf();
                  } else {
                    await _generatepakkaPdf();
                  }

                  setState(() {
                    inputs.clear();
                    items.clear();
                    final_weight = 0;
                    final_sub_total = 0;
                    isLoadingChecked = false;
                    isUnloadingChecked = false;
                    total_bhari = 0;
                    total = 0;
                    per_item_total.clear();
                    per_item.clear();
                    pdf_widgets.clear();
                    payment_due.clear();
                    payments.clear();
                    widgets.clear();
                  });
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => home()));
                  setState(() {
                    widgets.add(_field());
                  });
                },
                child: Icon(
                  Icons.print,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          if (bharis.isEmpty) {
            bharis.add("1");
          }
          if (widgets.length == 1) {
            items.insert(0, types[types.length - 1].split('.'));
            items.insert(1, bharis[bharis.length - 1].split('.'));
            items.insert(2, weights[weights.length - 1].split('.'));
            items.insert(3, rates[rates.length - 1].split('.'));
          } else {
            int n = widgets.length;
            for (int j = n - 1; j < n; j++) {
              items[0].insert(j, types[types.length - 1]);
              items[1].insert(j, bharis[bharis.length - 1]);
              items[2].insert(j, weights[weights.length - 1]);
              items[3].insert(j, rates[rates.length - 1]);
            }
          }

          int_weights.add(int.parse(items[2][items[2].length - 1]));
          weight += int_weights[int_weights.length - 1];

          int_rates.add(int.parse(items[3][items[3].length - 1]));

          int_bhari.add(int.parse(items[1][items[1].length - 1]));
          total_bhari += int_bhari[int_bhari.length - 1];

          rate_x_weight_x_bhari.add(int_bhari[int_bhari.length - 1] *
              int_rates[int_rates.length - 1] *
              int_weights[int_weights.length - 1]);
          sub_total += rate_x_weight_x_bhari[rate_x_weight_x_bhari.length - 1];
          per_item_total
              .add(rate_x_weight_x_bhari[rate_x_weight_x_bhari.length - 1]);

          setState(() {
            final_weight = weight;
            final_sub_total = sub_total;

            total = sub_total;
            widgets.add(_field());
          });
        },
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Navigate(0, context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextFormField(
                    onChanged: (name) {
                      setState(() {
                        names.add(name);
                      });
                    },
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextFormField(
                    onChanged: (number) {
                      setState(() {
                        numbers.add(number);
                      });
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(hintText: "Mobile No."),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextFormField(
                    controller: dateInputController,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050));
                      if (pickedDate != null) {
                        dateInputController.text =
                            pickedDate.toString().split(" ")[0];
                        dates.add(dateInputController.text);
                      }
                    },
                    decoration: InputDecoration(hintText: "Date"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextFormField(
                    onChanged: (GSTIN) {
                      setState(() {
                        GSTINS.add(GSTIN);
                      });
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(hintText: "GSTIN"),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextFormField(
                    onChanged: (InvoiceNo) {
                      setState(() {
                        InvoiceNumbers.add(InvoiceNo);
                      });
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(hintText: "Invoice No."),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(children: widgets),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text("Total Weight - "),
                    SizedBox(
                      width: 10,
                    ),
                    Text("$final_weight"),
                    SizedBox(
                      width: 40,
                    ),
                    SizedBox(
                      width: 30,
                      child: Checkbox(
                          value: isLoadingChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isLoadingChecked = value!;
                              if (isLoadingChecked == true) {
                                labour.insert(0, 15);
                                labour.insert(1, 0);
                              } else {
                                labour.insert(0, 0);
                                labour.insert(1, 0);
                              }
                              total = sub_total +
                                  labour[0] * total_bhari +
                                  labour[1] * total_bhari;
                            });
                            ;
                          }),
                    ),
                    Expanded(child: Text("Loading")),
                  ],
                ),
                Row(
                  children: [
                    Text("Sub Total - "),
                    SizedBox(
                      width: 35,
                    ),
                    Text("$final_sub_total"),
                    SizedBox(
                      width: 43,
                    ),
                    SizedBox(
                      width: 30,
                      child: Checkbox(
                          value: isUnloadingChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isUnloadingChecked = value!;

                              if (isUnloadingChecked == true) {
                                labour.insert(1, 15);
                              } else {
                                labour.insert(1, 0);
                              }
                              total = sub_total +
                                  labour[0] * total_bhari +
                                  labour[1] * total_bhari;
                            });
                          }),
                    ),
                    Text("Unloading"),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    "Total- ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 90,
                    width: 150,
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                      ),
                      items: ["Cash", "Cheque", "UPI"],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Payment Type",
                        ),
                      ),
                      onChanged: (payment) {
                        payments.add(payment!);
                      },
                    ),
                  ),
                  SizedBox(width: 50),
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: TextFormField(
                      onChanged: (dueAmount) {
                        dueAmounts.add(dueAmount);
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(hintText: "Due Amount"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
