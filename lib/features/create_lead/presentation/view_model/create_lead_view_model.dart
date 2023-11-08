import '../../domain/entity/create_lead_entity.dart';
import '../../domain/use_case/create_lead_use_case.dart';

class CreateLeadViewModel {
  final CreateLeadCase createLeadCase;
  late Function(String message) onSuccess;
  late Function(String exception) onError;

  CreateLeadViewModel(this.createLeadCase);

  Future<void> createLead(CreateLeadEntity createLeadEntity) async {
    try {
       createLeadCase.createLeadRepository;
      // Notify the success to the UI or any listeners
      onSuccess('New lead successfully created.');
    } on Exception catch (e) {
      // Notify the UI or any listeners about the error
      onError('$e');
    }
  }
}
