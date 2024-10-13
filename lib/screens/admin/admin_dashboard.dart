// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';

// // Define a class to represent the data for the chart
// class SalesData {
//   final String year;
//   final int sales;
//   final charts.Color color;

//   SalesData(this.year, this.sales, Color color)
//       : color = charts.ColorUtil.fromDartColor(color);
// }

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Dashboard',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             // Add the bar chart here
//             _buildBarChart(),
//             const SizedBox(height: 16),
//             _buildMetricCard('Total Users', '100', Icons.people),
//             const SizedBox(height: 16),
//             _buildMetricCard(
//                 'Pending Transactions', '5', Icons.pending_actions),
//             const SizedBox(height: 16),
//             _buildMetricCard(
//                 'Completed Transactions', '200', Icons.check_circle),
//             const SizedBox(height: 16),
//             _buildMetricCard('Total Earnings', '\$5000', Icons.attach_money),
//           ],
//         ),
//       ),
//     );
//   }

//   // Create a method to build the bar chart
//   Widget _buildBarChart() {
//     final data = [
//       SalesData('Jan', 30, Colors.blue),
//       SalesData('Feb', 70, Colors.red),
//       SalesData('Mar', 20, Colors.green),
//       SalesData('Apr', 50, Colors.orange),
//       SalesData('May', 90, Colors.purple),
//     ];

//     final series = [
//       charts.Series<SalesData, String>(
//         id: 'Sales',
//         colorFn: (SalesData sales, _) => sales.color,
//         domainFn: (SalesData sales, _) => sales.year,
//         measureFn: (SalesData sales, _) => sales.sales,
//         data: data,
//       )
//     ];

//     return Container(
//       height: 200,
//       child: charts.BarChart(
//         series,
//         animate: true,
//         barRendererDecorator: charts.BarLabelDecorator<String>(),
//         domainAxis: const charts.OrdinalAxisSpec(),
//       ),
//     );
//   }

//   Widget _buildMetricCard(String title, String value, IconData icon) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: 40, color: Colors.lightBlue),
//                 const SizedBox(width: 16),
//                 Text(title, style: const TextStyle(fontSize: 18)),
//               ],
//             ),
//             Text(value, style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
