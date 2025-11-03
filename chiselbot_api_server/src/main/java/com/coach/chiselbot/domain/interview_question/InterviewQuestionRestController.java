package com.coach.chiselbot.domain.interview_question;

import com.coach.chiselbot.domain.interview_question.dto.QuestionResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/interview/questions")
public class InterviewQuestionRestController {

    private final InterviewQuestionService interviewQuestionService;

    // GET /api/interview/questions/one?categoryId=2&level=LEVEL_1
    @GetMapping("/one")
    public ResponseEntity<?> getOneQuestion(
            @RequestParam(name = "categoryId") Long categoryId,
            @RequestParam(name = "level") InterviewLevel level
    ) {
        System.out.println("categoryId: " + categoryId);
        System.out.println("level: " + level);
        QuestionResponse.FindById dto = interviewQuestionService.getOneQuestion(categoryId, level);
        System.out.println("DTO: " + dto.toString());
        if (dto == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(dto);
    }
}