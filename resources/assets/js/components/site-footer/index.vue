<template>
  <el-row :gutter="10">
    <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12">
      <!-- <a href="/" class="logo">UC Santa Cruz</a> -->
      <img class="logo" src="../../../img/ucsc-logo.svg"/>
      <div class="rights">
        ©2018 Regents of the University of California. <br />
        All Rights Reserved.
      </div>
    </el-col>
    <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12"><img src="../../../img/its.svg" /><img src="../../../img/cruzid-gold.svg"/></el-col>
  </el-row>


</template>

<script>
// import config from '@/config'
// import { event } from '@/utils'
// // import userBadge from './user-badge.vue'

export default {
  components: {},

  data () {
    return {
      // appTitle: config.appTitle
    }
  },

  methods: {}
}
</script>

<style lang="scss" scoped>

  .el-row {
    padding: 0 20px;
  }

  .el-col {
    padding: 20px;
    // margin: 0 20px;

  }

  .logo {
    // display: block;
    // text-indent: -9999px;
    float: left;
    width: 140px;
    height: 40px;
    // margin: 20px 10px 0 10px;
    // background-image: url(../../../img/ucsc-logo.svg);
    // background-size: 140px 40px;
  }

  footer img {
    float: right;
    height: 33px;
    padding: 0 5px;
  }

  .rights {
    float: left;
    padding: 6px 20px;
    text-align: left;
    font-size: 12px;
    color: #B3B3B3;
    line-height: 1.3;

  }


</style>