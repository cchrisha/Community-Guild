import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/payment_model.dart';
import '../widget/payment/balance_card.dart';
import '../widget/payment/section_title.dart';
import '../widget/payment/job_card.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ReownAppKitModal? appKitModal;
  String walletAddress = '';
  String _balance = '0';
  bool isLoading = false;
  List<TransactionDetails> transactions = [];

  final customNetwork = ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111',
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    explorerUrl: 'https://sepolia.etherscan.io/',
    isTestNetwork: true,
  );

  final String etherscanApiKey = '5KEE4GXQSGWAFCJ6CWBJPMQ5BV3VQ33IX1';

  @override
  void initState() {
    super.initState();
    initializeAppKitModal();
    loadWalletAddress();
  }

  Future<void> loadWalletAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedWalletAddress = prefs.getString('walletAddress');
    setState(() {
      walletAddress = savedWalletAddress ?? 'No Address';
    });
  }

  void initializeAppKitModal() async {
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);  
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: '2d5e262acbc9bf4a4ee3102881528534',
      metadata: const PairingMetadata(
        name: 'Crypto Flutter',
        description: 'A Crypto Flutter Example App',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: Redirect(
          native: 'cryptoflutter://',
          universal: 'https://reown.com/crpytoflutter',
          linkMode: true,
        ),
      ),
    );

    await appKitModal!.init();
    appKitModal!.addListener(updateWalletAddress);
    // Listen for session updates
    setState(() {
      fetchTransactions(walletAddress); 
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedWalletAddress = prefs.getString('walletAddress');
    if (savedWalletAddress != null) {
      setState(() {
        walletAddress = savedWalletAddress;
      });
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> updateWalletAddressInAPI(String walletAddress) async {
    final token = await getToken(); // Retrieve the token
    const url =
        'https://api-tau-plum.vercel.app/api/users'; // No userId needed here since you're using verifyToken

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: jsonEncode({'walletAddress': walletAddress}),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Wallet address updated successfully');
      } else {
        // Handle error response
        print('Failed to update wallet address: ${response.body}');
      }
    } catch (e) {
      print('Error updating wallet address: $e');
    }
  }

  void updateWalletAddress() async {
    if (appKitModal?.session != null) {
      setState(() {
        walletAddress = appKitModal!.session!.address ?? 'No Address';
        _balance = appKitModal!.balanceNotifier.value;
        fetchTransactions(
            walletAddress); // Fetch transactions whenever the wallet address is updated
      });

      // Save the wallet address to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('walletAddress', walletAddress);

      // Update the wallet address in the API
      await updateWalletAddressInAPI(walletAddress); // No userId needed here
    } else {
      setState(() {
        walletAddress = 'No Address';
        _balance = 'No Balance';
        transactions.clear(); // Clear transactions when no address
      });

      // Remove the wallet address from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('walletAddress');
    }
  }

  Future<void> fetchTransactions(String address) async {
    setState(() {
      isLoading = true;
      transactions.clear(); // Clear previous transactions while loading
    });
    try {
      final url =
          'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$etherscanApiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1') {
          final txList = data['result'] as List;
          setState(() {
            transactions = txList.map((tx) {
              // Check if the transaction is sent by the current address
              final String addressLowerCase = address
                  .toLowerCase(); // Convert address to lower case for comparison
              final String sender = tx['from'];
              final String recipient = tx['to'];
              bool isSent = sender.toLowerCase() == addressLowerCase;
              return TransactionDetails(
                sender: sender,
                recipient: recipient,
                amount: (BigInt.parse(tx['value']) / BigInt.from(10).pow(18))
                    .toString(),
                hash: tx['hash'],
                isSent: isSent,
                date: DateTime.fromMillisecondsSinceEpoch(
                    int.parse(tx['timeStamp']) * 1000),
              );
            }).toList();
          });
        } else {
          throw Exception('Failed to load transactions');
        }
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox.shrink(),
                  background: Container(
                    color: const Color.fromARGB(255, 3, 169, 244),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              BalanceCard(
                                  balance: _balance, address: walletAddress),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: const [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PaymentSectionTitle(title: 'Actions'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 16),
                          AppKitModalConnectButton(
                            appKit: appKitModal!,
                            custom: ElevatedButton(
                              onPressed: () {
                                if (appKitModal!.isConnected) {
                                  // Add logic for disconnecting
                                  appKitModal!
                                      .disconnect(); // Example method for disconnecting
                                } else {
                                  appKitModal!
                                      .openModalView(); // Open connection modal
                                }
                              },
                              child: Text(appKitModal!.isConnected
                                  ? 'Disconnect'
                                  : 'Connect Wallet'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Visibility(
                            visible: !appKitModal!
                                .isConnected, //kapag !appKitModal! naman ay yan yung kapag hindi connected tsaka lalabas yan
                            child: AppKitModalNetworkSelectButton(
                                appKit: appKitModal!),
                          ),
                          const SizedBox(height: 16),
                          Visibility(
                            visible: appKitModal!.isConnected,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showSendDialog(
                                        context); // Show send dialog on press
                                  },
                                  child: const Text('Send'),
                                ),
                                const SizedBox(width: 17),
                                ElevatedButton(
                                  onPressed: () {
                                    _showReceiveQRCode(context);
                                  },
                                  child: const Text('Receive'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const PaymentSectionTitle(title: 'Transactions'),
                      Visibility(
                        visible: appKitModal!.isConnected,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : transactions.isNotEmpty
                                ? Container(
                                    height: 350,
                                    child: ListView.builder(
                                      itemCount: transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction = transactions[index];
                                        return PaymentJobCardPage(
                                          amount: transaction.amount,
                                          sender: transaction.sender,
                                          recipient: transaction.recipient,
                                          hash: transaction.hash,
                                          date: transaction.date,
                                          isSent: transaction.isSent,
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('No transactions available'),
                                  ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          //if (isLoading)
          // const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showReceiveQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scan QR Code'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: walletAddress, // The wallet address to encode
                  version: QrVersions.auto, // Automatic version determination
                  size: 200.0, // Size of the QR code
                  gapless: false, // Specify if the QR code should be gapless
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Copy wallet address to clipboard
                    Clipboard.setData(ClipboardData(text: walletAddress))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address copied to clipboard!'),
                        ),
                      );
                    });
                  },
                  child: const Text('Copy Address'), // Button to copy address
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSendDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Crypto Token'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Recipient Address (0x..)',
                ),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount to Send',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String recipient = addressController.text;
                double amount = double.parse(amountController.text);
                BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                EtherAmount ethAmount =
                    EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                  final Uri metamaskUri = Uri.parse("metamask://");
                  launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
                });
                try {
                  await sendTransaction(recipient, ethAmount);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                 Navigator.of(context).pop();
                _openScanner(context, addressController);
              },
              child: const Text('Scan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openScanner(
      BuildContext context, TextEditingController addressController) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QRView(
          key: GlobalKey(debugLabel: 'QR'),
          onQRViewCreated: (QRViewController controller) {
            controller.scannedDataStream.listen((scanData) {
              final String? scannedAddress =
                  scanData.code; // Get the scanned address

              // Update the address controller with the scanned address
              addressController.text = scannedAddress!;

              // Show amount dialog after scanning the QR code
              Navigator.of(context).pop(); // Close the scanner
              _showAmountDialog(context, scannedAddress);
            });
          },
        ),
      ),
    );
  }

  void _showAmountDialog(BuildContext context, String scannedAddress) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Crypto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Recipient Address: $scannedAddress'),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount to Send',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Handle the sending logic here using scannedAddress and amountController.text
                String recipient = scannedAddress;
                double amount = double.parse(amountController.text);
                BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                EtherAmount ethAmount =
                    EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                Navigator.of(context).pop(); // Close the dialog

                try {
                  await sendTransaction(recipient, ethAmount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction successful!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
<<<<<<< HEAD
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Handle the sending logic here using scannedAddress and amountController.text
              String recipient = scannedAddress;
              double amount = double.parse(amountController.text);
              BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
              EtherAmount ethAmount = EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                  isLoading = true;
                  final Uri metamaskUri = Uri.parse("metamask://");
                  launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
                });
              try {
                await sendTransaction(recipient, ethAmount);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction successful!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Send'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

=======
        );
      },
    );
  }
>>>>>>> c2e4b3d2e492a625f66aac62c5ef65c6c50c6fc8

  Future<void> sendTransaction(String receiver, EtherAmount txValue) async {
    setState(() {
      isLoading = true;
    });

    final tetherContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode([
          {
            "constant": false,
            "inputs": [
              {"internalType": "address", "name": "_to", "type": "address"},
              {"internalType": "uint256", "name": "_value", "type": "uint256"}
            ],
            "name": "transfer",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ]),
        'ETH',
      ),
      EthereumAddress.fromHex(receiver),
    );

    try {
      final senderAddress = appKitModal!.session!.address!;
      final currentBalance = appKitModal!.balanceNotifier.value;

      if (currentBalance.isEmpty) {
        throw Exception('Unable to fetch wallet balance.');
      }

      BigInt balanceInWeiValue;
      try {
        // Convert the current balance from string to double, then to Wei
        double balanceInEther = double.parse(currentBalance.split(' ')[0]);
        balanceInWeiValue = BigInt.from((balanceInEther * pow(10, 18)).toInt());
      } catch (e) {
        throw Exception('Error parsing wallet balance: $e');
      }

      final balanceInWei =
          // ignore: deprecated_member_use
          EtherAmount.fromUnitAndValue(EtherUnit.wei, balanceInWeiValue);

      final totalCost = txValue.getInWei + BigInt.from(100000 * 21000);
      if (balanceInWei.getInWei < totalCost) {
        throw Exception('Insufficient funds for transaction!');
      }
      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: appKitModal!.selectedChain!.chainId,
        deployedContract: tetherContract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(senderAddress),
          to: EthereumAddress.fromHex(receiver),
          value: txValue,
          maxGas: 100000,
        ),
        parameters: [
          EthereumAddress.fromHex(receiver),
          txValue.getInWei,
        ],
      );
      //print('Transaction result: $result');

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successful!')),
        );
        await appKitModal!.loadAccountData();
        //print('Sender Address: $senderAddress');
        //print('Recipient Address: $receiver');
        //print('Amount Sent: ${txValue.getValueInUnit(EtherUnit.ether)} ETH');
      } else {
        throw Exception('Transaction failed. Please try again.');
      }
    } catch (e) {
      //print('Error sending transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }
}
