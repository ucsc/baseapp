<template>
  <div class="overlay" v-if="isActive">
    <load-bar v-if="loading"/>
    <form @submit.prevent="login" :class="{ error: failed }">
      <input v-model="email" type="email" placeholder="Email Address" autofocus required>
      <input v-model="password" type="password" placeholder="Password" required>
      <button type="submit">Log In</button>
      <button class="btn btn-white btn-cancel" @click.prevent="cancel">Cancel</button>
    </form>
  </div>
</template>

<script>
import { clone } from 'lodash'
import loadBar from '../shared/load-bar.vue'
import { userStore } from '../../stores'

export default {
  name: 'modals--login-form',
  components: { loadBar },

  data () {
    return {
      loading: false,
      email: '',
      password: '',
      failed: false,
      isActive: false
    }
  },

  methods: {
    open () {
      this.isActive = true
    },

    async login () {
      try {
        await userStore.login(this.email, this.password)
        this.failed = false
        this.isActive = false

        // Reset the password so that the next login will have this field empty.
        this.password = ''

        this.$emit('loggedin')
      } catch (err) {
        this.failed = true
      }
    },

    cancel () {
      this.isActive = false
    }
  }
}
</script>

<style lang="scss" scoped>
@import "../../../sass/partials/_vars.scss";
@import "../../../sass/partials/_mixins.scss";
@import "../../../sass/partials/_shared.scss";

/**
 * I like to move it move it
 * I like to move it move it
 * I like to move it move it
 * You like to - move it!
 */
@keyframes shake {
  8%, 41% {
    -webkit-transform: translateX(-10px);
  }
  25%, 58% {
    -webkit-transform: translateX(10px);
  }
  75% {
    -webkit-transform: translateX(-5px);
  }
  92% {
    -webkit-transform: translateX(5px);
  }
  0%, 100% {
    -webkit-transform: translateX(0);
  }
}

form {
  width: 280px;
  padding: 1.8rem;
  background: rgba(255,255,255,.08);
  border-radius: .6rem;
  border: 1px solid #333;

  &.error {
    border-color: #8e4947;
    animation: shake .5s;
  }

  // &::before {
  //   content: " ";
  //   display: block;
  //   background: url(/public/img/logo.svg) center top no-repeat;
  //   background-size: 156px;
  //   height: 172px;
  // }

  @media only screen and (max-width : 414px) {
    border: 0;
    background: transparent;
  }
}

input {
  display: block;
  margin-top: 12px;
  border: 0;
  background: #fff;
  outline: none;
  width: 100%;
}

button {
  display: block;
  margin-top: 12px;
  width: 100%;
}
</style>