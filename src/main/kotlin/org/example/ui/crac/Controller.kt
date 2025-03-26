package org.example.ui.crac

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class Controller {

    @GetMapping("/test")
    fun test(): String {
        return "OK"
    }
}