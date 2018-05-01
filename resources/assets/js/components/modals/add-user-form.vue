<template>
<!--   <div class="overlay" v-if="newUser">
    <load-bar v-if="loading"/>
    <form class="user-add" @submit.prevent="submit" v-else>
      <header>
        <h1>Add New User</h1>
      </header>

      <div>
        <div class="form-row">
          <label>Name</label>
          <input type="text" name="name" v-model="newUser.name" required v-baseapp-focus>
        </div>
        <div class="form-row">
          <label>Email</label>
          <input type="email" name="email" v-model="newUser.email" required>
        </div>
        <div class="form-row">
          <label>Password</label>
          <input type="password" name="password" v-model="newUser.password">
        </div>
      </div>

      <footer>
        <button class="btn btn-green btn-add">Save</button>
        <button class="btn btn-white btn-cancel" @click.prevent="cancel">Cancel</button>
      </footer>
    </form>
  </div> -->
<el-dialog :title="'Create new user ' + newUser.name" :visible.sync="addUserFormVisible">
  <el-form :model="newUser" status-icon>
    <el-form-item label="Name" prop="name" :rules="[
      { required: true, message: 'Please input a username', trigger: 'blur,change'}
    ]">
      <el-input v-model="newUser.name" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="Email" prop="email" :rules="[
      { required: true, message: 'Please input email address', trigger: 'blur,change' },
      { type: 'email', message: 'Please input correct email address', trigger: 'blur,change' }
    ]">
      <el-input v-model="newUser.email" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="Password" prop="password" :rules="[
      { required: true, message: 'Please input a password', trigger: 'blur,change' }
    ]">
      <el-input v-model="newUser.password" auto-complete="off" type="password"></el-input>
    </el-form-item>
  </el-form>
  <span slot="footer" class="dialog-footer">
    <el-button @click.prevent="cancel">Cancel</el-button>
    <el-button type="primary" @click.prevent="submit">Confirm</el-button>
  </span>
</el-dialog>

</template>

<script>
import { clone } from 'lodash'
import loadBar from '../shared/load-bar.vue'
import { userStore } from '@/stores'

export default {
  name: 'modals--add-user-form',
  components: { loadBar },

  data () {
    return {
      loading: false,
      newUser: {},
      addUserFormVisible: false
    }
  },

  methods: {
    open () {
      this.newUser = clone(userStore.stub)
      // Open dialog
      this.addUserFormVisible = true
    },

    async submit () {
      this.loading = true
      await userStore.store(this.newUser.name, this.newUser.email, this.newUser.password)
      this.loading = false
      this.newUser = {}
      // Close dialog
      this.addUserFormVisible = false
    },

    cancel () {
      this.newUser = {}
      // Close dialog
      this.addUserFormVisible = false
    }
  }
}
</script>
