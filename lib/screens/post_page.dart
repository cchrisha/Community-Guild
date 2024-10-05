import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post/post_bloc.dart'; // Import your PostBloc
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isCrypto = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post a New Job',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(_titleController, 'Title'),
                  const SizedBox(height: 16),
                  buildTextField(_locationController, 'Location'),
                  const SizedBox(height: 16),
                  buildTextField(_professionController, 'Profession'),
                  const SizedBox(height: 16),
                  buildTextField(_rewardController, 'Wage range'),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text("Accept Crypto Payment"),
                    value: _isCrypto,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCrypto = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(_contactController, 'Contact Number'),
                  const SizedBox(height: 16),
                  buildTextField(_descriptionController, 'Description',
                      maxLines: 5),
                  const SizedBox(height: 20),
                  Center(
                    child: BlocConsumer<PostBloc, PostState>(
                      listener: (context, state) {
                        if (state is PostSuccess) {
                          // Navigate back to home page or show a success message
                          Navigator.pop(context);
                        } else if (state is PostFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is PostLoading) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Dispatch SubmitJob event
                              BlocProvider.of<PostBloc>(context).add(
                                SubmitJob(
                                  title: _titleController.text,
                                  location: _locationController.text,
                                  profession: _professionController.text,
                                  wageRange: _rewardController.text,
                                  contact: _contactController.text,
                                  description: _descriptionController.text,
                                  isCrypto: _isCrypto,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Post Job',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
