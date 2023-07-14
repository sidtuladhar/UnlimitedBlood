import 'package:flutter/material.dart';
import 'package:blood_nepal/api.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  ApiService apiService = ApiService();
  final Box _boxLogin = Hive.box("login");

  @override
  Widget build(BuildContext context) {
    String phoneNumber = _boxLogin.get("phoneNumber").toString();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          child: FutureBuilder<List>(
        future: apiService.getRequests(phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final leaderboardData = snapshot.data as List;
            //DateTime date = DateTime.parse(inputDate);

            return DataTable(
              sortColumnIndex: 0,
              columnSpacing: 15,
              columns: const <DataColumn>[
                DataColumn(label: Text('Request \nDate')),
                DataColumn(label: Text('Blood \nGroup')),
                DataColumn(label: Text('Blood \nType')),
                DataColumn(label: Text('Need \nDate')),
                DataColumn(label: Text('Quantity'), numeric: true),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Fulfilled \nBy')),
              ],
              rows: leaderboardData
                  .map(
                    (data) => DataRow(
                      cells: [
                        DataCell(Text(DateFormat('MMM d, yyyy\nh:mm a')
                            .format(DateTime.parse(data['requestDate'])))),
                        DataCell(Text(data['bloodGroup'])),
                        DataCell(Text(data['bloodType'])),
                        DataCell(Text(DateFormat('MMM d, yyyy\nh:mm a')
                            .format(DateTime.parse(data['needByDate'])))),
                        DataCell(Text(data['quantity'].toString())),
                        DataCell(Text(data['address'])),
                        DataCell(Text(data['fulfilled_by'] ?? 'Unfulfilled')),
                      ],
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Text('No data available');
          }
        },
      )),
    );
  }
}