import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatbotapp/hive/boxes.dart';
import 'package:chatbotapp/hive/user_model.dart'; // Import model của user
import 'package:chatbotapp/hive/settings.dart';
import 'package:chatbotapp/providers/settings_provider.dart';
import 'package:chatbotapp/widgets/build_display_image.dart';
import 'package:chatbotapp/widgets/settings_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  String userImage = '';
  String userName = 'Guest'; // Default name is 'Guest'
  bool isEditing = false; // Điều khiển trạng thái enable/disable của TextField
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  // pick an image
  void pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      if (pickedImage != null) {
        setState(() {
          file = File(pickedImage.path);
        });
      }
    } catch (e) {
      log('error : $e');
    }
  }

  // get user data
  void getUserData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // get user data from box
        final userBox = Boxes.getUser();

        // check if user data is not empty
        if (userBox.isNotEmpty) {
          final user = userBox.getAt(0);
          setState(() {
            userName = user?.name ?? 'Guest';
            userImage = user?.image ?? '';
            _nameController.text = userName; // Populate name controller
          });
        }
      },
    );
  }

  // Save user data to Hive
  void saveUserData() {
    final userBox = Boxes.getUser();
    final user = UserModel(name: userName, image: userImage);
    if (userBox.isEmpty) {
      userBox.add(user); // Add new user if box is empty
    } else {
      userBox.putAt(0, user); // Update existing user
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose(); // Clean up the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.checkmark),
            onPressed: () {
              // Save data when the user presses check
              setState(() {
                userName = _nameController.text.trim().isEmpty ? 'Guest' : _nameController.text.trim();
                saveUserData(); // Save updated user data to Hive
                isEditing = false; // Disable editing after saving
              });
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(isEditing ? CupertinoIcons.pencil_slash : CupertinoIcons.pencil),
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
              if (!isEditing) {
                _nameController.text = userName; // Reset the name to saved value when exiting edit mode
              }
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: BuildDisplayImage(
                  file: file,
                  userImage: userImage,
                  onPressed: () {
                    // open camera or gallery
                    pickImage();
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // TextField to edit username
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  hintText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditing,
              ),

              const SizedBox(height: 40.0),

              ValueListenableBuilder<Box<Settings>>(
                valueListenable: Boxes.getSettings().listenable(),
                builder: (context, box, child) {
                  if (box.isEmpty) {
                    return Column(
                      children: [
                        // ai voice
                        SettingsTile(
                          icon: CupertinoIcons.mic,
                          title: 'Enable AI voice',
                          value: false,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleSpeak(
                              value: value,
                            );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        // Theme
                        SettingsTile(
                          icon: CupertinoIcons.sun_max,
                          title: 'Theme',
                          value: false,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleDarkMode(
                              value: value,
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    final settings = box.getAt(0);
                    return Column(
                      children: [
                        // ai voice
                        SettingsTile(
                          icon: CupertinoIcons.mic,
                          title: 'Enable AI voice',
                          value: settings!.shouldSpeak,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleSpeak(
                              value: value,
                            );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        // theme
                        SettingsTile(
                          icon: settings.isDarkTheme
                              ? CupertinoIcons.moon_fill
                              : CupertinoIcons.sun_max_fill,
                          title: 'Theme',
                          value: settings.isDarkTheme,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleDarkMode(
                              value: value,
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
