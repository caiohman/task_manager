import { createApp } from 'vue'
import App from './App.vue'
import PrimeVue from 'primevue/config'
import Aura from '@primevue/themes/aura';
import pt from "./locales/pt.json" 
import en from "./locales/en.json" 
import { createI18n } from 'vue-i18n'
import router from './router.js'
import 'primeicons/primeicons.css'
import ConfirmationService from 'primevue/confirmationservice'
import Tooltip from 'primevue/tooltip';

const i18n = createI18n({ 
    legacy: false,
    locale: 'pt', 
    fallbackLocale: 'en', 
    messages: { pt, en }, 
})

const app = createApp(App).
use(PrimeVue, {
  theme: {
    preset: Aura
  }
}).
use(i18n).
use(router).
use(ConfirmationService)
.directive('tooltip', Tooltip)

router.isReady().then(() => {
  app.mount('#app')
})
