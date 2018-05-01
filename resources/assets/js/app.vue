<template>


  <el-container>

    <el-header :id="[currentView=='home'?'hero':'']"><site-header/></el-header>
    <el-main><main-wrapper/><div class="push"></div></el-main>
    <el-footer><site-footer/></el-footer>

<!-- 
    <site-header/>
    <main-wrapper/>
    <site-footer/> -->

    <!-- <login-form @loggedin="onUserLoggedIn" ref="loginForm"/> -->

  </el-container>

</template>

<script>
import Vue from 'vue'

import siteHeader from './components/site-header/index.vue'
import siteFooter from './components/site-footer/index.vue'
import mainWrapper from './components/main-wrapper/index.vue'
// import overlay from './components/shared/overlay.vue'
// import loginForm from './components/modals/login-form.vue'

// import { event, showOverlay, hideOverlay, forceReloadWindow, $ } from './utils'
import { event, forceReloadWindow, $ } from './utils'
import { sharedStore, userStore, checkStore } from './stores'
import { ls, socket, http } from './services'
import { focusDirective, clickawayDirective } from './directives'
import router from './router'

export default {
  components: { siteHeader, siteFooter, mainWrapper },
  // components: { siteHeader, siteFooter, mainWrapper, overlay, loginForm },

  data () {
    return {
      authenticated: false,
      currentView: 'home'
    }
  },

  mounted () {
    // The app has just been initialized, check if we can get the user data with an already existing token
    const token = ls.get('jwt-token')
    if (token) {
      console.log(token)
      this.authenticated = true
      this.init()
    } else {
      this.isAppLogin()
      // console.log('yyes');
    }



    // And the textarea to copy stuff
    // const copyArea = document.createElement('textarea')
    // copyArea.id = 'copyArea'
    // document.body.appendChild(copyArea)

    // Add an ugly mac/non-mac class for OS-targeting styles.
    // I'm crying inside.
    $.addClass(document.documentElement, navigator.userAgent.indexOf('Mac') !== -1 ? 'mac' : 'non-mac')
  },

  methods: {
    async init () {
      // showOverlay()
      await socket.init()

      // Make the most important HTTP request to get all necessary data from the server.
      // Afterwards, init all mandatory stores and services.
      try {
        await sharedStore.init()
        // hideOverlay()
        console.log('w1')

        // Let all other components know we're ready.
        event.emit('baseapp:ready')
      } catch (err) {
        console.log('nope')
        this.authenticated = false
      }
    },

    /**
     * When the user logs in, set the whole app to be "authenticated" and initialize it.
     */
    onUserLoggedIn () {
      this.authenticated = true
      this.init()
      forceReloadWindow()
    },

    isAppLogin () {

      

      try {
        // checkStore.init()
        // this.authenticated = true
        // this.init()
        console.log('woww')
      } catch (err) {
        console.log('nooo')
      }


      // try {
      //   sharedStore.init()
        
      //   this.authenticated = true
      //   this.init()
      // } catch (err) {
      //   console.log('no go')
      //   this.authenticated = false
      // }
    }

  },

  created () {
    event.on({
      'user:loggedin': () => {
        this.authenticated = true
        this.init()
      },
      /**
       * Log the current user out and reset the application state.
       */
      async logout () {
        await userStore.logout()
        ls.remove('jwt-token')
        forceReloadWindow()
      },

      /**
       * Init our basic, custom router on ready to determine app state.
       */
      'baseapp:ready': () => {
        router.init()
      },

      'main-content-view:load': (view) => {
        this.currentView = view
      },

      // 'login:open': () => {
      //   this.$refs.loginForm.open()
      // }

    })

    // event.on('main-content-view:load', view => {
    //   this.currentView = view
    // })
  }
}

// …and the global directives
Vue.directive('baseapp-focus', focusDirective)
Vue.directive('baseapp-clickaway', clickawayDirective)
</script>

<style lang="scss">
@import "resources/assets/sass/partials/_vars.scss";
// @import "resources/assets/sass/partials/_mixins.scss";
// @import "resources/assets/sass/partials/_shared.scss";




  .el-header {
    background-color: #0B5FA6;
    height: 75px !important;
    padding-top: 7px;
  }

  .el-header, .el-footer {
    // background-color: #B3C0D1;
    color: #333;
    text-align: center;
    // line-height: 60px;
  }

  .el-footer {
    background-color: #F0F0EF;
    height: 80px !important;
  }

  #hero {
    height: 100% !important;
    background-color: #0B5FA6;
    padding: 30px 90px 60px 90px;
  }


  // .el-header {
  //   height: 200px;
  // }

   .el-main {
    background-color: #F9F9F8;
    color: #333;
    text-align: center;
    // line-height: 160px;
  }
  
  body > .el-container {
    margin-bottom: 0px;
  }

  html, body {
  height: 100% !important;
  background-color: #0B5FA6;
  font-family: 'PT Sans', sans-serif;
}
body {
  display: flex;
  flex-direction: column;
}
.el-main {
  flex: 1 0 auto;
}
.el-footer {
  flex-shrink: 0;

  border-top: #E7E7E6 1px solid;
}



// #dragGhost {
//   position: absolute;
//   display: inline-block;
//   background: $colorGreen;
//   padding: .8rem;
//   border-radius: .2rem;
//   color: #fff;
//   font-family: $fontFamily;
//   font-size: 1rem;
//   font-weight: $fontWeight_Thin;
//   top: -100px;
//   left: 0px;

//   /**
//    * We can totally hide this element on touch devices, because there's
//    * no drag and drop support there anyway.
//    */
//   html.touchevents & {
//     display: none;
//   }
// }

// #copyArea {
//   position: absolute;
//   left: -9999px;
//   width: 1px;
//   height: 1px;
//   bottom: 1px;

//   html.touchevents & {
//     display: none;
//   }
// }

// #main, .login-wrapper {
//   display: flex;
//   min-height: 100vh;
//   flex-direction: column;
//   padding-bottom: $footerHeight;
// }

// .login-wrapper {
//   @include vertical-center();

//   padding-bottom: 0;
// }
</style>
