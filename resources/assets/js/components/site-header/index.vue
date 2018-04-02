<template>
  <div :id="[currentView == 'home' ? 'mainHero' : 'mainHead']">
    <!-- <h1 class="brand" v-once>{{ appTitle }}</h1> -->
    <!-- <span class="hamburger" @click="toggleSidebar">
      <i class="fa fa-bars"></i>
    </span> -->

    <navigation/>
    <!-- <user-badge/> -->
  </div>


</template>

<script>
import config from '@/config'
import { event } from '@/utils'
import userBadge from './user-badge.vue'
import navigation from './navigation.vue'

export default {
  components: { userBadge, navigation },

  data () {
    return {
      currentView: 'home',
      appTitle: config.appTitle
    }
  },

  methods: {

  },

  created () {
    event.on('main-content-view:load', view => {
      this.currentView = view
    })
  }
}
</script>

<style lang="scss">
@import "../../../sass/partials/_vars.scss";
@import "../../../sass/partials/_mixins.scss";

  .el-header, .el-footer {
    background-color: #B3C0D1;
    color: #333;
    text-align: center;
    // line-height: 60px;
  }

   .el-main {
    background-color: #E9EEF3;
    color: #333;
    text-align: center;
    line-height: 160px;
  }
  
  body > .el-container {
    margin-bottom: 40px;
  }

</style>
