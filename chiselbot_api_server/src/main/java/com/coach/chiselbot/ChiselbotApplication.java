package com.coach.chiselbot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
// BaseEntity 사용을 위해 어노테이션 추가 - sohee
public class ChiselbotApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChiselbotApplication.class, args);
	}

}
