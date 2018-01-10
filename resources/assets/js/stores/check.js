import { each, find, without } from 'lodash'
import md5 from 'blueimp-md5'
import Vue from 'vue'
import NProgress from 'nprogress'

import { http } from '@/services'


export const checkStore = {


  /**
   * Init the store.
   *
   * @param {Array.<Object>}  users     The users in the system. Empty array if current user is not an admin.
   * @param {Object}      currentUser The current user.
   */
  init () {
    return new Promise((resolve, reject) => {
      http.get('check', ({ data }) => {
        // resolve(data)
      }, error => reject(error))
    })

  }

}
