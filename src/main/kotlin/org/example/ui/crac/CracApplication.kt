package org.example.ui.crac

import org.crac.Context
import org.crac.Core
import org.crac.Resource
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.ConfigurableApplicationContext


@SpringBootApplication
class CracApplication : Resource {

    init {
        Core.getGlobalContext().register(this)
    }

    override fun beforeCheckpoint(context: Context<out Resource?>?) {
        println("CRaC's beforeCheckpoint callback method called...")
    }

    override fun afterRestore(context: Context<out Resource?>?) {
        println("CRaC's afterRestore callback method called...")
    }

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val ctx: ConfigurableApplicationContext = runApplication<CracApplication>(*args)

            val mysqlUri = ctx.environment.getProperty("spring.datasource.url")
            println("Connected to MySQL: $mysqlUri")
        }
    }

}


//fun main(args: Array<String>) {
//    runApplication<CracApplication>(*args)
//}
//
