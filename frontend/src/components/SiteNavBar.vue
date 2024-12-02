<template>
    <Toolbar>
        <template #start>
            <template v-if="isLogged.logged">
              <RouterLink :to="{ name: 'user', params: { cpf: isLogged.cpf , name: isLogged.name }}">
                <Button v-tooltip.bottom="login" icon="pi pi-user" class="mr-2" severity="secondary" text />
              </RouterLink>
              <RouterLink to="/parts">
                <Button v-tooltip.bottom="parts" icon="pi pi-wrench" class="mr-2" severity="secondary" text />
              </RouterLink>
              <RouterLink to="/tasks">
                <Button v-tooltip.bottom="tasks" icon="pi pi-briefcase" class="mr-2" severity="secondary" text />
              </RouterLink>
            </template>
            <template v-else>
              <RouterLink to="/login">
                <Button v-tooltip.bottom="login" icon="pi pi-user" class="mr-2" severity="secondary" text />
              </RouterLink>
            </template>
        </template>
        <template #end> 
            <Select v-model="selectedLanguage" :options="languages" optionLabel="name" :placeholder="language" @change="changeLocale"/>
        </template>
    </Toolbar>    
</template>
    
  <script>
    import { ref } from 'vue'
    import Toolbar from 'primevue/toolbar';
    import { useI18n } from 'vue-i18n';
    import Button from 'primevue/button';
    import Select from 'primevue/select';
    import loggedStore from '../stores/LoggedStore';

  
    export default {
      name: 'SiteNavBar',
      components: {
        Toolbar,
        Select,
        Button
      }, 
    
      setup() {

        const { t } = useI18n();

        const languages = ref([
            {
                name: 'Brasil',
            },
            {
                name: 'USA',
            }
        ]);

        const selectedLanguage = ref();

        const isLogged = loggedStore();

        return {
          languages, selectedLanguage, t, isLogged
        };
      },

      data() {
        return {
          login: this.t("login.login"),
          parts: this.t("parts.parts"),
          tasks: this.t("tasks.tasks")
        }

      },

      computed: {
        language() {
            return this.t("navbar.country");
        }
      },

      methods: {
        changeLocale() {
            console.log(this.selectedLanguage)
            if(this.selectedLanguage.name === 'Brasil') {
                console.log('Brasil');
                this.$i18n.locale = 'pt';  
                return;
            }
            if(this.selectedLanguage.name === 'USA') {
                console.log('USA');
                this.$i18n.locale = 'en';  
                return;
            }
        }
      }

    }
  </script>
  <style>
  </style>
