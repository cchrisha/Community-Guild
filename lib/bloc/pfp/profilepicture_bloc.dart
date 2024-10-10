import 'package:community_guild/bloc/pfp/profilepicture_event.dart';
import 'package:community_guild/bloc/pfp/profilepicture_state.dart';
import 'package:community_guild/repository/profilepicture_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePictureBloc
    extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final ProfilePictureRepository repository;

  ProfilePictureBloc(this.repository) : super(ProfilePictureInitial());

  @override
  Stream<ProfilePictureState> mapEventToState(
      ProfilePictureEvent event) async* {
    if (event is UploadProfilePicture) {
      yield ProfilePictureUploading();
      try {
        final url = await repository.uploadProfilePicture(event.profileImage);
        yield ProfilePictureUploaded(url);
      } catch (e) {
        yield ProfilePictureError(e.toString());
      }
    }
  }
}
