import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:postalhub_checkers_tools/pages/check_in_parcel/entities/parcel_entity.dart';
import 'package:postalhub_checkers_tools/pages/check_in_parcel/services/image_services.dart';

class CheckersParcel extends StatefulWidget {
  const CheckersParcel({super.key});

  @override
  State<CheckersParcel> createState() => _CheckersParcelState();
}

class _CheckersParcelState extends State<CheckersParcel> {
  // event/package view switching
  bool isEventDetailsVisible = true;

  // event details variables
  File? eventBannerFile;
  Uint8List? eventBannerBytes;

  var eventTitleController = TextEditingController();
  var eventDescController = TextEditingController();
  var ticketPriceController = TextEditingController();
  var eventLoactionController = TextEditingController();

  DateTime? dateSelection;
  Timestamp? timestamp;

  // packages details variables
  File? currentPackageFile;
  Uint8List? currentPackageBytes;

  List<File> merchPicFiles = [];

  var packageNameController = TextEditingController();
  var packageDescController = TextEditingController();
  var packagePriceController = TextEditingController();

  // image picking
  // ignore: unused_field
  List<XFile>? _mediaFileList;

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final ImageServices imageServices = ImageServices();

  // crop selected image
  Future _cropImage(XFile pickedFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1080,
          maxWidth: 1080,
          compressFormat:
              ImageCompressFormat.jpg, // maybe change later, test quality first
          compressQuality: 20,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

      if (isEventDetailsVisible) {
        eventBannerFile = File(croppedFile!.path);
        eventBannerBytes = await eventBannerFile!.readAsBytes();

        debugPrint(eventBannerFile!.path); // TODO: delete in production
        debugPrint(eventBannerFile!
            .lengthSync()
            .toString()); // TODO: delete in production
      } else if (!isEventDetailsVisible) {}

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // add selected image to list
  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  // pick image from gallery
  Future getImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        //imageQuality: 5,
      );
      if (pickedFile != null) {
        _setImageFileListFromFile(pickedFile);
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // take picture with camera
  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        //imageQuality: 5,
      );
      if (pickedFile != null) {
        _setImageFileListFromFile(pickedFile);
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // ui component for pick image button
  Widget _pickImageContainer() {
    if (isEventDetailsVisible) {
      return eventBannerBytes == null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xffFFC21A))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  //showOption(context);
                                  getImageFromGallery();
                                },
                                tooltip: 'Pick Image from gallery or Camera',
                                icon: const Icon(Icons.photo),
                              ),
                            ),
                            const Text("Gallery"),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  //showOption(context);
                                  getImageFromCamera();
                                },
                                icon: const Icon(Icons.camera),
                              ),
                            ),
                            const Text("Camera"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xffFFC21A))),
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Image.memory(eventBannerBytes!),
                    ),
                  ),
                ),
                Positioned(
                  top: -12,
                  left: -12,
                  child: IconButton(
                    onPressed: () {
                      eventBannerFile = null;
                      eventBannerBytes = null;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                )
              ],
            );
    } else {
      return currentPackageBytes == null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xffFFC21A))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  //showOption(context);
                                  getImageFromGallery();
                                },
                                tooltip: 'Pick Image from gallery or Camera',
                                icon: const Icon(Icons.photo),
                              ),
                            ),
                            const Text("Gallery"),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  //showOption(context);
                                  getImageFromCamera();
                                },
                                icon: const Icon(Icons.camera),
                              ),
                            ),
                            const Text("Camera"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xffFFC21A))),
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Image.memory(currentPackageBytes!),
                    ),
                  ),
                ),
                Positioned(
                  top: -12,
                  left: -12,
                  child: IconButton(
                    onPressed: () {
                      currentPackageFile = null;
                      currentPackageBytes = null;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                )
              ],
            );
    }
  }

  // error handling image
  Widget _previewImages() {
    if (_retrieveDataError != null) {
      //return retrieveError;
    }
    if (_pickImageError != null) {
      // return Text(
      //   'Pick image error: $_pickImageError',
      //   textAlign: TextAlign.center,
      // );
    }
    return _pickImageContainer();
  }

  // incase app crashes, previous image data can be retrieved
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  // pick date and time
  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(10000, 1, 1),
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // image picking view/preview for add event
            Visibility(
              visible: isEventDetailsVisible,
              child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                  ? FutureBuilder<void>(
                      future: retrieveLostData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return _pickImageContainer();
                          case ConnectionState.done:
                            return _previewImages();
                          case ConnectionState.active:
                            if (snapshot.hasError) {
                              /*return Text(
                                'Pick image error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );*/
                              debugPrint(snapshot.error.toString());
                              return _pickImageContainer();
                            } else {
                              return _pickImageContainer();
                            }
                          default:
                            return _pickImageContainer();
                        }
                      },
                    )
                  : _previewImages(),
            ),
            // image picking view/preview for add packages
            Visibility(
              visible: !isEventDetailsVisible,
              child: Column(
                children: [
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                      ? FutureBuilder<void>(
                          future: retrieveLostData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return _pickImageContainer();
                              case ConnectionState.done:
                                return _previewImages();
                              case ConnectionState.active:
                                if (snapshot.hasError) {
                                  /*return Text(
                                    'Pick image error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );*/
                                  debugPrint(snapshot.error.toString());
                                  return _pickImageContainer();
                                } else {
                                  return _pickImageContainer();
                                }
                              default:
                                return _pickImageContainer();
                            }
                          },
                        )
                      : _previewImages(),
                ],
              ),
            ),
            // navigating button between add event / add packages

            // add event detail fields, post data to database in here
            Visibility(
              visible: isEventDetailsVisible,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: eventTitleController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              labelText: 'Tracking ID'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: eventDescController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              labelText: 'Tracking ID (Additional)'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: ticketPriceController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              labelText: 'Belongs to',
                              prefixStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (eventBannerFile != null) {
                              try {
                                // get unique doc ref
                                final DocumentReference docReference =
                                    FirebaseFirestore.instance
                                        .collection("events")
                                        .doc();

                                // construct new event_entity to be posted
                                EventEntity eventEntity = EventEntity(
                                    id: docReference.id.toString(),
                                    title: eventTitleController.text,
                                    description: eventDescController.text,
                                    location: eventLoactionController.text,
                                    dateTime: dateSelection!,
                                    cost: double.parse(
                                        ticketPriceController.text),
                                    organizer: "SYNTECH",
                                    status: "Upcoming",
                                    attendees: [],
                                    bannerImageName:
                                        ("banner${p.extension(eventBannerFile!.path)}"),
                                    bannerImage: null);

                                // post event to firestore
                                await docReference.set(eventEntity.toMap());

                                // adding event image
                                /* this line post to firebase*/
                                imageServices
                                    .postImage(
                                        eventEntity.bannerImageName,
                                        docReference.id.toString(),
                                        eventBannerFile!)
                                    .then((value) {
                                  // reset event text fields
                                  eventBannerFile = null;
                                  eventBannerBytes = null;
                                  eventTitleController.clear();
                                  eventDescController.clear();
                                  ticketPriceController.clear();
                                  eventLoactionController.clear();
                                  dateSelection = null;
                                  setState(() {});
                                });

                                // adding packages image
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            } else {
                              // TODO: show dialogue
                              debugPrint("You havent selected an image");
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Add Parcel",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
