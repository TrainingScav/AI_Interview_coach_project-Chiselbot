package com.coach.chiselbot.domain.userStorage;

import com.coach.chiselbot.domain.interview_question.InterviewQuestion;
import com.coach.chiselbot.domain.interview_question.InterviewQuestionRepository;
import com.coach.chiselbot.domain.user.User;
import com.coach.chiselbot.domain.user.UserJpaRepository;
import com.coach.chiselbot.domain.userStorage.dto.StorageRequest;
import com.coach.chiselbot.domain.userStorage.dto.StorageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class UserStorageService {

    private final UserStorageRepository storageRepository;
    private final UserJpaRepository userRepository;
    private final InterviewQuestionRepository interviewQuestionRepository;

    public StorageResponse.FindById saveStorage(StorageRequest.SaveRequest request, String userEmail){
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다"));

        InterviewQuestion question = interviewQuestionRepository.findById(request.getQuestionId())
                .orElseThrow(() -> new NoSuchElementException("해당 질문을 찾을 수 없습니다"));

        UserStorage newStorage = new UserStorage();
        newStorage.setUser(user);
        newStorage.setQuestion(question);
        newStorage.setFeedback(request.getFeedback());
        newStorage.setHint(request.getHint());
        newStorage.setUserAnswer(request.getUserAnswer());
        newStorage.setSimilarity(request.getSimilarity());

        storageRepository.save(newStorage);

        return new StorageResponse.FindById(newStorage);
    }

}
