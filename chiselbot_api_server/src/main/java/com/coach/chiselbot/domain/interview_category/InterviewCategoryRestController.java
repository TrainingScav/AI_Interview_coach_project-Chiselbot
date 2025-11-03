package com.coach.chiselbot.domain.interview_category;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/interview")
public class InterviewCategoryRestController {

    private final InterviewCategoryRepository interviewCategoryRepository;

    @GetMapping("/categories")
    public List<InterviewCategory> getAllCategories() {
        return interviewCategoryRepository.findAll();
    }
}