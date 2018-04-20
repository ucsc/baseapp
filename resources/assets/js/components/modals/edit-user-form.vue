<template>
  <!-- <div class="overlay" v-if="copiedUser">
    <load-bar v-if="loading"/>
    <form class="user-edit" @submit.prevent="submit" v-else>
      <header>
        <h1>Edit User</h1>
      </header>

      <div>
        <div class="form-row">
          <label>Name</label>
          <input type="text" name="name" v-model="copiedUser.name" required v-baseapp-focus>
        </div>
        <div class="form-row">
          <label>Email</label>
          <input type="email" name="email" v-model="copiedUser.email" required>
        </div>
        <div class="form-row">
          <label>Password</label>
          <input type="password" name="password" v-model="copiedUser.password" placeholder="Leave blank for no changes">
        </div>
      </div>

      <footer>
        <button class="btn btn-green btn-update">Update</button>
        <button class="btn btn-white btn-cancel" @click.prevent="cancel">Cancel</button>
      </footer>
    </form>
  </div> -->

  <el-dialog :title="'Edit user: ' + user.name" :visible.sync="editUserFormVisible">
  <el-form :model="copiedUser" status-icon>
    <el-form-item label="Name" prop="name" :label-width="formLabelWidth" :rules="[
      { required: true, message: 'Please input a username', trigger: 'blur,change'}
    ]">
      <el-input v-model="copiedUser.name" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="Email" :label-width="formLabelWidth" prop="email" :rules="[
      { required: true, message: 'Please input email address', trigger: 'blur,change' },
      { type: 'email', message: 'Please input correct email address', trigger: 'blur,change' }
    ]">
      <el-input v-model="copiedUser.email" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="Password" :label-width="formLabelWidth">
      <el-input v-model="copiedUser.password" auto-complete="off" placeholder="Leave blank for no changes" type="password"></el-input>
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
  name: 'modals--edit-user-form',
  components: { loadBar },

  data () {
    return {
      user: {},
      loading: false,
      // We work on a cloned version of the user
      copiedUser: {},
      editUserFormVisible: false,
      formLabelWidth: '120px'
    }
  },

  methods: {
    open (user) {
      this.copiedUser = clone(user)
      // Keep a reference
      this.user = user
      // Open dialog
      this.editUserFormVisible = true
    },

    async submit () {
      this.loading = true
      await userStore.update(this.user, this.copiedUser.name, this.copiedUser.email, this.copiedUser.password)
      this.loading = false
      this.copiedUser = {}
      // this.$notify({
      //     title: 'Success',
      //     message: 'User updated',
      //     type: 'success'
      //   })
      // Close dialog
      this.editUserFormVisible = false
    },

    cancel () {
      this.copiedUser = {}
      // Close dialog
      this.editUserFormVisible = false
    }
  }
}
</script>
