<template>
  <SiteNavBar />
  <RouterView />
</template>

<script>
import SiteNavBar from './components/SiteNavBar.vue';

export default {
    name: 'App',
    components: {
      SiteNavBar
    },

  }

</script>

<style>
</style>
