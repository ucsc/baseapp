<template>
  <nav class="side side-nav" id="sidebar" :class="{ showing: showing }">
    <section class="">
      <h1>You</h1>

      <ul class="menu">
        <li>
          <a :class="['home', currentView == 'home' ? 'active' : '']" href="#!/home">Home</a>
        </li>
      </ul>
    </section>

    <section v-if="user.current.is_admin" class="manage">
      <h1>Manage</h1>

      <ul class="menu">
        <li>
          <a :class="['users', currentView == 'users' ? 'active' : '']" href="#!/users">Users</a>
        </li>
      </ul>
    </section>

    <a
      :href="latestVersionUrl"
      target="_blank"
      v-if="user.current.is_admin && sharedState.currentVersion < sharedState.latestVersion"
      class="new-ver">
      Baseapp version {{ sharedState.latestVersion }} is available!
    </a>
  </nav>
</template>

<script>
import isMobile from 'ismobilejs'

import { event, $ } from '@/utils'
import { sharedStore, userStore } from '@/stores'

export default {
  components: {},

  data () {
    return {
      currentView: 'home',
      user: userStore.state,
      showing: !isMobile.phone,
      sharedState: sharedStore.state
    }
  },

  computed: {
    latestVersionUrl () {
      return `https://github.com/ucsc/baseapp/releases/tag/${this.sharedState.latestVersion}`
    }
  },

  methods: {
  },

  created () {
    event.on('main-content-view:load', view => {
      this.currentView = view

      // Hide the sidebar if on mobile
      if (isMobile.phone) {
        this.showing = false
      }
    })

     /**
     * Listen to sidebar:toggle event to show or hide the sidebar.
     * This should only be triggered on a mobile device.
     */
    event.on('sidebar:toggle', () => {
      this.showing = !this.showing
    })
  }
}
</script>

<style lang="scss">
@import "../../../../sass/partials/_vars.scss";
@import "../../../../sass/partials/_mixins.scss";


</style>

