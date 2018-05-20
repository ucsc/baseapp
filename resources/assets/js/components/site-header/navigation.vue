<template>
  <el-menu :default-active="activeIndex[currentView]" class="el-menu" mode="horizontal" @select="handleSelect">
    
      <el-menu-item index="1">
        <a :class="['home', currentView == 'home' ? 'active' : '']" class="wordmark" href="#!/home">baseapp</a>
      </el-menu-item>
    
    
      <el-menu-item index="2" v-if="user.current.email">
        <a :class="['about', currentView == 'about' ? 'active' : '']" class="divide" href="#!/about">About</a>
      </el-menu-item>
    
    <el-submenu v-if="user.current.is_admin" index="3">
      <template slot="title">Manage</template>
      
        <el-menu-item index="3-1">
          <a :class="['users', currentView == 'users' ? 'active' : '']" href="#!/users">Users</a>
        </el-menu-item>
    </el-submenu>
    
      <!-- <el-menu-item index="5" class="right" v-if="user.current.email">
        <a class="logout" @click.prevent="logout"><i class="fa fa-sign-out control"> </i></a>
      </el-menu-item> -->
    
      

      <el-menu-item index="4" class="right" v-if="user.current.email">
        <!-- <a :class="['profile', currentView == 'profile' ? 'active' : '']" href="#!/profile">{{ user.current.name }}</a> -->
        
        <el-dropdown>
          <span class="el-dropdown-link">
            <i class="fa fa-user-circle"></i> {{ user.current.name }} <i class="el-icon-arrow-down el-icon--right"></i>
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item>
              <a :class="['profile', currentView == 'profile' ? 'active' : '']" href="#!/profile">Profile</a>
            </el-dropdown-item>
            <el-dropdown-item divided>
              <a class="logout" @click.prevent="logout">Logout</a>
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>





        <!-- <el-dropdown split-button type="primary">
          <a :class="['profile', currentView == 'profile' ? 'active' : '']" href="#!/profile">{{ user.current.name }}</a>
          <el-dropdown-menu slot="dropdown">
            <a class="logout" @click.prevent="logout">Logout</a>
          </el-dropdown-menu>
        </el-dropdown> -->



      </el-menu-item>

      <el-menu-item index="5" class="right" v-else>
        <a class="login" @click="loginYes">Login</a>
      </el-menu-item>
  </el-menu>

  <!-- <el-menu :default-active="activeIndex[currentView]" class="el-menu" mode="horizontal" @select="handleSelect">
    <a :class="['home', currentView == 'home' ? 'active' : '']" href="#!/home">
      <el-menu-item index="1">Baseapp</el-menu-item>
    </a>
    <a v-if="user.current.email" :class="['about', currentView == 'about' ? 'active' : '']" href="#!/about">
      <el-menu-item index="2">About</el-menu-item>
    </a>
    <el-submenu v-if="user.current.is_admin" index="3">
      <template slot="title">Manage</template>
      <a :class="['users', currentView == 'users' ? 'active' : '']" href="#!/users">
        <el-menu-item index="3-1">Users</el-menu-item>
      </a>
    </el-submenu>
    <a v-if="user.current.email" :class="['profile', currentView == 'profile' ? 'active' : '']" href="#!/profile">
      <el-menu-item index="4" class="right">{{ user.current.name }}</el-menu-item>
    </a>
    <a v-if="user.current.email" class="logout" @click.prevent="logout">
      <el-menu-item index="5" class="right"><i class="fa fa-sign-out control"></i></el-menu-item>
    </a>
    <a v-else class="login" href="login/hi">
      <el-menu-item index="6" class="right">Login</el-menu-item>
    </a>
  </el-menu> -->

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
// @import "../../../sass/partials/_mixins.scss";

.el-dropdown-menu__item--divided:before, .el-menu, .el-menu--horizontal>.el-menu-item:not(.is-disabled):focus, .el-menu--horizontal>.el-menu-item:not(.is-disabled):hover, .el-menu--horizontal>.el-submenu .el-submenu__title:hover {
  background-color: transparent !important;
}

.el-menu--popup {
  padding: 0;
  margin: 5 0;
}

.el-dropdown-menu {
  // color: white !important;

  a {
    color: #0B5FA6 !important;
    text-decoration: none !important;
  }
}


.el-dropdown-link {
  outline: none;
  cursor: pointer;
}

.el-menu {
  background-color: transparent !important;
  border: 0px transparent !important;
  color: white !important;
  margin: 0 10px;

  .el-menu-item, .el-menu-item:hover, .el-menu-item:active, .el-menu-item:visited, .el-menu-item:link {
    cursor: auto !important;
    border-bottom: 0px transparent !important;
    padding: 0;
    margin: 0 5px 0 0;



    a {
      padding: 12px 10px;
      color: #E7EFF6 !important;
      text-decoration: none;
      font-size: 15px;
      letter-spacing: 0.0125em;
      // margin-left: -20px;
      font-weight: 300 !important;
      margin-left: 0;

      &.active {
        color: white !important;
      }

      &.wordmark {
        font-family: 'PT Serif', serif;
        // border-right: #3E72A0 1px solid;
        // padding-right: 30px;
        font-size: 1.3em;
        padding: 12px 20px;
        // margin-right: 0px;
        letter-spacing: 0.0125em;
      }

    }

    .divide {
      border-left: #3E72A0 1px solid;
      padding-left: 25px;
    }

    .el-dropdown {
      color: white;
      margin-left: -10px;

      i{
        color: white;
      }
      i.fa {
        color: #E7EFF6 !important;
        font-size: 28px;
        padding-right: 10px;
      }
    }

  }

  .is-active {
    .el-submenu__title {
      // font-weight: 800 !important;
        color: white !important;
        letter-spacing: 0.0125em;
    }
  }

  .is-active, .is-opened {
      background-color: transparent !important;
    }

  .el-menu-item:hover {
    background-color: transparent !important;
  }

  .el-submenu {
    border-bottom: 0px transparent !important;
    color: #E7EFF6 !important;
    letter-spacing: 0.0125em;

    .el-submenu__title {
      border-bottom: 0px transparent !important;
      color: #E7EFF6 !important;
      letter-spacing: 0.0125em;
    }

    .el-submenu__title i {
      color: #E7EFF6 !important;
    }
  }

  .right {
    float: right;
  }
}

.el-menu--popup {
  margin: 0 !important;
  padding: 0 !important;
  z-index: 10000 !important;

  .el-menu-item, .el-menu-item:hover {
    background-color: white !important;
    padding: 0 !important;

    a, a:hover, a:active, a:visited {
      color: #0B5FA6 !important;
    }
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
