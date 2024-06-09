import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/utils/button_style.dart';
import 'package:nata/utils/colors.dart';
import 'package:nata/utils/input_field_style.dart';
import 'package:nata/utils/theme_style.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final HabitController _habitController = Get.find<HabitController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedDuration = 7;
  final List<int> _durations = [7, 14, 21, 30];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Habit",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser();
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Duration",
                    style: titleStyle,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Wrap(
                    children: List<Widget>.generate(
                      _durations.length,
                      (int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ChoiceChip(
                            label: Text("${_durations[index]} days"),
                            selected: _selectedDuration == _durations[index],
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedDuration = _durations[index];
                              });
                            },
                            selectedColor: bluishClr,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.grey[200],
                            side: const BorderSide(color: Colors.grey),
                            labelStyle: TextStyle(
                              color: _selectedDuration == _durations[index] ? Colors.white : Colors.black,
                              fontSize: 13.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(label: "Create Habit", onTab: () => _validateData())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty) {
      _addHabitToDb();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "Title is required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }

  _addHabitToDb() async {
    int value = await _habitController.addHabitItem(
      habitItem: HabitItem(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        duration: _selectedDuration,
      ),
    );
    debugPrint("New id $value");
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            "Assets/images/profile.png",
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      debugPrint("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      debugPrint("Time cancelled");
    } else {
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute));
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(DateFormat('hh').format(DateFormat('hh:mm a').parse(_startTime))),
        minute: int.parse(DateFormat('mm').format(DateFormat('hh:mm a').parse(_startTime))),
      ),
    );
  }
}
