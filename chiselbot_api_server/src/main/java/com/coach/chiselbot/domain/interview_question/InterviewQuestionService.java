package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot.domain.interview_category.InterviewCategory;
import com.coach.chiselbot.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InterviewQuestionService {

    private final InterviewQuestionRepository interviewQuestionRepository;
    private final InterviewCategoryRepository interviewCategoryRepository;

    /**
     * <p>전체 QuestionList 1p당 10개 게시물</p>
     */
    @Transactional(readOnly = true)
    public Page<QuestionResponse.FindAll> getQuestionList(int page) {
        int pageSize = 10;
        Pageable pageable = PageRequest.of(page, pageSize);

        return interviewQuestionRepository.findAll(pageable).map(QuestionResponse.FindAll::new);
    }

    public List<InterviewCategory> getAllCategories() {
        return interviewCategoryRepository.findAll();
    }
}
