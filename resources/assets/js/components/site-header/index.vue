<template>
  <div>
    <!-- <h1 class="brand" v-once>{{ appTitle }}</h1> -->
    <!-- <span class="hamburger" @click="toggleSidebar">
      <i class="fa fa-bars"></i>
    </span> -->

    <navigation/>
    <!-- <user-badge/> -->
    <!-- <div v-if="currentView == 'home'" class="outer">
      <div class="inner">
        <p>"Be the change that you want to see in the world."</p>
        <p class="author">Gandhi</p>
      </div>
    </div> -->

    <el-row :gutter="20" v-if="currentView == 'home'">
      <el-col :span="20" :offset="2" class="outer">

        <el-row :gutter="20">
          <el-col :span="22" :offset="1" class="inner">
            <p>"Be the change that you want to see in the world."</p>
            <p class="author">Gandhi</p>
          </el-col>
        </el-row>
        
      </el-col>
    </el-row>
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

<style lang="scss" scoped>
// @import "../../../sass/partials/_vars.scss";
// @import "../../../sass/partials/_mixins.scss";

  .outer {
    margin-top: 40px;
    padding: 20px 0;
    // margin: 40px 90px 0 90px;
    background-color: #0966AD;
    border-radius: 5px;
  }

  .inner {
    padding: 50px 0 40px 0;
    background-color: #076CB3;
    border-radius: 5px;
    
    letter-spacing: 0.0055em;
    font-weight: 300;

    p {
      color: #E7EFF6;
      font-size: 34px;
      padding: 20px 0;

      &.author {
        font-size: 13px;
        text-transform: uppercase;
      }
    }
  }
  

</style>
