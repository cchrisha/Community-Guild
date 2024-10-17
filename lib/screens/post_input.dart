import 'package:community_guild/repository/all_job_detail/job_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../widget/post_page/job_details_header.dart';
import '../widget/post_page/job_details_card.dart';
import '../widget/post_page/job_profession_dropdown.dart';
import '../widget/post_page/job_title_field.dart';
import '../widget/post_page/job_location_field.dart';
import '../widget/post_page/job_category_dropdown.dart';
import '../widget/post_page/job_reward_field.dart';
import '../widget/post_page/job_contact_field.dart';
import '../widget/post_page/job_description_field.dart';
import '../widget/post_page/crypto_payment_checkbox.dart';
import '../widget/post_page/post_button.dart';

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
  String? _selectedCategory;

  final List<String> _categories = [
    'Technology',
    'Environment',
    'Education',
    'Labor',
    'Construction',
    'Marketing',
    'Design',
    'Retail',
    'Engineering',
    'Sales',
  ];

  final List<String> _professions = [
    'Programmer',
    'Gardener',
    'Carpenter',
    'Plumber',
    'Cleaner',
    'Cook',
    'Driver',
    'Electrician',
    'Salesperson',
    'Crew',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(jobRepository: JobRepository()),
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
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is PostSuccess) {
              Navigator.pop(context); // Dismiss loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job posted successfully!')),
              );
            } else if (state is PostFailure) {
              Navigator.pop(context); // Dismiss loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
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
                              JobCategoryDropdown(
                                selectedCategory: _selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                                categories: _categories,
                              ),
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
                              JobDescriptionField(
                                  controller: _descriptionController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: PostButton(
                            onPressed: () {
                              // Check for empty fields
                              if (_titleController.text.isEmpty ||
                                  _locationController.text.isEmpty ||
                                  _rewardController.text.isEmpty ||
                                  _descriptionController.text.isEmpty ||
                                  _contactController.text.isEmpty ||
                                  _selectedProfession == null ||
                                  _selectedCategory == null) {
                                
                                // Show centered SnackBar with red background and white text
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Please fill out all required fields.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric( vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                );
                              } else {
                                // Proceed with the job posting
                                context.read<PostBloc>().add(
                                  SubmitJob(
                                    title: _titleController.text,
                                    location: _locationController.text,
                                    profession: _selectedProfession!,
                                    category: _selectedCategory!,
                                    wageRange: _rewardController.text,
                                    contact: _contactController.text,
                                    description: _descriptionController.text,
                                    isCrypto: _isCrypto,
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
              );
            },
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
