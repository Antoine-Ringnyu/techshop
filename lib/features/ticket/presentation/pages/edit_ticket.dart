import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/storage/data/supabase_storage_repo.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/components/my_ticket_textfield.dart';

class EditTicket extends StatefulWidget {
  final Ticket ticket;
  const EditTicket({super.key, required this.ticket});

  @override
  State<EditTicket> createState() => _EditTicketState();
}

class _EditTicketState extends State<EditTicket> {
  final supabaseTicketRepo = SupaabaseTicketRepo();
  final supabaseStorageRepo = SupabaseStorageRepo();

  // Controllers to populate with the existing ticket data
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final issueDescriptionController = TextEditingController();
  final locationController = TextEditingController();

  // List to store images
  final List<File?> _images = [];
  List<String?> imageUrls = [];

  bool _emergency = false;

  // Populate the form with existing ticket data
  @override
  void initState() {
    super.initState();
    nameController.text = widget.ticket.userName;
    contactController.text = widget.ticket.contact;
    issueDescriptionController.text = widget.ticket.issueDescription;
    locationController.text = widget.ticket.location;
    _emergency = widget.ticket.emergency;

    // if (widget.ticket.imageUrl != null && widget.ticket.imageUrl!.isNotEmpty) {
    //   _images.addAll(
    //       widget.ticket.imageUrl!.split(',').map((url) => null).toList());
    // }
  }

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
      if (_images.isEmpty) {
        imageUrls = []; // Set imageUrls to [null] if no images are picked
        return;
      }
      imageUrls.clear(); // Clear any previously stored URLs

      imageUrls = await supabaseStorageRepo
          .uploadImages(_images.map((e) => e!).toList());
    } catch (e) {
      throw Exception("Error uploading images: $e");
    }
  }

  //show confirmation dialoge
  Future<void> showConfirmationDialog() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Are you sure you want to update this ticket?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await submit(); // Proceed with submitting the update
    }
  }

  // Submit the updated ticket
  Future<void> submit() async {
    // Upload images and retrieve their URLs
    await uploadAttachment();

    // Prepare the updated ticket with the new image URLs
    final updatedTicket = Ticket(
      id: widget.ticket.id,
      userId: widget.ticket.userId,
      userName: nameController.text,
      location: locationController.text,
      contact: contactController.text,
      issueDescription: issueDescriptionController.text,
      emergency: _emergency,
      imageUrl: imageUrls.join(','), // Store URLs as a comma-separated string
    );

    await supabaseTicketRepo.updateTicket(updatedTicket, updatedTicket);

    Navigator.pop(context); // Go back to the previous screen after saving
    // Reset state
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    issueDescriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Edit Ticket'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp,
              color: Theme.of(context).colorScheme.secondary, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Ticket Details',
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary)),
              const SizedBox(height: 25),

              // Emergency toggle
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Emergency",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary)),
                        subtitle: Text(
                            "This ticket will be treated within 3 hours",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface)),
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

              // Text fields for ticket information
              MyTicketTextfield(
                  controller: nameController,
                  hintText: "Name or Company",
                  textFieldIcon: Icons.person_outlined,
                  minLines: 1),
              const SizedBox(height: 10),
              MyTicketTextfield(
                  controller: locationController,
                  hintText: "Location",
                  textFieldIcon: Icons.location_on_outlined,
                  minLines: 1),
              const SizedBox(height: 10),
              MyTicketTextfield(
                  controller: contactController,
                  hintText: "Phone or Email",
                  textFieldIcon: Icons.contact_page_outlined,
                  minLines: 1),
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
                                    if (_images[i] !=
                                        null) // Add null check here
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.file(_images[i]!,
                                                    fit: BoxFit
                                                        .cover), // Safe to use '!' now
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(Icons.cancel,
                                                    color: Colors.red),
                                                onPressed: () => setState(
                                                    () => _images.removeAt(i)),
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
                                child: Text('Attach an image(optional)',
                                    style: TextStyle(color: Colors.grey[500])),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Submit button
              MyButton(
                onTab: showConfirmationDialog,
                text: "Update Ticket",
                textColor: Theme.of(context).colorScheme.inversePrimary,
                containerColor: Theme.of(context).colorScheme.tertiary,
                borderColor: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
