package com.exmaple.mtei;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication // This annotation enables auto-configuration and component scanning
public class MteiBackendApplication {

    public static void main(String[] args) {
        // This line starts the Spring Boot application
        SpringApplication.run(MteiBackendApplication.class, args);
        System.out.println("\n--- MTEI Backend Application Started ---");
    }

}