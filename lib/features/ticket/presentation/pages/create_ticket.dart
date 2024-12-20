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

  //image picker
  File? _imageFile;

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

  //pick image
  Future pickImage() async {
    //picker
    final ImagePicker picker = ImagePicker();

    //pick from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    //update image preview
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  //upload
  Future uploadImage() async {
    if (_imageFile == null) return;

    //generate a unique file path
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';

    //upload the image to supabase storage
    await Supabase.instance.client.storage
        //to this bucket
        .from('attachments')
        .upload(path, _imageFile!)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image upload successful!"))),
        );
  }

  //user wants to add ticket
  void submit() {
    //create a new ticket
    final newTicket = Ticket(
      userName: nameController.text,
      location: locationController.text,
      contact: contactController.text,
      issueDescription: issueDescriptionController.text,
      emergency: _emergency,
    );

    //safe image in storage
    uploadImage();

    //save in db
    ticketDb.createTicket(newTicket);

    //clear controllers
    nameController.clear();
    locationController.clear();
    contactController.clear();
    issueDescriptionController.clear();
    if (_emergency != false) {
      emergency(false);
    }
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
              /*
              //logo
              Icon(
                Icons.auto_fix_off_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              */

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
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 32,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
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
                  GestureDetector(
                    onTap: pickImage,
                    child: Icon(
                      Icons.image_search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Container(
                      child:
                          //image preview
                          _imageFile != null
                              ? Image.file(_imageFile!)
                              : const Text(
                                  "No Image selected..",
                                ),
                    ),
                  )
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
