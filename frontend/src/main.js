import { createApp } from 'vue';
import App from './App.vue';
import PrimeVue from 'primevue/config';
import Aura from '@primevue/themes/aura';
import pt from "./locales/pt.json"; 
import en from "./locales/en.json"; 
import { createI18n } from 'vue-i18n';
import router from './router.js';
import 'primeicons/primeicons.css';
import ConfirmationService from 'primevue/confirmationservice'
import Tooltip from 'primevue/tooltip';
import './assets/css/main.css';
import Card from 'primevue/card';
import Column from 'primevue/column';
import DataTable from 'primevue/datatable';
import Timeline from 'primevue/timeline';
import ToastService from 'primevue/toastservice';
import Toast from 'primevue/toast';

const i18n = createI18n({ 
    legacy: false,
    locale: 'pt', 
    fallbackLocale: 'en', 
    messages: { pt, en }, 
})

const app = createApp(App).
use(PrimeVue, {
  theme: {
    preset: Aura,
    options: {
      cssLayer: {
          name: 'primevue',
          order: 'tailwind-base, primevue, tailwind-utilities'
      }
  }
  }
}).
use(i18n).
use(router).
use(ConfirmationService).
use(ToastService).
directive('tooltip', Tooltip).
component('Card', Card).
component('Column', Column).
component('DataTable', DataTable).
component('Timeline', Timeline).
component('Toast', Toast)

router.isReady().then(() => {
  app.mount('#app')
})
