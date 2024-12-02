import {defineStore} from 'pinia';
import { ref } from 'vue'

const loggedStore = defineStore('logged', () => {
    const logged = ref(false);
    const cpf = ref();
    const name = ref();
    
    function updateLogged(value) {
        logged.value = value;
    }

    function updateCpf(value) {
        cpf.value = value;
    }

    function updateName(value) {
        name.value = value;
    }

    return { logged, updateLogged, cpf, name, updateCpf, updateName }
  })


export default loggedStore  