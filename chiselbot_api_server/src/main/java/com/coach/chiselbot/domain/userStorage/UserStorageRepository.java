package com.coach.chiselbot.domain.userStorage;

import com.coach.chiselbot.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserStorageRepository extends JpaRepository<UserStorage, Long> {

    List<UserStorage> findByUserOrderByCreatedAtDesc(User user);
}
