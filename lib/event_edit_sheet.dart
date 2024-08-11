import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'server/server.dart';

class EventEditSheet extends StatefulWidget {
  final Event? event;
  final Channel? channel;
  const EventEditSheet({super.key, this.event, this.channel});

  @override
  State<StatefulWidget> createState() => EventEditSheetState();
}

class EventEditSheetState extends State<EventEditSheet> {
  bool loading = false;
  bool savable = false;
  late final titleController = TextEditingController(text: widget.event?.title);
  late final locationController = TextEditingController(text: widget.event?.location);
  late final descriptionController = TextEditingController(text: widget.event?.description);
  late bool allDayEvent = widget.event?.allDayEvent ?? true;
  late final tags = widget.event?.tags ?? List<String>.empty(growable: true);
  late final links = widget.event?.links ?? List<Link>.empty(growable: true);
  late final contacts = widget.event?.contacts ?? List<Contact>.empty(growable: true);
  final imageviewController = ImageViewController();
  late final id = widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();

    titleController.addListener(() {
      if (titleController.text.isNotEmpty != savable) {
        setState(() => savable = titleController.text.isNotEmpty );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(bottom: 32),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16),
            child: ImageView(
              id: id,
              controller: imageviewController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Event Name',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Location'
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.event),
            title: Text("January 21, 2024"),
          ),
          ListTile(
            leading: const Icon(Icons.more_time),
            title: Text("All Day Event"),
            trailing: Switch(onChanged: (value) => setState(() => allDayEvent = value), value: allDayEvent,),
          ),
          if (!allDayEvent) ListTile(
            leading: const Icon(Icons.access_time),
            title: Text("10:30 AM"),
            onTap: () {},
          ),
          const Divider(),
          if (tags.isNotEmpty) Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tags", style: TextStyle(fontWeight: FontWeight.bold)),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    children: tags.map<Widget>((e) => InputChip(
                      onDeleted: () => setState(() => tags.remove(e)),
                      label: Text(e), padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    )).toList() + [
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (context) => tagsDialog(context),
                            ).then((tag) => tag != null? setState(() => tags.add(tag)): null);
                          }
                      )
                    ],
                  ),
                ),
              ],
            )
          )
          else Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Text("No Tags Added", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Add some tags to target audience", style: TextStyle(fontSize: 12), ),
                SizedBox(height: 8,),
                FilledButton.tonal(onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (context) => tagsDialog(context),
                  ).then((tag) => tag != null? setState(() => tags.add(tag)): null);
                }, child: Text("Add Tags"))
              ],
            ),
          ),
          const Divider(),
          if (links.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Links", style: TextStyle(fontWeight: FontWeight.bold)),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      children: links.map<Widget>((e) => InputChip(
                        onDeleted: () => setState(() => links.remove(e)),
                        label: Text(e.title), padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      )).toList() + [
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showDialog<Link>(
                                context: context,
                                builder: (context) => linksDialog(context),
                              ).then((link) => link != null? setState(() => links.add(link)): null);
                            }
                        )
                      ],
                    ),
                  )
                ],
              )
          )
          else Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Text("No Links Added", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Add links like registeration or attachments if any to make it easier to acessible", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                SizedBox(height: 8,),
                FilledButton.tonal(onPressed: () {
                  showDialog<Link>(
                    context: context,
                    builder: (context) => linksDialog(context),
                  ).then((link) => link != null? setState(() => links.add(link)): null);
                }, child: Text("Add Links"))
              ],
            ),
          ),
          const Divider(),
          if (contacts.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold)),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      children: contacts.map<Widget>((e) => InputChip(
                        onDeleted: () => setState(() => contacts.remove(e)),
                        label: Text(e.name), padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      )).toList() + [
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showDialog<Contact>(
                                context: context,
                                builder: (context) => contactsDialog(context),
                              ).then((contact) => contact != null? setState(() => contacts.add(contact)): null);
                            }
                        )
                      ],
                    ),
                  )
                ],
              )
          )
          else Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Text("No Contacts Added", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Add contact info to reach you out", style: TextStyle(fontSize: 12), ),
                SizedBox(height: 8,),
                FilledButton.tonal(onPressed: () {
                  showDialog<Contact>(
                    context: context,
                    builder: (context) => contactsDialog(context),
                  ).then((contact) => contact != null? setState(() => contacts.add(contact)): null);
                }, child: Text("Add Contacts"))
              ],
            ),
          ),
          const Divider(),
          TextField(
            controller: descriptionController,
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Description",
              contentPadding: EdgeInsets.all(16)
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: FilledButton.tonal(
              onPressed: titleController.text.isEmpty? null: () {
                if (widget.event == null) {
                  final random = Random(5);
                  final event = Event(
                    id: id,
                    title: titleController.text,
                    description: descriptionController.text,
                    location: locationController.text,
                    imageUrl: imageviewController.imageUrl,
                    scheduledDateTime: DateTime.now().add(Duration(days: random.nextInt(365), hours: random.nextInt(23))),
                    allDayEvent: true,
                  );
                  event.tags.addAll(tags);
                  event.links.addAll(links);
                  event.contacts.addAll(contacts);
                  event.commit();
                  Navigator.of(context).pop(event);
                }
              },
              child: const Text("Save"),
            ),
          )
        ],
      ),
    );
  }

  AlertDialog tagsDialog(BuildContext context) {
    final inputController = TextEditingController();

    return AlertDialog(
        title: const Text("Add Tags"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tag"
              ),
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    )
                ),
                SizedBox(width: 8,),
                Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(inputController.text),
                      child: Text("Add"),
                    )
                )
              ],
            )
          ],
        )
    );
  }

  AlertDialog linksDialog(BuildContext context) {
    final titleController = TextEditingController();
    final uriController = TextEditingController();

    return AlertDialog(
        title: const Text("Add A Link"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Link Title"
              ),
            ),
            TextField(
              controller: uriController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Link URI"
              ),
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    )
                ),
                SizedBox(width: 8,),
                Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(Link(title: titleController.text, uri: uriController.text)),
                      child: Text("Add"),
                    )
                )
              ],
            )
          ],
        )
    );
  }

  AlertDialog contactsDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return AlertDialog(
        title: const Text("Add Contact Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name"
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Phone"
              ),
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    )
                ),
                SizedBox(width: 8,),
                Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(Contact(name: nameController.text, phone: phoneController.text)),
                      child: Text("Add"),
                    )
                )
              ],
            )
          ],
        )
    );
  }
}

class ImageView extends StatefulWidget {
  final ImageViewController? controller;
  final String id;

  const ImageView({super.key, this.controller, required this.id});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final controller = widget.controller ?? ImageViewController();

  bool loading = true;
  late final Reference fileRef = FirebaseStorage.instance.ref('ImagesPool/${widget.id}');

  @override
  void initState() {
    super.initState();

    fileRef.getDownloadURL().then((url) => setState(() {
      controller.imageUrl = url;
      loading = false;
    })).catchError((_) => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
      ),
      clipBehavior: Clip.hardEdge,
      width: 250,
      height: 250,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomRight,
        children: [
          if (controller.imageUrl == null) Icon(Icons.image_rounded, size: 250, color: Color(0xff808080),)
          else Image.network(controller.imageUrl!, height: 250, width: 250, fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton.filledTonal(
                onPressed: () {
                  if (controller.imageUrl == null) {
                    setState(() => loading = true);

                    FilePicker.platform.pickFiles(type: FileType.image).then((result) {
                      if (result == null) {
                        setState(() => loading = false);
                        return;
                      }

                      final file = File(result.files.single.path!);
                      final task = fileRef.putFile(file);
                      task.whenComplete(() => fileRef.getDownloadURL().then((url) {
                        controller.imageUrl = url;
                        setState(() => loading = false);
                      }));
                    });
                  } else {
                    fileRef.delete();
                    setState(() => controller.imageUrl = null);
                  }
                },
                icon: Icon((controller.imageUrl == null)? Icons.add: Icons.delete)
            ),
          ),
          if (loading) Container(
              color: Color(0x80000000),
              alignment: Alignment.center,
              child: CircularProgressIndicator(strokeWidth: 2.0)
          ),
        ],
      ),
    );
  }
}

class ImageViewController {
  String? imageUrl;
}