import '../models/incident_request.dart';
import '../services/incident_service.dart';

class IncidentRepository {
  IncidentRepository({IncidentService? incidentService})
      : _incidentService = incidentService ?? IncidentService();

  final IncidentService _incidentService;

  Future<void> submitIncident(IncidentRequest request) {
    return _incidentService.submitIncident(request);
  }
}
