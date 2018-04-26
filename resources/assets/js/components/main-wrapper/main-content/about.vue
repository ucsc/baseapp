<template>
  <section id="homeWrapper">
    <h1 class="heading">
      <span>About</span>
    </h1>

    <div class="main-scroll-wrap" @scroll="scrolling" ref="wrapper">
      <div class="two-cols">
        About World
      </div>

    </div>
  </section>
</template>

<script>
import { sample } from 'lodash'

import { event } from '@/utils'
import { userStore } from '@/stores'
import infiniteScroll from '@/mixins/infinite-scroll'

export default {
  components: { },
  /**
   * Note: We're not really using infinite scrolling here,
   * but only the handy "Back to Top" button.
   */
  mixins: [infiniteScroll],

  data () {
    return {
      value1: '',
      state: userStore.state,
    }
  },

  computed: {
  }

}
</script>

<style lang="scss">



</style>
