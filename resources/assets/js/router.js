import isMobile from 'ismobilejs'
import { each } from 'lodash'

import { loadMainView } from './utils'
import { userStore } from './stores'

export default {
  routes: {

    '/home' () {
      loadMainView('home')
    },

    '/about' () {
      userStore.current.email && loadMainView('about')
    },

    '/users' () {
      userStore.current.is_admin && loadMainView('users')
    },

    '/profile' () {
      userStore.current.email && loadMainView('profile')
    }

  },

  init () {
    this.loadState()
    window.addEventListener('popstate', () => this.loadState(), true)
  },

  loadState () {
    if (!window.location.hash) {
      return this.go('home')
    }

    each(Object.keys(this.routes), route => {
      const matches = window.location.hash.match(new RegExp(`^#!${route}$`))
      console.log(matches)
      if (matches) {
        const [, ...params] = matches
        this.routes[route](...params)
        return false
      }
    })
  },

  /**
   * Navigate to a (relative, hashed) path.
   *
   * @param  {String} path
   */
  go (path) {
    if (path[0] !== '/') {
      path = `/${path}`
    }

    if (path.indexOf('/#!') !== 0) {
      path = `/#!${path}`
    }

    path = path.substring(1, path.length)
    document.location.href = `${document.location.origin}${document.location.pathname}${path}`
  }
}
