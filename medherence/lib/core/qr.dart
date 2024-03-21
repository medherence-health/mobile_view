//  // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'dart:convert';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrCodeScanner extends StatefulWidget {
//   QrCodeScanner({
//     Key? key,
//     this.width,
//     this.height,
//     required this.action,
//   }) : super(key: key);

//   final double? width;
//   final double? height;
//   final Future<dynamic> Function() action;

//   @override
//   _QrCodeScannerState createState() => _QrCodeScannerState();
// }

// class _QrCodeScannerState extends State<QrCodeScanner> {
//   QRViewController? _controller;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
//   String _scannedCode = '';
//   String scaned = '';
//   static const String _appId = 'dowell.qrcodescan.app&hl=en&gl=US';

//   dynamic _extractedData = {};
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   checkType(String scannedCode) async {
//     final splitedString = scannedCode.split(' ');
//     print('The splitted string is: $splitedString');
//     if (splitedString.length == 1) {
//       //either an old qr or link
//       setState(() {
//         _scannedCode = scannedCode;
//         scaned = scannedCode;
//         FFAppState().qr = scannedCode;
//       });

//       await launchAppStoreRedirect(_appId);
//     } else {
//       final qrId = splitedString[4];
//       setState(() {
//         _scannedCode = qrId;
//         scaned = qrId;
//         FFAppState().qr = qrId;
//       });

//       await launchAppStoreRedirect(_appId);
//     }
//   }

//   Future<Map<String, dynamic>> getQrCodeById(String id) async {
//     final url = Uri.parse(
//         'https://www.qrcodereviews.uxlivinglab.online/api/v5/update-qr-code/$id/');
//     final response = await http.get(url);
//     return json.decode(response.body);
//   }

// // Function to make a POST API request to decrypt QR code
//   Future<Map<String, dynamic>> decryptQrcode(String qrcodeId, String iv) async {
//     final url = Uri.parse(
//         'https://www.qrcodereviews.uxlivinglab.online/api/v5/decrypt-qrcode/');
//     final body = jsonEncode({
//       'qrcode_id': qrcodeId,
//       'iv': iv,
//     });
//     final response = await http.post(url,
//         headers: {'Content-Type': 'application/json'}, body: body);
//     return json.decode(response.body);
//   }

//   void _onQRViewCreated(QRViewController controller) async {
//     setState(() {
//       _controller = controller;
//     });

//     _controller!.scannedDataStream.listen((scanData) async {
//       final scanned = scanData.code!;
//       print('The scanned data is: $scanned');

//       if (_extractedData.contains('Decrypt it then Activate and Rescan')) {
//         final regex = RegExp(r'encrypted with (\S+) and (\S+)');
//         final match = regex.firstMatch(_extractedData);
//         if (match != null) {
//           final qrcodeId = match.group(1)!;
//           final iv = match.group(2)!;
//           print('QR code ID: $qrcodeId');
//           print('IV: $iv');

//           // Make GET request to fetch QR code data by ID
//           final qrCodeData = await getQrCodeById(qrcodeId);
//           print('The data from the get request is: $qrCodeData ');
//           // Extract qrcode_id and iv from qrCodeData
//           // final qrcodeId = qrCodeData['qrcode_id'];
//           // final iv = qrCodeData['iv'];
//           // Make POST request to decrypt QR code
//           // Extract additional fields from qrCodeData
//           final productName = qrCodeData['response'][0]['product_name'];
//           final qrcodeImageUrl = qrCodeData['response'][0]['qrcode_image_url'];
//           final createdBy = qrCodeData['response'][0]['created_by'];

//           final decryptedData = await decryptQrcode(qrcodeId, iv);
//           final extractedData = decryptedData['qrcode_id'];
//           print('The extracted data from decrypt endpoint: $extractedData');
//           setState(() {
//             _extractedData = qrCodeData['response'][0];
//           });
//           // setState(() {
//           //   _extractedData = extractedData;
//           // });
//         }
//       } else if (_extractedData.contains('Deactivated')) {
//         final splitedString = _extractedData.split(' ');
//         if (splitedString.length > 4) {
//           final qrId = splitedString[4];
//           print('The QR ID to fetch: $qrId');
//           FFAppState().qr = qrId;
//           // Make GET request to fetch QR code data by ID
//           final qrCodeData = await getQrCodeById(qrId);
//           print('The data from the get request is: $qrCodeData ');
//           // Extract qrcode_id and iv from qrCodeData
//           final qrcodeId = qrCodeData['qrcode_id'];
//           final iv = qrCodeData['iv'];
//           // Make POST request to decrypt QR code
//           // Extract additional fields from qrCodeData
//           final productName = qrCodeData['response'][0]['product_name'];
//           final qrcodeImageUrl = qrCodeData['response'][0]['qrcode_image_url'];
//           final createdBy = qrCodeData['response'][0]['created_by'];

//           final decryptedData = await decryptQrcode(qrcodeId, iv);
//           final extractedData = decryptedData['qrcode_id'];
//           print('The extracted data from decrypt endpoint: $extractedData');
//           setState(() {
//             _extractedData = qrCodeData['response'][0];
//           });
//           // setState(() {
//           //   _extractedData = extractedData;
//           // });
//         }
//       } else {
//         checkType(scanned);
//       }
//     });
//   }

//   Future<void> launchAppStoreRedirect(String appId) async {
//     // Handle platform-specific redirection
//     if (await canLaunchUrl(Uri.parse('market://details?id=$appId'))) {
//       await launchUrl(Uri.parse('market://details?id=$appId')); // Play Store
//     } else if (await canLaunchUrl(
//         Uri.parse('https://play.google.com/store/apps/details?id=$appId'))) {
//       await launchUrl(Uri.parse(
//           'https://play.google.com/store/apps/details?id=$appId')); // Web fallback
//     } else {
//       // Handle cases where redirection is not possible
//     }
//   }

//   void _launchURL() {
//     final uri = Uri.parse(_scannedCode);

//     // if (await canLaunchUrl(uri)) {
//     launchUrl(uri);
//     // } else {
//     //   // can't launch url
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: _extractedData == {}
//               ? QRView(
//                   key: _qrKey,
//                   onQRViewCreated: _onQRViewCreated,
//                   overlay: QrScannerOverlayShape(
//                     borderColor: const Color.fromARGB(30, 76, 175, 79),
//                     borderRadius: 10,
//                     borderLength: 30,
//                     borderWidth: 10,
//                     cutOutSize: 300,
//                   ),
//                 )
//               : GestureDetector(
//                   onTap: _launchURL,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 15.0, right: 15.0, top: 50.0),
//                       child: ListView.separated(
//                         itemCount: _extractedData['response'].length,
//                         separatorBuilder: (BuildContext context, int index) =>
//                             SizedBox(height: 18),
//                         itemBuilder: (BuildContext context, int index) {
//                           final item = _extractedData['response'][index];
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   offset: const Offset(0, 5),
//                                   blurRadius: 10.0,
//                                   color: Colors.black.withOpacity(0.5),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: item.entries.map((entry) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 8),
//                                   child: TextFormField(
//                                     initialValue:
//                                         '${entry.key}: ${entry.value}',
//                                     cursorColor: Colors.black,
//                                     style: TextStyle(color: Colors.black),
//                                     enabled: false,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           4.0, 0.0, 4.0, 0.0),
//                                       filled: false,
//                                       fillColor: Colors.transparent,
//                                       labelText: entry.key,
//                                       labelStyle:
//                                           TextStyle(color: Color(0xFF187B2B)),
//                                       border: OutlineInputBorder(
//                                         gapPadding: 0.0,
//                                         borderRadius: BorderRadius.circular(10),
//                                         borderSide: BorderSide(
//                                             color: Color(0xFF187B2B)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         gapPadding: 0.0,
//                                         borderRadius: BorderRadius.circular(10),
//                                         borderSide: BorderSide(
//                                             width: 3, color: Color(0xFF187B2B)),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }
// }