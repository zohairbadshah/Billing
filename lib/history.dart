import 'global_var.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'home.dart';
import 'widgets.dart';

class history extends StatelessWidget {
  const history({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globals.current = 1;
    return History();
  }
}

class History extends StatefulWidget {
  History({
    Key? key,
  }) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with AutomaticKeepAliveClientMixin {
  late DataTableWidget dataTableWidget;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    dataTableWidget = DataTableWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: Navigate(1, context),
      body: RefreshIndicator(
        onRefresh: () {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => history()));
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Card(
                elevation: 10,
                child: SizedBox(
                  height: 250,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sales analytic",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "OpenSans"),
                        ),
                        graph(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            "Billing History",
                            style:
                                TextStyle(fontSize: 18, fontFamily: "OpenSans"),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: dataTableWidget),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
