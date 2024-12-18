import 'package:community_guild/repository/all_job_detail/job_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../widget/loading_widget/ink_drop.dart';
import '../widget/post_page/job_details_header.dart';
import '../widget/post_page/job_details_card.dart';
import '../widget/post_page/job_profession_dropdown.dart';
import '../widget/post_page/job_title_field.dart';
import '../widget/post_page/job_location_field.dart';
import '../widget/post_page/job_category_dropdown.dart';
import '../widget/post_page/job_reward_field.dart';
import '../widget/post_page/job_description_field.dart';
import '../widget/post_page/crypto_payment_checkbox.dart';
import '../widget/post_page/post_button.dart';
import 'home.dart';

class PostInput extends StatefulWidget {
  const PostInput({super.key});

  @override
  PostInputState createState() => PostInputState();
}

class PostInputState extends State<PostInput> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _minRewardController = TextEditingController();
  final TextEditingController _maxRewardController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Row(
            children: [
              SizedBox(width: 16),
              Text(
                ' Create Job Post',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 3, 169, 244),
        ),
        body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: InkDrop(
                  // Use InkDrop as the loading animation
                  size: 40,
                  color: Colors.lightBlue,
                  ringColor: Colors.lightBlue.withOpacity(0.3),
                ),
              ),
            );
          } else if (state is PostSuccess) {
            Navigator.pop(context); // Dismiss loading indicator

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job posted successfully!')),
            );

            // Navigate to HomePage and clear stack
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
            });
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const JobDetailsHeader(title: 'Job Details'),
                        const SizedBox(height: 20),
                        JobDetailsCard(
                          child: Column(
                            children: [
                              JobTitleField(controller: _titleController),
                              const SizedBox(height: 16),
                              JobDescriptionField(
                                  controller: _descriptionController),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: JobRewardField(
                                      controller: _minRewardController,
                                      label: 'Min Wage',
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          16), // Add some spacing between the fields
                                  Expanded(
                                    child: JobRewardField(
                                      controller: _maxRewardController,
                                      label: 'Max Wage',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CryptoPaymentCheckbox(
                                isCrypto: _isCrypto,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCrypto = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: PostButton(
                            onPressed: () {
                              final double? minReward =
                                  double.tryParse(_minRewardController.text);
                              final double? maxReward =
                                  double.tryParse(_maxRewardController.text);

                              // Check for empty fields and validate wage range
                              if (_titleController.text.isEmpty ||
                                  _locationController.text.isEmpty ||
                                  _minRewardController.text.isEmpty ||
                                  _maxRewardController.text.isEmpty ||
                                  _descriptionController.text.isEmpty ||
                                  _selectedProfession == null ||
                                  _selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Please fill out all required fields.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                );
                              } else if (minReward == null ||
                                  maxReward == null ||
                                  minReward >= maxReward) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Ensure that the minimum wage is less than the maximum wage.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
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
                                        wageRange:
                                            '${_minRewardController.text} - ${_maxRewardController.text}',
                                        description:
                                            _descriptionController.text,
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
    _minRewardController.dispose();
    _maxRewardController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
