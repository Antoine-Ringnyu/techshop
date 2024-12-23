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
  //ticket db
  final ticketDb = TicketDb();

  //nameController
  final nameController = TextEditingController();
  //contactController
  final contactController = TextEditingController();
  //issueDescriptionController
  final issueDescriptionController = TextEditingController();
  //locationController
  final locationController = TextEditingController();
  //emergency
  bool _emergency = false;
  void emergency(bool value) {
    setState(() {
      _emergency = value;
    });
  }

  //............................................................................

  // List to store images
  List<File?> _images = [];

  // Function to pick image
  Future pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null && _images.length < 2) {
      // Ensure only 2 images max
      setState(() {
        _images.add(File(image.path)); // Add the image to the list
      });
    }
  }

  //function to clear the images after submision
  void clearImages() {
    setState(() {
      _images = [];
    });
  }

  // Function to remove an image from the list
  void removeImage(int index) {
    setState(() {
      _images.removeAt(index); // Remove the image at the given index
    });
  }

  // Pick image from gallery
  Future pickImageFromGallery() async {
    await pickImage(ImageSource.gallery);
  }

  // Pick image from camera
  Future pickImageFromCamera() async {
    await pickImage(ImageSource.camera);
  }

  //..........................................................................................

  Future uploadFiles() async {
    try {
      final storage = Supabase.instance.client.storage;

      // Upload images
      for (var i = 0; i < _images.length; i++) {
        final image = _images[i];
        final fileName =
            'attachments/${DateTime.now().millisecondsSinceEpoch}_image$i.jpg';
        await storage.from('attachments').upload(fileName, image!).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Image upload successful!"),
                ),
              ),
            );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //user wants to add ticket
  Future<void> submit() async {
    //create a new ticket
    final newTicket = Ticket(
      userName: nameController.text,
      location: locationController.text,
      contact: contactController.text,
      issueDescription: issueDescriptionController.text,
      emergency: _emergency,
    );

    //safe image(s) and file in storage
    await uploadFiles();

    //save in db
    await ticketDb.createTicket(newTicket);

    //clear controllers
    nameController.clear();
    locationController.clear();
    contactController.clear();
    issueDescriptionController.clear();

    //reset emergency switch
    if (_emergency != false) {
      emergency(false);
    }

    //clear images
    clearImages();
  }

  //user wants to update ticket

  //user wants to delete ticket

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // shrinkWrap: true, // Add this property to adjust height to fit content
        children: [
          //create Ticket
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

          const SizedBox(
            height: 25,
          ),

          //emergency tab
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              //color of button
              color: Theme.of(context).colorScheme.secondary,

              //curve corners
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emergency",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "This ticket will be treated within 3 hours",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: _emergency,
                  onChanged: emergency,

                  //switch styling
                  activeColor: Theme.of(context).colorScheme.inversePrimary,
                  thumbColor: Theme.of(context).colorScheme.tertiary,
                  trackColor: Colors.grey[900],
                )
              ],
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          //customer or company name
          MyTicketTextfield(
            controller: nameController,
            hintText: "Name or Company",
            textFieldIcon: Icons.person_outlined,
            height: 1,
          ),

          const SizedBox(
            height: 10,
          ),

          //location
          MyTicketTextfield(
            controller: locationController,
            hintText: "location",
            textFieldIcon: Icons.location_on_outlined,
            height: 1,
          ),

          const SizedBox(
            height: 10,
          ),

          //telephone or email
          MyTicketTextfield(
            controller: contactController,
            hintText: "Phone or Email",
            textFieldIcon: Icons.contact_page_outlined,
            height: 1,
          ),

          const SizedBox(
            height: 10,
          ),

          //issue description
          MyTicketTextfield(
            controller: issueDescriptionController,
            hintText: "Describe the Issue",
            textFieldIcon: Icons.notes_outlined,
            height: 3,
          ),

          // ...............................................................................................
          const SizedBox(
            height: 10,
          ),

          //attatchment

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: pickImageFromCamera,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: pickImageFromGallery,
                    child: Icon(
                      Icons.image_search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // If _imageFile is not null, show the image

                  _images.isNotEmpty
                      ? Row(
                          children: [
                            // Show each image in the list
                            for (int i = 0; i < _images.length; i++)
                              Expanded(
                                child: Stack(
                                  children: [
                                    // Display each image in the list
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.file(_images[i]!),
                                    ),
                                    // Delete button on top of the image
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                            Icons.disabled_by_default_sharp,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        onPressed: () => removeImage(
                                            i), // Remove image on button press
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
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Colors.grey[200]!,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'You can attach a picture',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        )
                ],
              ))
            ],
          ),

          // ...............................................................................................

          const SizedBox(
            height: 50,
          ),
          //submit button
          MyButton(
            onTab: submit,
            text: "Submit Ticket",
          )

          // ...............................................................................................
        ],
      ),
    );
  }
}
