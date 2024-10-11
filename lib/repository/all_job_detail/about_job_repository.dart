class AboutJobRepository {
  Future<List<String>> fetchCurrentJobs() async {
    // Simulate fetching current jobs from an API or database
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(3, (index) => 'Current Job $index');
  }

  Future<List<String>> fetchCompletedJobs() async {
    // Simulate fetching completed jobs
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) => 'Completed Job $index');
  }

  Future<List<String>> fetchRequestedJobs() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) => 'Requested Job $index');
  }

  Future<List<String>> fetchRejectedJobs() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) => 'Rejected Job $index');
  }

  Future<List<String>> fetchPostedJobs() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) => 'Posted Job $index');
  }
}
