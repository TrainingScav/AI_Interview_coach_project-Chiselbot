package com.coach.chiselbot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = { "com.coach" })
public class ChiselbotApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChiselbotApplication.class, args);
	}

}
