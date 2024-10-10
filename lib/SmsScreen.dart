import 'package:flutter/material.dart';
import 'package:sms_sender/SmsSender.dart';

class SimSelectionScreen extends StatefulWidget {
  @override
  _SimSelectionScreenState createState() => _SimSelectionScreenState();
}

class _SimSelectionScreenState extends State<SimSelectionScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedSim = 'SIM 1'; // Default selection
  final List<String> _simOptions = ['SIM 1', 'SIM 2'];
  int simCard = 0;
  void sendMessageUsingSim(int simSlot) async {
    try {
      SmsSender smsSender = SmsSender();

      await smsSender
          .sendSMS(
              "${_phoneController.text}", // The recipient's phone number
              "${_messageController.text}", // The message
              simSlot,
              context // Specify the SIM slot (1 or 2)
              )
          .then(
        (value) {
          _phoneController.clear();
          _messageController.clear();
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Enter Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5, // Allow multiple lines for the message
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedSim,
                decoration: InputDecoration(
                  labelText: 'Select SIM',
                  border: OutlineInputBorder(),
                ),
                items: _simOptions.map((String sim) {
                  return DropdownMenuItem<String>(
                    value: sim,
                    child: Text(sim),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSim = newValue;
                    if (newValue?.toLowerCase().toString() == "sim 1") {
                      simCard = 0;
                    } else if (newValue?.toLowerCase().toString() == "sim 2") {
                      simCard = 1;
                    }
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  sendMessageUsingSim(simCard);
                  // Clear the fields after sending
                },
                child: Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
