<template>
  <section id="homeWrapper">
    <h1 class="heading">
      <span>Hello</span>
    </h1>

    <el-date-picker
      v-model="value1"
      type="datetime"
      placeholder="Select date and time">
    </el-date-picker>

    <div class="main-scroll-wrap" @scroll="scrolling" ref="wrapper">
      <div class="two-cols">
        Hello World
      </div>

      

      

      <to-top-button/>
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
      value1: ''
    }
  },

  computed: {
  },

  methods: {
    /**
     * Refresh the dashboard with latest data.
     */
    refreshDashboard () {
      
    }
  },

  created () {
    event.on({
      'baseapp:ready': () => this.refreshDashboard()
    })
  }
}
</script>

<style lang="scss">
@import "../../../../sass/partials/_vars.scss";
@import "../../../../sass/partials/_mixins.scss";

#homeWrapper {
  .two-cols {
    display: flex;

    > section, > div {
      flex-grow: 1;
      flex-basis: 0;

      &:first-of-type {
        margin-right: 8px;
      }
    }
  }

  .none {
    color: $color2ndText;
    padding: 0;

    a {
      color: $colorHighlight;
    }
  }

  .recently-added {
    .song-item-home .details {
      background: rgba(255, 255, 255, .02);
    }

    .item {
      margin-bottom: 8px;
    }
  }

  .top-artists .wrapper, .top-albums .wrapper, .recently-added .wrapper {
    @include artist-album-wrapper();
  }

  .main-scroll-wrap {
    section {
      margin-bottom: 48px;
    }

    h1 {
      font-size: 1.4rem;
      margin: 0 0 1.8rem;
      font-weight: $fontWeight_UltraThin;
    }
  }

  @media only screen and (max-width: 768px) {
    .two-cols {
      display: block;

      > section, > div {
        &:first-of-type {
          margin-right: 0;
        }
      }
    }
  }
}
</style>
