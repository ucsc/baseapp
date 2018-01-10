import { assign } from 'lodash'

import { http } from '../services'
import { userStore } from '.'

export const sharedStore = {
  state: {
    users: [],
    currentUser: null,
    currentVersion: '',
    latestVersion: ''
  },

  init () {
    return new Promise((resolve, reject) => {
      http.get('data', ({ data }) => {
        assign(this.state, data)

        userStore.init(this.state.users, this.state.currentUser)

        resolve(this.state)
      }, error => reject(error))
    })
  }
}
