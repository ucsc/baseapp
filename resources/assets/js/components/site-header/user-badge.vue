<template>
  <div>
    <span class="profile" id="userBadge" v-if="state.current.email">
      <a class="view-profile control" href="#!/profile">
        <img class="avatar" :src="state.current.avatar" alt="Avatar"/>
        <span class="name">{{ state.current.name }}</span>
      </a>

      <a class="logout" @click.prevent="logout"><i class="fa fa-sign-out control"></i></a>
    </span>

    <span class="profile" id="userBadge" v-else>
      <button class="view-profile control" @click="loginYes">
        <span class="login">Login</span>
      </button>
    </span>
    <!-- <login-form ref="loginForm"/> -->
  </div>
</template>

<script>
import { userStore, sharedStore } from '@/stores'
import { event } from '@/utils'
import { ls } from '@/services'
// import loginForm from '@/components/modals/login-form.vue'

export default {
  name: 'site-header--user-badge',
  components: {},

  data () {
    return {
      state: userStore.state
    }
  },

  mounted () {
    // const token = ls.get('jwt-token')
    // if (token) {
    //   this.authenticated = true
    // }
    // this.yep = this.$parent.authenticated
    // this.authenticated = this.$root.$data.authenticated;

    // console.log(this.state.current.email)

    // console.log($root.$route.meta.viewport)
  },

  // ready () {
  //   this.yep = this.$parent.authenticated

  //   console.log(this.$parent.authenticated)

  // },

  methods: {
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
  }

  // created () {
  //   event.on({
  //     'badge:authenticated': () => {
  //       this.authenticated = true
  //     }
  //   })
  // }
}
</script>

<style lang="scss">
@import "../../../sass/partials/_vars.scss";
@import "../../../sass/partials/_mixins.scss";

#userBadge {
  @include vertical-center();
  justify-content: flex-end;
  flex: 0 0 $extraPanelWidth;
  padding-right: 16px;
  text-align: right;

  .avatar {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    margin-right: 8px;
  }

  .view-profile {
    margin-right: 16px;
    @include vertical-center();
  }

  @media only screen and (max-width : 667px) {
    flex: 0 0 96px;
    margin-right: 0;
    padding-right: 0;
    align-content: stretch;

    .name {
      display: none;
    }

    .view-profile, .logout {
      flex: 0 0 40px;
      font-size: 1.4rem;
      margin-right: 0;

      @include vertical-center();
    }
  }
}
</style>
