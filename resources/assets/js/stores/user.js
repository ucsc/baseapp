import { each, find, without } from 'lodash'
import md5 from 'blueimp-md5'
import Vue from 'vue'
import NProgress from 'nprogress'
// import axios from 'axios'
// import jsonp from 'jsonp'

import { http } from '@/services'
import { alerts } from '@/utils'
import stub from '@/stubs/user'

export const userStore = {
  stub,

  state: {
    users: [],
    current: stub
  },

  /**
   * Init the store.
   *
   * @param {Array.<Object>}  users     The users in the system. Empty array if current user is not an admin.
   * @param {Object}      currentUser The current user.
   */
  init (users, currentUser) {
    this.all = users
    this.current = currentUser

    // Set the avatar for each of the users…
    each(this.all, this.setAvatar)

    // …and the current user as well.
    this.setAvatar()
  },

  /**
   * All users.
   *
   * @return {Array.<Object>}
   */
  get all () {
    return this.state.users
  },

  /**
   * Set all users.
   *
   * @param  {Array.<Object>} value
   */
  set all (value) {
    this.state.users = value
  },

  /**
   * Get a user by his ID
   *
   * @param  {Integer} id
   *
   * @return {Object}
   */
  byId (id) {
    return find(this.all, { id })
  },

  /**
   * The current user.
   *
   * @return {Object}
   */
  get current () {
    return this.state.current
  },

  /**
   * Set the current user.
   *
   * @param  {Object} user
   *
   * @return {Object}
   */
  set current (user) {
    this.state.current = user
    return this.state.current
  },

  /**
   * Set a user's avatar using Gravatar's service.
   *
   * @param {?Object} user The user. If null, the current user.
   */
  setAvatar (user = null) {
    if (!user) {
      user = this.current
    }

    // http.get(`https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`, ({ data }) => {
    //     resolve(data)
    //     if (data.jpegphoto) {
    //       Vue.set(user, 'avatar', `${user.name}`)
    //     } else {
    //       Vue.set(user, 'avatar', '/img/UC_Seal.png')
    //     }
    //   }, error => reject(error));

    // axios.defaults.headers.common['X-CSRF-TOKEN'] = '*';
// Vue.http.headers.common['Access-Control-Allow-Origin'] = true;
// Vue.http.headers.common['Access-Control-Allow-Origin'] = '*';

    // axios.get(`https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`).then(response => {
    //     console.log(response.data)
    //     if(response.data.jpegphoto) {
    //       // window.localStorage.setItem('jwt-token',  JSON.stringify(response.data.token))
    //       // console.log(response.data.token)
    //       // event.emit('user:loggedin')
    //     } else {
    //       // console.log('else')
    //     }
    //   }).catch(error => {
    //     // console.log('no')
    //   });

    // $http.jsonp(`https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`).then(response => {
    // // get body data
    // console.log(response.body)
    // }, response => { });

    // import jsonp from 'jsonp'

// const jsonp = require('jsonp');

// jsonp(`https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`, null, (err, data) => {
//   if (err) {
//     console.error(err.message);
//   } else {
//     console.log(data);
//   }
// });


      // new Promise((resolve, reject) => {
      //   http.jsonp(`https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`, ({ data }) => {
      //     resolve(data)
      //   }, error => reject(error))
      // });

//       this.$http.jsonp('https://front.tpondemand.com/api/v1/UserStories?token=xxxxxxxxxxxxxxxxxxxxx&format=json')
// .then(response => {
// console.log(response)
// })

    //Vue.set(user, 'avatar', `https://www.gravatar.com/avatar/${md5(user.email)}?s=256&d=404`)
    // https://campusdirectory.ucsc.edu/photo.php?type=people&uid=jrosczyk
    // Vue.set(user, 'avatar', `https://campusdirectory.ucsc.edu/photo.php?type=people&uid=${user.name}`)
  },

  /**
   * Log a user in.
   *
   * @param  {String}   email
   * @param  {String}   password
   */
  login (email, password) {
    NProgress.start()

    return new Promise((resolve, reject) => {
      http.post('me', { email, password }, ({ data }) => {
        resolve(data)
      }, error => reject(error))
    })
  },

  /**
   * Log the current user out.
   */
  logout () {
    return new Promise((resolve, reject) => {
      http.delete('me', {}, ({ data }) => {
        resolve(data)
      }, error => reject(error))
    })
  },

  /**
   * Get the current user's profile.
   */
  getProfile () {
    return new Promise((resolve, reject) => {
      http.get('me', ({ data }) => {
        resolve(data)
      }, error => reject(error))
    })
  },

  /**
   * Update the current user's profile.
   *
   * @param  {string} password Can be an empty string if the user is not changing his password.
   */
  updateProfile (password) {
    NProgress.start()

    return new Promise((resolve, reject) => {
      http.put('me', {
        password,
        name: this.current.name,
        email: this.current.email
      }, () => {
        this.setAvatar()
        alerts.success('Profile updated.')
        resolve(this.current)
      },
      error => reject(error))
    })
  },

  /**
   * Stores a new user into the database.
   *
   * @param  {string}   name
   * @param  {string}   email
   * @param  {string}   password
   */
  store (name, email, password) {
    NProgress.start()

    return new Promise((resolve, reject) => {
      http.post('user', { name, email, password }, ({ data: user }) => {
        this.setAvatar(user)
        this.all.unshift(user)
        alerts.success(`New user "${name}" created.`)
        resolve(user)
      }, error => reject(error))
    })
  },

  /**
   * Update a user's profile.
   *
   * @param  {Object}   user
   * @param  {String}   name
   * @param  {String}   email
   * @param  {String}   password
   */
  update (user, name, email, password) {
    NProgress.start()

    return new Promise((resolve, reject) => {
      http.put(`user/${user.id}`, { name, email, password }, () => {
        this.setAvatar(user);
        [user.name, user.email, user.password] = [name, email, '']
        alerts.success('User profile updated.')
        resolve(user)
      }, error => reject(error))
    })
  },

  /**
   * Delete a user.
   *
   * @param  {Object}   user
   */
  destroy (user) {
    NProgress.start()

    return new Promise((resolve, reject) => {
      http.delete(`user/${user.id}`, {}, ({ data }) => {
        this.all = without(this.all, user)
        // alerts.success(`User &quot;${user.name}&quot; deleted.`)

        resolve(data)
      }, error => reject(error))
    })
  }
}
