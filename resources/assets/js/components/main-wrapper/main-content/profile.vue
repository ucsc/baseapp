<template>
  <section id="profileWrapper">
    <h1 class="heading">
      <span>Profile</span>
    </h1>

    <el-form :model="state.current" ref="state.current" status-icon label-width="120px">
      <el-form-item label="Name">
        <el-input v-model="state.current.name"></el-input>
      </el-form-item>
      <el-form-item prop="email" label="Email" :rules="[
          { required: true, message: 'Please input email address', trigger: 'blur' },
          { type: 'email', message: 'Please input correct email address', trigger: 'blur,change' }
        ]">
        <el-input v-model="state.current.email"></el-input>
      </el-form-item>

      <p class="help">If you want to change your password, enter it below. 
        <br> Otherwise, just leave the next two fields empty. It’s OK – no one will judge you.
      </p>


      <el-form-item label="Password" prop="pass" :rules="[
          { validator: validatePass, trigger: 'blur' }
        ]">
        <el-input type="password" v-model="pass" auto-complete="off"></el-input>
      </el-form-item>
      <el-form-item label="Confirm" prop="checkPass" :rules="[
          { validator: validatePass2, trigger: 'blur, change' }
        ]">
        <el-input type="password" v-model="checkPass" auto-complete="off"></el-input>
      </el-form-item>
      
      <el-form-item>
        <el-button type="primary" @click="update">Save</el-button>
      </el-form-item>
    </el-form>











    <!-- <div class="main-scroll-wrap">
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

    </div> -->



  </section>
</template>

<script>
import { each } from 'lodash'
import { userStore, sharedStore } from '@/stores'
import { forceReloadWindow, $ } from '@/utils'
import { http, ls } from '@/services'

export default {
  data () {
    //    const validatePass = (rule, value, callback) => {
    //   if (value === '') {
    //     callback(new Error('Please input the password'));
    //   } else {
    //     if (this.checkPass !== '') {
    //       this.$refs.profileForm.validateField('checkPass');
    //     }
    //     callback();
    //   }
    // };
    // const validatePass2 = (rule, value, callback) => {
    //   if (value === '') {
    //     callback(new Error('Please input the password again'));
    //   } else if (value !== this.pass) {
    //     callback(new Error('Two inputs don\'t match!'));
    //   } else {
    //     callback();
    //   }
    // };
    return {
      state: userStore.state,
      cache: userStore.stub,
      pass: '',
      checkPass: '',
      sharedState: sharedStore.state,
      profileForm: {
        pass: '',
        checkPass: '',
        profile: userStore.state.current
      }
    }
    // var validatePass = (rule, value, callback) => {
    //   if (value === '') {
    //     callback(new Error('Please input the password'));
    //   } else {
    //     if (this.checkPass !== '') {
    //       this.$refs.profileForm.validateField('checkPass');
    //     }
    //     callback();
    //   }
    // };
    // var validatePass2 = (rule, value, callback) => {
    //   if (value === '') {
    //     callback(new Error('Please input the password again'));
    //   } else if (value !== this.pass) {
    //     callback(new Error('Two inputs don\'t match!'));
    //   } else {
    //     callback();
    //   }
    // };
  },

  methods: {
    /**
     * Update the current user's profile.
     */
    async update () {
      // const passwordFields = Array.from(
      //   document.querySelectorAll('#inputProfilePassword, #inputProfileConfirmPassword')
      // )
      // // A little validation put in a small place.
      // if ((this.pwd || this.confirmPwd) && this.pwd !== this.confirmPwd) {
      //   each(passwordFields, el => $.addClass(el, 'error'))
      //   return
      // }

      // each(passwordFields, el => $.removeClass(el, 'error'))

      await userStore.updateProfile(this.pass)
      this.pass = ''
      this.checkPass = ''
    },

    validatePass(rule, value, callback) {
      // console.log(this.$refs.profileForm.pass.validateField('checkPass'));
      if (value === '') {
        callback(new Error('Please input the password'));
      } else {
        if (this.checkPass !== '') {
          this.$refs.state.current.validateField('checkPass');
          // this.$refs.ruleForm2.validateField('checkPass');
          // console.log('123');
        }
        callback();
      }
    },

    validatePass2(rule, value, callback) {
      if (value === '') {
        callback(new Error('Please input the password again'));
      } else if (value !== this.pass) {
        callback(new Error('Two inputs don\'t match!'));
      } else {
        callback();
      }
    }


  }
}
</script>

<style lang="scss">



</style>
