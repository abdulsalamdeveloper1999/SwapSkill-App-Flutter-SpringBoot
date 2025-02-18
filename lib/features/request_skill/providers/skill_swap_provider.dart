// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_swap_with_spring/features/auth/models/user_model.dart';
import 'package:skill_swap_with_spring/features/request_skill/repository/skill_req_repo.dart';
import 'package:skill_swap_with_spring/shared/provider/user_provider.dart';

import '../models/skill_swap_request_dto.dart';
import '../models/skill_swap_request_response_dto.dart';

class SkillSwapProvider extends ChangeNotifier {
  final UserProvider _userProvider;
  final SkillReqRepository _skillReqRepository;
  final SharedPreferences _prefs;

  SkillSwapProvider(this._userProvider, this._prefs)
      : _skillReqRepository = SkillReqRepository(_prefs);

  late SkillSwapRequestResponseDto _requestResponseDto;

  SkillSwapRequestResponseDto get requestDto => _requestResponseDto;

  List<SkillSwapRequestResponseDto> _incomingRequest = [];
  List<SkillSwapRequestResponseDto> get incomingRequest => _incomingRequest;

  List<SkillSwapRequestResponseDto> _sentRequest = [];
  List<SkillSwapRequestResponseDto> get sentRequest => _sentRequest;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  double _score = 0;
  double get score => _score;

  Future<void> createRequest(SkillSwapRequestDto request) async {
    _isLoading = true;
    notifyListeners();
    try {
      _requestResponseDto = await _skillReqRepository.createRequest(request);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getIncomingRequest(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _incomingRequest = await _skillReqRepository.getIncomingRequests(userId);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSentRequests(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _sentRequest = await _skillReqRepository.getSentRequests(userId);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequestsStatus(String requestId, status) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _skillReqRepository.updateRequestStatus(requestId, status);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> findMatch(String userId, User otherUser) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _skillReqRepository.findMatch(userId, otherUser);
      _score = res;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
