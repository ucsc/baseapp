// import alertify from 'alertify.js'
import { Notification } from 'element-ui'

const alerts = {
  alert (msg) {
    // alertify.alert(msg)
    Notification({
      title: 'Prompt',
      message: msg
    })
  },

  // confirm (msg, okFunc, cancelFunc = null) {
  //   alertify.confirm(msg, okFunc, cancelFunc)
  // },

  log (msg, type, cb = null) {
    // alertify.logPosition('top right')
    // alertify.closeLogOnClick(true)
    switch (type) {
      case 'success':
        // alertify.success(msg, cb)
        Notification.success({
          title: 'Success',
          message: msg,
          showClose: true
        })
        break
      case 'error':
        // alertify.error(msg, cb)
        Notification.error({
          title: 'Error',
          message: msg,
          showClose: true
        })
        break
      case 'warning':
        Notification.warning({
          title: 'Error',
          message: msg,
          showClose: true
        })
        break
      case 'info':
        Notification.info({
          title: 'Error',
          message: msg,
          showClose: true
        })
        break
      default:
        // alertify.log(msg, cb)
        console.log(msg)
        break
    }
  },

  success (msg, cb = null) {
    return this.log(msg, 'success', cb)
  },

  error (msg, cb = null) {
    return this.log(msg, 'error', cb)
  },

  warning (msg, cb = null) {
    return this.log(msg, 'warning', cb)
  },

  info (msg, cb = null) {
    return this.log(msg, 'info', cb)
  },
}

export { alerts }
