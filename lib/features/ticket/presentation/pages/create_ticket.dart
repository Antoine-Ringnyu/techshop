import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  //file picker
  File? _file;

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

  //.............................................................................................................
  // Function to pick any file
  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _file = file;
      });
    }
  }

  // //upload
  // Future uploadImage() async {
  //   if (_images == null) return;

  //   //generate a unique file path
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   final path = 'uploads/$fileName';

  //   //upload the image to supabase storage
  //   await Supabase.instance.client.storage
  //       //to this bucket
  //       .from('attachments')
  //       .upload(path, _images)
  //       .then(
  //         (value) => ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Image upload successful!"))),
  //       );
  // }

  //function to upload images and files to supabase
  Future uploadFiles() async {
    try {
      final storage = Supabase.instance.client.storage;

      // Upload each image
      for (var i = 0; i < _images.length; i++) {
        final file = _images[i];
        final fileName =
            'attachments/${DateTime.now().millisecondsSinceEpoch}_image$i.jpg';

        await storage.from('attachments').upload(fileName, file!);
        //to do handle respons and errors
      }

      /* 
      // Upload the file if it exists
      if (_file != null) {
        final fileName =
            'files/${DateTime.now().millisecondsSinceEpoch}_file.${_file!.path.split('.').last}';

        await storage.from('attachments').upload(fileName, _file!);
        //to do.. handles errors and respons
      }
      
      */
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
    return Container(
      decoration: BoxDecoration(
        //color of button
        color: Theme.of(context).colorScheme.inversePrimary,
        //curve corners
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
        child: Center(
          child: Column(
            // shrinkWrap: true, // Add this property to adjust height to fit content
            children: [
              //SEARCH INPUT
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Enter ticket ID or your contact",
                        hintStyle: TextStyle(color: Colors.grey[500]!),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,

                        //prefixIcon
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.secondary,
                        ),

                        //clear text icon button
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.cancel,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),

                        //border when selected
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 4,
                  ),

                  //search iconbutton
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 32,
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      onPressed: () {},
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 50,
              ),

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      GestureDetector(
                        onTap: pickFile,
                        child: Icon(
                          Icons.file_present_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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
                      Row(
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
                      ),

                      // If _file is not null, show the file name
                      // if (_file != null)
                      //   const SizedBox(
                      //     height: 10,
                      //   ),
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 16, vertical: 8),
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).colorScheme.primary,
                      //     borderRadius: BorderRadius.circular(24),
                      //   ),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       children: [
                      //         TextSpan(
                      //           text: "File :   ",
                      //           style: TextStyle(
                      //             color: Theme.of(context)
                      //                 .colorScheme
                      //                 .inversePrimary,
                      //             fontWeight: FontWeight
                      //                 .bold, // You can add any style you want here
                      //           ),
                      //         ),
                      //         TextSpan(
                      //           text: _file!.path.split('/').last,
                      //           style: TextStyle(
                      //             color: Theme.of(context).colorScheme.surface,
                      //             fontStyle: FontStyle
                      //                 .italic, // You can style this part differently
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // If neither is selected, show the default icon

                      // if (_images == null && _file == null)
                      //   const Text(
                      //     "Select an attachment",
                      //   ),
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
        ),
      ),
    );
  }
}
