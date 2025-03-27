package org.example.ui.crac

import org.springframework.core.env.Environment
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class Controller(val environment: Environment) {

    @GetMapping("/test")
    fun test(): String {
        val mysqlUri = environment.getProperty("spring.datasource.url")
        println("Connected to MySQL: $mysqlUri")
        return mysqlUri!!
    }
}