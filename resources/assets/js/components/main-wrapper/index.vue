<template>
  <div id="mainWrapper">
    <sidebar/>
    <main-content/>
  </div>
</template>

<script>
import sidebar from './sidebar/index.vue'
import mainContent from './main-content/index.vue'

export default {
  components: { sidebar, mainContent }
}
</script>

<style lang="scss">
@import "../../../sass/partials/_vars.scss";
@import "../../../sass/partials/_mixins.scss";

#mainWrapper {
  display: flex;
  flex: 1;
}
</style>
