package com.sathwik.platform.repository;

import com.sathwik.platform.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskRepository extends JpaRepository<Task, Long> {

}