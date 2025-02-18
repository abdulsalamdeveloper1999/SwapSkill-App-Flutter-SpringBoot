import '../models/request_enum.dart';
import '../models/skill_swap_request_dto.dart';
import '../models/skill_swap_request_response_dto.dart';

abstract class SkillSwapService {
  Future<SkillSwapRequestResponseDto> createRequest(
      SkillSwapRequestDto request);

  Future<List<SkillSwapRequestResponseDto>> getSentRequests(String userId);

  Future<List<SkillSwapRequestResponseDto>> getIncomingRequests(String userId);

  updateRequestStatus(String requestId, RequestStatus status);
}
