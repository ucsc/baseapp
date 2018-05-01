import './static-loader'
import Vue from 'vue'
import axios from 'axios'
import ElementUI from 'element-ui'
import locale from 'element-ui/lib/locale/lang/en'
import App from './app.vue'
import { event } from './utils'
import { http } from './services'
import { VirtualScroller } from 'vue-virtual-scroller/dist/vue-virtual-scroller'
Vue.component('virtual-scroller', VirtualScroller)
Vue.use(ElementUI, { locale })

axios.defaults.headers.common['X-CSRF-TOKEN'] = Laravel.csrfToken;
// Vue.http.headers.common['Access-Control-Allow-Origin'] = true;
// Vue.http.headers.common['Access-Control-Allow-Origin'] = '*';


var holder = new Vue({
    methods: {
        foo: function() {
        	axios.get('/api/check').then(response => {
				console.log(response.data)
				if(response.data.token) {
					window.localStorage.setItem('jwt-token',  JSON.stringify(response.data.token))
					// console.log(response.data.token)
					event.emit('user:loggedin')
				} else {
					// console.log('else')
				}
			}).catch(error => {
				// console.log('no')
			})
        }
    }
})

holder.foo()

new Vue({
  el: '#app',
  render: h => h(App),
  created () {
    event.init()
    http.init()
  }
})