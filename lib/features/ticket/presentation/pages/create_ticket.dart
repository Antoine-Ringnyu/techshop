import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/auth/domain/entities/app_user.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/storage/data/supabase_storage_repo.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';
import 'package:techrx/features/ticket/presentation/components/my_ticket_textfield.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final supabaseTicketRepo = SupaabaseTicketRepo();
  final supabaseStorageRepo = SupabaseStorageRepo();
  //...............................................................................
  // Controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final issueDescriptionController = TextEditingController();
  final locationController = TextEditingController();

  // List to store images
  final List<File?> _images = [];
  // List to store uploaded image URLs
  List<String?> imageUrls = [];

  // Emergency state
  bool _emergency = false;
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

  // Upload selected images and get their URLs using the new repository
  Future<void> uploadAttachment() async {
    try {
      if (_images.isEmpty) {
        imageUrls = []; // Set imageUrls to [null] if no images are picked
        return;
      }
      imageUrls.clear(); // Clear any previously stored URLs

      // Use the SupabaseStorageRepo to upload images and get the URLs
      imageUrls = await supabaseStorageRepo
          .uploadImages(_images.map((e) => e!).toList());
    } catch (e) {
      throw Exception("Error uploading images: $e");
    }
  }

  //CURRENT USER
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //GET CURRENT USER
  void getCurrentUser() async {
    final supabaseAuthRepo = SupabaseAuthRepo();
    currentUser = await supabaseAuthRepo.getCurrentUser() as AppUser;

    // print("Current user: $currentUser");
  }

// Submit ticket
  Future<void> submit() async {
    // Upload images and retrieve their URLs
    await uploadAttachment();

    // Prepare the new ticket with the image URLs
    final newTicket = Ticket(
      userId: currentUser?.uid,
      // userId: '123456',
      userName: nameController.text,
      location: locationController.text,
      contact: contactController.text,
      issueDescription: issueDescriptionController.text,
      emergency: _emergency,
      imageUrl: imageUrls.join(','),  // Store URLs as a comma-separated string
    );

    await supabaseTicketRepo.createTicket(newTicket);

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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(_images[i]!,
                                                // width: double.infinity,
                                                fit: BoxFit.cover),
                                          )),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.red),
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
          MyButton(
            onTab: submit,
            text: "Submit Ticket",
            textColor: Theme.of(context).colorScheme.inversePrimary,
            containerColor: Theme.of(context).colorScheme.tertiary,
            borderColor: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: 42,
          ),
        ],
      ),
    );
  }
}
