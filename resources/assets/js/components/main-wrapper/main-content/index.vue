<template>
  <el-container>
    <home v-show="view === 'home'"/>
    <about v-show="view === 'about'"/>
    <users v-show="view === 'users'"/>
    <profile v-show="view === 'profile'"/>
  </el-container>
</template>

<script>
import { event } from '@/utils'
import { sharedStore } from '@/stores'

import home from './home.vue'
import about from './about.vue'
import users from './users.vue'
import profile from './profile.vue'

export default {
  components: { home, about, users, profile },

  data () {
    return {
      view: 'home', // The default view
      sharedState: sharedStore.state
    }
  },

  created () {
    event.on({
      'main-content-view:load': view => {
        this.view = view
      }
    })
  }
}
</script>

<style lang="scss">



</style>
