<template>
  <div class="overlay" v-if="newUser">
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
  </div>
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
      newUser: null
    }
  },

  methods: {
    open () {
      this.newUser = clone(userStore.stub)
    },

    async submit () {
      this.loading = true
      await userStore.store(this.newUser.name, this.newUser.email, this.newUser.password)
      this.loading = false
      this.newUser = null
    },

    cancel () {
      this.newUser = null
    }
  }
}
</script>
