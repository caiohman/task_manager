import {defineStore} from 'pinia';
import { ref } from 'vue'

const loggedStore = defineStore('logged', () => {
    const logged = ref(false);
    
    function updateLogged(value) {
        logged.value = value;
    }
  
    return { logged, updateLogged }
  })


export default loggedStore  