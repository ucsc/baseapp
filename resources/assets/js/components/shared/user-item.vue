<template>
<!--   <article class="user-item" :class="{ me: isCurrentUser }">
    <div class="info">
      <img :src="user.avatar" width="128" height="128">

      <div class="right">
        <div>
          <h1>{{ user.name }}
            <i v-if="isCurrentUser" class="you fa fa-check-circle"/>
          </h1>
          <p>{{ user.email }}</p>
        </div>

        <div class="buttons">
          <button class="btn btn-blue btn-edit" @click="edit">
            {{ isCurrentUser ? 'Update Profile' : 'Edit' }}
          </button> -->
          <!-- <button v-if="!isCurrentUser" class="btn btn-red btn-delete" @click="del">Delete</button> -->

<!--           <el-button v-if="!isCurrentUser" type="primary" @click="del">Delete</el-button>
        </div>
      </div>
    </div>
  </article> -->


    <el-card :body-style="{ padding: '0px' }" :class="{ me: isCurrentUser }">
      <img :src="user.avatar" class="image">
      <div style="padding: 14px;">
        <h2>{{ user.name }} <i v-if="isCurrentUser" class="you fa fa-check-circle"/></h2>
        <p>{{ user.email }}</p>
        <div class="bottom clearfix">
          <el-button type="text" class="button" @click="edit">{{ isCurrentUser ? 'Update Profile' : 'Edit' }}</el-button>
          <el-button type="text" class="button" @click="del">Delete</el-button>
        </div>
      </div>
    </el-card>


</template>

<script>
import { userStore } from '@/stores'
import router from '@/router'
import { alerts } from '@/utils'

export default {
  props: {
    user: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      confirmingDelete: false
    }
  },

  computed: {
    /**
     * Determine if the current logged in user is the user bound to this component.
     *
     * @return {Boolean}
     */
    isCurrentUser () {
      return this.user.id === userStore.current.id
    }
  },

  methods: {
    /**
     * Trigger editing a user.
     * If the user is the current logged-in user, redirect to the profile screen instead.
     */
    edit () {
      this.isCurrentUser ? router.go('profile') : this.$emit('editUser', this.user)
    },

    /**
     * Delete user.
     */
    // del () {
    //   alerts.confirm(`You’re about to unperson ${this.user.name}. Are you sure?`, async () => {
    //     userStore.destroy(this.user)
    //     this.$destroy()
    //   })
    // },

    del() {
        this.$confirm(`You’re about to unperson ${this.user.name}. Are you sure?`, 'Warning', {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          userStore.destroy(this.user);
          this.$notify({
            title: 'Success',
            message: 'User "' + this.user.name + '" deleted.',
            type: 'success'
          });
        }).catch(() => {
          this.$notify.info({
            title: 'Info',
            message: 'Delete canceled'
          });        
        });
      }
  }
}
</script>

<style lang="scss">
// @import "../../../sass/partials/_vars.scss";
// @import "../../../sass/partials/_mixins.scss";
</style>
