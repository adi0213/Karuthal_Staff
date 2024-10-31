import 'package:flutter/material.dart';

class FirstNameField extends StatelessWidget {
  final TextEditingController controller;

  const FirstNameField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }
}

class LastNameField extends StatelessWidget {
  final TextEditingController controller;

  const LastNameField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
    );
  }
}

class EmailField extends StatelessWidget {
  final String email;

  const EmailField({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: email,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

class AgeField extends StatelessWidget {
  final TextEditingController controller;

  const AgeField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your age';
        }
        return null;
      },
    );
  }
}

class CourseField extends StatelessWidget {
  final TextEditingController controller;

  const CourseField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Course',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your course';
        }
        return null;
      },
    );
  }
}

class CompletionYearField extends StatelessWidget {
  final TextEditingController controller;

  const CompletionYearField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Completion Year',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your completion year';
        }
        return null;
      },
    );
  }
}
enum Gender { MALE, FEMALE, TRANSGENDER }


class GenderField extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender?> onChanged;

  const GenderField({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Gender>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      onChanged: onChanged,
      items: Gender.values.map((Gender gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: Text(gender.toString().split('.').last),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a gender';
        }
        return null;
      },
    );
  }
}