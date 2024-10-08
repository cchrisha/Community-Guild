import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_guild/repository/job_repository.dart'; // Import JobRepository
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../widget/post_page/job_details_header.dart';
import '../widget/post_page/job_details_card.dart';
import '../widget/post_page/job_title_field.dart';
import '../widget/post_page/job_location_field.dart';
import '../widget/post_page/job_profession_dropdown.dart';
import '../widget/post_page/job_reward_field.dart';
import '../widget/post_page/job_contact_field.dart';
import '../widget/post_page/job_description_field.dart';
import '../widget/post_page/crypto_payment_checkbox.dart';
import '../widget/post_page/post_button.dart';
import 'package:http/http.dart' as http;

class PostInput extends StatefulWidget {
  const PostInput({super.key});

  @override
  PostInputState createState() => PostInputState();
}

class PostInputState extends State<PostInput> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isCrypto = false;
  String? _selectedProfession;

  final List<String> _professions = [
  'Programmer', 'Software Developer', 'Cook', 'Accountant', 'Gardener',
  'Farmer', 'Plumber', 'Electrician', 'Mechanic', 'Carpenter',
  'Teacher', 'Nurse', 'Doctor', 'Construction Worker', 'Painter',
  'Driver', 'Delivery Person', 'Salesperson', 'Cashier', 'Marketing Specialist',
  'Business Manager', 'Customer Support', 'Graphic Designer', 'Project Manager', 'Content Writer',
  'Cleaner', 'Security Guard', 'Photographer', 'Social Media Manager', 'Data Analyst',
  'Event Planner', 'Waiter', 'Hairdresser', 'Technician', 'Receptionist',
  'Tailor', 'Chef', 'Fitness Trainer', 'Barista', 'Web Developer',
  'UX/UI Designer', 'System Administrator', 'Cybersecurity Analyst', 'Mobile Developer', 'Game Developer',
  'Real Estate Agent', 'Lawyer', 'Paralegal', 'Veterinarian', 'Architect',
  'Journalist', 'Civil Engineer', 'Digital Marketer'
];

  @override
  Widget build(BuildContext context) {
    // Inject JobRepository into PostBloc
    return BlocProvider(
      create: (context) => PostBloc(JobRepository(httpClient: http.Client())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create New Job Post',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 3, 169, 244),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is PostLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is PostSuccess) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job posted successfully!')),
                );
              } else if (state is PostFailure) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const JobDetailsHeader(title: 'Job Details'),
                    const SizedBox(height: 20),
                    JobDetailsCard(
                      child: Column(
                        children: [
                          JobTitleField(controller: _titleController),
                          const SizedBox(height: 16),
                          JobLocationField(controller: _locationController),
                          const SizedBox(height: 16),
                          JobProfessionDropdown(
                            selectedProfession: _selectedProfession,
                            onChanged: (value) {
                              setState(() {
                                _selectedProfession = value;
                              });
                            },
                            professions: _professions,
                          ),
                          const SizedBox(height: 16),
                          JobRewardField(controller: _rewardController),
                          const SizedBox(height: 10),
                          CryptoPaymentCheckbox(
                            isCrypto: _isCrypto,
                            onChanged: (bool? value) {
                              setState(() {
                                _isCrypto = value ?? false;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          JobContactField(controller: _contactController),
                          const SizedBox(height: 16),
                          JobDescriptionField(controller: _descriptionController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: PostButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            BlocProvider.of<PostBloc>(context).add(
                              SubmitJob(
                                title: _titleController.text,
                                location: _locationController.text,
                                wageRange: _rewardController.text,
                                isCrypto: _isCrypto,
                                description: _descriptionController.text,
                                professions: [_selectedProfession!], // This assumes one profession is selected
                                categories: ['General'], // You can change this to an actual category field
                                poster: 'User ID', // Replace this with the actual user ID from the app's context
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _rewardController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
