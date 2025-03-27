package org.example.ui.crac

import org.crac.Context
import org.crac.Core
import org.crac.Resource

class Core : Resource {
    init {
        Core.getGlobalContext().register(this)
    }

    override fun beforeCheckpoint(context: Context<out Resource>?) {
        TODO("Not yet implemented")
    }

    override fun afterRestore(context: Context<out Resource>?) {
        TODO("Not yet implemented")
    }
}