<template>
  <section id="profileWrapper">
    <h1 class="heading">
      <span>Profile</span>
    </h1>

    <div class="main-scroll-wrap">
      <form @submit.prevent="update">
        <div class="form-row">
          <label for="inputProfileName">Name</label>
          <input type="text" name="name" id="inputProfileName" v-model="state.current.name">
        </div>

        <div class="form-row">
          <label for="inputProfileEmail">Email Address</label>
          <input type="email" name="email" id="inputProfileEmail" v-model="state.current.email">
        </div>

        <div class="change-pwd">
          <div class="form-row">
            <p class="help">If you want to change your password, enter it below. <br>
              Otherwise, just leave the next two fields empty. It’s OK – no one will judge you.</p>
          </div>

          <div class="form-row">
            <label for="inputProfilePassword">New Password</label>
            <input v-model="pwd" name="password" type="password" id="inputProfilePassword" autocomplete="off">
          </div>

          <div class="form-row">
            <label for="inputProfileConfirmPassword">Confirm Password</label>
            <input v-model="confirmPwd" name="confirmPassword" type="password" id="inputProfileConfirmPassword" autocomplete="off">
          </div>
        </div>

        <div class="form-row">
          <button type="submit" class="btn btn-submit">Save</button>
        </div>
      </form>

    </div>
  </section>
</template>

<script>
import { each } from 'lodash'
import { userStore, sharedStore } from '@/stores'
import { forceReloadWindow, $ } from '@/utils'
import { http, ls } from '@/services'

export default {
  data () {
    return {
      state: userStore.state,
      cache: userStore.stub,
      pwd: '',
      confirmPwd: '',
      sharedState: sharedStore.state
    }
  },

  methods: {
    /**
     * Update the current user's profile.
     */
    async update () {
      const passwordFields = Array.from(
        document.querySelectorAll('#inputProfilePassword, #inputProfileConfirmPassword')
      )
      // A little validation put in a small place.
      if ((this.pwd || this.confirmPwd) && this.pwd !== this.confirmPwd) {
        each(passwordFields, el => $.addClass(el, 'error'))
        return
      }

      each(passwordFields, el => $.removeClass(el, 'error'))

      await userStore.updateProfile(this.pwd)
      this.pwd = ''
      this.confirmPwd = ''
    }


  }
}
</script>

<style lang="scss">
@import "../../../../sass/partials/_vars.scss";
@import "../../../../sass/partials/_mixins.scss";

#profileWrapper {
  input {
    &[type="text"], &[type="email"], &[type="password"] {
      width: 192px;
    }

    &.error {
      // Chrome won't give up its autofill style, so this is kind of a hack.
      box-shadow: 0 0 0px 1000px #ff867a inset;
    }
  }

  .change-pwd {
    margin-top: 24px;
  }

  .status {
    margin-left: 8px;
    color: $colorGreen;
  }

  .preferences {
    margin-top: 32px;
    border-top: 1px solid $color2ndBgr;

    label {
      font-size: $fontSize;
    }
  }

  @media only screen and (max-width : 667px) {
    input {
      &[type="text"], &[type="email"], &[type="password"] {
        width: 100%;
        height: 32px;
      }
    }
  }
}
</style>
