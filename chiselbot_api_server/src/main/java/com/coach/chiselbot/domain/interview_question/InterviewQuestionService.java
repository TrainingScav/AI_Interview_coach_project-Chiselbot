package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot.domain.interview_category.InterviewCategory;
import com.coach.chiselbot.domain.interview_category.InterviewCategoryRepository;
import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import jdk.jfr.Category;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class InterviewQuestionService {

    private final InterviewQuestionRepository interviewQuestionRepository;
    private final InterviewCategoryRepository interviewCategoryRepository;

    /**
     * <p>전체 QuestionList 1p당 10개 게시물</p>
     * */
    @Transactional(readOnly = true)
    public Page<QuestionResponse.FindAll> getQuestionList(int page){
        int pageSize = 10;
        Pageable pageable = PageRequest.of(page, pageSize);

        return interviewQuestionRepository.findAll(pageable).map(QuestionResponse.FindAll::new);
    }

    public List<InterviewCategory> getAllCategories(){
        return interviewCategoryRepository.findAll();
    }

    @Transactional(readOnly = true)
    public QuestionResponse.FindById getQuestionDetail(Long questionId){
        InterviewQuestion interviewQuestion = interviewQuestionRepository.findById(questionId)
                .orElseThrow(()-> new NoSuchElementException(" 해당 질문이 없습니다"));
        return new QuestionResponse.FindById(interviewQuestion);
    }

    /**
     * 카테고리 ID와 레벨을 기준으로 질문 한 건을 랜덤 조회
     */
    @Transactional(readOnly = true)
    public QuestionResponse.FindById getOneQuestion(Long categoryId, InterviewLevel level) {
        InterviewCategory category = interviewCategoryRepository.findById(categoryId)
                .orElseThrow(() -> new NoSuchElementException("해당 카테고리를 찾을 수 없습니다"));

        Optional<InterviewQuestion> questionOpt =
                interviewQuestionRepository.findFirstByCategoryId_CategoryIdAndInterviewLevel(category.getCategoryId(), level);
        return questionOpt.map(QuestionResponse.FindById::fromEntity).orElse(null);
    }
}
