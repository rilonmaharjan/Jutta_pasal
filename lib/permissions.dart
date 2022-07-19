import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions extends StatefulWidget {
  const Permissions({Key? key}) : super(key: key);

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  bool locationSwitch = false;
  bool cameraSwitch = false;
  bool gallerySwitch = false;
  bool devicestateSwitch = false;

  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Permissions",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 235, 233, 233),
                      offset: Offset(2, 2),
                      blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.location_on,
                      size: 26,
                      color: Color.fromARGB(255, 112, 112, 112),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Location Access",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "For better delivery services",
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Color.fromARGB(255, 104, 103, 103)),
                        )
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Colors.green,
                      activeTrackColor:
                          const Color.fromARGB(255, 170, 231, 172),
                      value: locationSwitch,
                      onChanged: (value) async {
                        setState(() {
                          locationSwitch = value;
                        });
                        locationSwitch
                            ? locationPermission(value)
                            : openAppSettings().then((x) => checkStatus());
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 235, 233, 233),
                      offset: Offset(2, 2),
                      blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.camera_alt,
                      size: 26,
                      color: Color.fromARGB(255, 112, 112, 112),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Camera Access",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "Capture image for profile picture",
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Color.fromARGB(255, 104, 103, 103)),
                        )
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Colors.green,
                      activeTrackColor:
                          const Color.fromARGB(255, 170, 231, 172),
                      value: cameraSwitch,
                      onChanged: (value) async {
                        setState(() {
                          cameraSwitch = value;
                        });
                        cameraSwitch
                            ? cameraPermission(value)
                            : openAppSettings().then((x) => checkStatus());
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 235, 233, 233),
                      offset: Offset(2, 2),
                      blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.image,
                      size: 26,
                      color: Color.fromARGB(255, 112, 112, 112),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Gallery Access",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "Select image for profile picture",
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Color.fromARGB(255, 104, 103, 103)),
                        )
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Colors.green,
                      activeTrackColor:
                          const Color.fromARGB(255, 170, 231, 172),
                      value: gallerySwitch,
                      onChanged: (value) async {
                        setState(() {
                          gallerySwitch = value;
                        });
                        gallerySwitch
                            ? galleryPermission(value)
                            : openAppSettings().then((x) => checkStatus());
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 235, 233, 233),
                      offset: Offset(2, 2),
                      blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.system_security_update,
                      size: 26,
                      color: Color.fromARGB(255, 112, 112, 112),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Device State",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "For better performance",
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Color.fromARGB(255, 104, 103, 103)),
                        )
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Colors.green,
                      activeTrackColor:
                          const Color.fromARGB(255, 170, 231, 172),
                      value: devicestateSwitch,
                      onChanged: (value) {
                        setState(() {
                          devicestateSwitch = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future locationPermission(value) async {
    await Permission.location.request().then((x) => checkStatus());
  }

  Future cameraPermission(value) async {
    await Permission.camera.request().then((value) => checkStatus());
  }

  Future galleryPermission(value) async {
    await Permission.storage.request().then((value) => checkStatus());
  }

  checkStatus() async {
    final status = await Permission.location.status;
    final status1 = await Permission.camera.status;
    final status2 = await Permission.storage.status;

    if (status.isGranted) {
      setState(() {
        locationSwitch = true;
      });
    } else {
      setState(() {
        locationSwitch = false;
      });
    }

    if (status1.isGranted) {
      setState(() {
        cameraSwitch = true;
      });
    } else {
      setState(() {
        cameraSwitch = false;
      });
    }

    if (status2.isGranted) {
      setState(() {
        gallerySwitch = true;
      });
    } else {
      setState(() {
        gallerySwitch = false;
      });
    }
  }
}
