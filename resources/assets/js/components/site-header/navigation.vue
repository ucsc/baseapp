<template>
  <el-menu :default-active="activeIndex[currentView]" class="el-menu-demo" mode="horizontal" @select="handleSelect">
    <el-menu-item index="1">
      <a :class="['home', currentView == 'home' ? 'active' : '']" href="#!/home">Baseapp</a>
    </el-menu-item>
    <el-menu-item v-if="user.current.email" index="2">
      <a :class="['about', currentView == 'about' ? 'active' : '']" href="#!/about">About</a>
    </el-menu-item>
    <el-submenu v-if="user.current.is_admin" index="3">
      <template slot="title">Manage</template>
      <el-menu-item index="3-1">
        <a :class="['users', currentView == 'users' ? 'active' : '']" href="#!/users">Users</a>
      </el-menu-item>
    </el-submenu>
    <el-menu-item v-if="user.current.email" index="5" class="right">
      <a class="logout" @click.prevent="logout"><i class="fa fa-sign-out control"></i></a>
    </el-menu-item>
    <el-menu-item v-else index="6" class="right">
      <!-- <a class="login" @click="loginYes">Login</a> -->
      <a class="login" href="login/hi">Login</a>
    </el-menu-item>
    <el-menu-item index="4" v-if="user.current.email" class="right">
      <a :class="['profile', currentView == 'profile' ? 'active' : '']" href="#!/profile">{{ user.current.name }}</a>
    </el-menu-item>
  </el-menu>

<!--   <div>
    <div><a :class="['home', currentView == 'home' ? 'active' : '']" href="#!/home">Home</a></div>
    <div><a :class="['about', currentView == 'about' ? 'active' : '']" href="#!/about" v-if="user.current.email">About</a></div>
    <div><a :class="['users', currentView == 'users' ? 'active' : '']" href="#!/users" v-if="user.current.is_admin">Users</a></div>
  </div> -->
</template>

<script>
import isMobile from 'ismobilejs'
import { event, $ } from '@/utils'
import { sharedStore, userStore } from '@/stores'

export default {
  name: 'site-header--navigation',
  components: {},

  data () {
    return {
      currentView: 'home',
      user: userStore.state,
      showing: !isMobile.phone,
      sharedState: sharedStore.state,
      activeIndex: {home: '1', about: '2', users: '3-1', profile: '4'},
    }
  },

  computed: {
    latestVersionUrl () {
      return `https://github.com/ucsc/baseapp/releases/tag/${this.sharedState.latestVersion}`
    }
  },

  methods: {
    handleSelect(key, keyPath) {
      console.log(key, keyPath);
    },
    logout () {
      event.emit('logout')
    },
    loginYes () {
      // this.$refs.loginForm.open()
      // this.$dispatch('login-form')
      event.emit('login:open')
    },
    switchAuth (value=false) {
      this.authenticated = value
    }
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
@import "../../../sass/partials/_vars.scss";
@import "../../../sass/partials/_mixins.scss";

.el-menu {
  background-color: transparent !important;
  border: 0px transparent !important;

  .el-menu-item {
    cursor: auto !important;
    border-bottom: 0px transparent !important;
  }

  .right {
    float: right;
  }
}

// #userBadge {
//   @include vertical-center();
//   justify-content: flex-end;
//   flex: 0 0 $extraPanelWidth;
//   padding-right: 16px;
//   text-align: right;

//   .avatar {
//     width: 24px;
//     height: 24px;
//     border-radius: 50%;
//     margin-right: 8px;
//   }

//   .view-profile {
//     margin-right: 16px;
//     @include vertical-center();
//   }

//   @media only screen and (max-width : 667px) {
//     flex: 0 0 96px;
//     margin-right: 0;
//     padding-right: 0;
//     align-content: stretch;

//     .name {
//       display: none;
//     }

//     .view-profile, .logout {
//       flex: 0 0 40px;
//       font-size: 1.4rem;
//       margin-right: 0;

//       @include vertical-center();
//     }
//   }
// }
</style>
