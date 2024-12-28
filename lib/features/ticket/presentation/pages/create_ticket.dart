import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/ticket/data/datasources/ticket_db.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/components/my_ticket_textfield.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final ticketDb = TicketDb();

  // Controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final issueDescriptionController = TextEditingController();
  final locationController = TextEditingController();

  // Emergency state
  bool _emergency = false;

  // List to store images
  List<File?> _images = [];

  // List to store uploaded image URLs
  List<String> imageUrls = [];

  // Toggle emergency state
  void emergency(bool value) {
    setState(() {
      _emergency = value;
    });
  }

  // Pick image from either gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null && _images.length < 2) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  // Upload selected images and get their URLs
  Future<void> uploadAttachment() async {
    try {
      final storage = Supabase.instance.client.storage;
      imageUrls.clear(); // Clear any previously stored URLs

      for (int i = 0; i < _images.length; i++) {
        final fileName =
            'attachments/${DateTime.now().millisecondsSinceEpoch}_image$i.jpg';
        await storage.from('attachments').upload(fileName, _images[i]!);

        // Get the public URL of the uploaded image
        final fileUrl = storage.from('attachments').getPublicUrl(fileName);

        imageUrls.add(fileUrl);
      }
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

// Submit ticket
  Future<void> submit() async {
    // Upload images and retrieve their URLs
    await uploadAttachment();

    // Prepare the new ticket with the image URLs
    final newTicket = Ticket(
      userName: nameController.text,
      location: locationController.text,
      contact: contactController.text,
      issueDescription: issueDescriptionController.text,
      emergency: _emergency,
      imageUrl: imageUrls.join(','), // Store URLs as a comma-separated string
    );

    await ticketDb.createTicket(newTicket);

    // Reset state
    nameController.clear();
    locationController.clear();
    contactController.clear();
    issueDescriptionController.clear();
    emergency(false);
    setState(() {
      _images.clear();
      imageUrls.clear(); // Clear the URLs as well
    });
  }

  @override
  void dispose() {
    // Dispose of controllers to release resources
    nameController.dispose();
    contactController.dispose();
    issueDescriptionController.dispose();
    locationController.dispose();
    super
        .dispose(); // Always call super.dispose() after disposing of your controllers
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Title
          SizedBox(
            width: double.infinity,
            child: Text(
              'Create Ticket',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Emergency toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets
                        .zero, // Optional: Removes default padding if needed
                    title: Text(
                      "Emergency",
                      style: TextStyle(
                        // fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    subtitle: Text(
                      "This ticket will be treated within 3 hours",
                      style: TextStyle(
                        // fontSize: 12, // Smaller font size for subtitle
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _emergency,
                  onChanged: emergency,
                  activeColor: Theme.of(context).colorScheme.inversePrimary,
                  thumbColor: Theme.of(context).colorScheme.tertiary,
                  trackColor: Colors.grey[900],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Text fields
          MyTicketTextfield(
            controller: nameController,
            hintText: "Name or Company",
            textFieldIcon: Icons.person_outlined,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          MyTicketTextfield(
            controller: locationController,
            hintText: "Location",
            textFieldIcon: Icons.location_on_outlined,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          MyTicketTextfield(
            controller: contactController,
            hintText: "Phone or Email",
            textFieldIcon: Icons.contact_page_outlined,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          MyTicketTextfield(
              controller: issueDescriptionController,
              hintText: "Describe the Issue",
              textFieldIcon: Icons.notes_outlined,
              minLines: 3),
          const SizedBox(height: 10),

          // Attachments section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () => pickImage(ImageSource.camera),
                    child: Icon(Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => pickImage(ImageSource.gallery),
                    child: Icon(Icons.image_search,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _images.isNotEmpty
                        ? Row(
                            children: [
                              for (int i = 0; i < _images.length; i++)
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Image.file(_images[i]!)),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(
                                              Icons.disabled_by_default_sharp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
                                          onPressed: () => setState(
                                            () => _images.removeAt(i),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            height: 100,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              'Attach an image(optional)',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),

          // Submit button
          MyButton(onTab: submit, text: "Submit Ticket"),
        ],
      ),
    );
  }
}
