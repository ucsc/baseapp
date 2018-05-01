<template>
  <el-container>

  </el-container>
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
