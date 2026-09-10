package com.sathwik.platform;

import com.jayway.jsonpath.JsonPath;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class CloudDevopsPlatformApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void getAllTasksShouldReturn200() throws Exception {
        mockMvc.perform(get("/api/tasks"))
                .andExpect(status().isOk());
    }

    @Test
    void createTaskShouldReturn201() throws Exception {
        mockMvc.perform(post("/api/tasks")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                            "title": "Test Task",
                            "description": "Created by automated test",
                            "status": "TODO"
                        }
                        """))
                .andExpect(status().isCreated());
    }

    @Test
    void createTaskWithBlankTitleShouldReturn400() throws Exception {
        mockMvc.perform(post("/api/tasks")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                            "title": "",
                            "description": "Invalid task",
                            "status": "TODO"
                        }
                        """))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getNonExistingTaskShouldReturn404() throws Exception {
        mockMvc.perform(get("/api/tasks/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void updateTaskShouldReturn200() throws Exception {
        MvcResult result = mockMvc.perform(post("/api/tasks")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                            "title": "Original Task",
                            "description": "Original description",
                            "status": "TODO"
                        }
                        """))
                .andExpect(status().isCreated())
                .andReturn();

        String response = result.getResponse().getContentAsString();
        Integer taskId = JsonPath.read(response, "$.id");

        mockMvc.perform(put("/api/tasks/" + taskId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                            "title": "Updated Task",
                            "description": "Updated description",
                            "status": "DONE"
                        }
                        """))
                .andExpect(status().isOk());
    }

    @Test
    void deleteTaskShouldReturn204() throws Exception {
        MvcResult result = mockMvc.perform(post("/api/tasks")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                           "title": "Task to Delete",
                           "description": "This task will be deleted",
                           "status": "TODO"
                        }
                        """))
                .andExpect(status().isCreated())
                .andReturn();

        String response = result.getResponse().getContentAsString();
        Integer taskId = JsonPath.read(response, "$.id");

        mockMvc.perform(delete("/api/tasks/" + taskId))
                .andExpect(status().isNoContent());
    }
}