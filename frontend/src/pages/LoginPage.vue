<template>
    <div class="screen-size screen-item-position">
      <Card class="card-position card-dimension" style="background-color:darkgray">
        <template #header>
          <div class="logo-position">
            <!-- <img alt="company name" :src="cardImage" class="logo"  /> -->
          </div>
        </template>
        <template #title>{{ t("login.login") }}</template>
        <template #content >
          <br />
          <FloatLabel>
            <InputText id="username" v-model="usernameValue" />
            <label for="username">{{ t("login.username") }}</label>
          </FloatLabel> 
          <br/>
          <br/>
          <FloatLabel>
            <Password v-model="passwordValue" inputId="password" :feedback="false"/>
            <label for="password">{{ t("login.password") }}</label>
            <small v-show="userPasswordWrong"  style="color: red">{{  t("login.wrongCredentials") }}</small>
          </FloatLabel>
        </template>
        <template #footer>
            <div class="footer-itens-position">
              <Button severity="secondary" outlined class="w-full" @click="validaterUserBackend" > {{ t("login.login") }} </Button>
              <Button class="w-full" > {{ t("login.register") }} </Button>
            </div>
        </template>
      </Card>
    </div>
  </template>
    
  <script>
    import Button from 'primevue/button';
    import Card from 'primevue/card';
    import InputText from 'primevue/inputtext';
    import FloatLabel from 'primevue/floatlabel';
    //import logo from '@/assets/logo-site.png';
    import Password from 'primevue/password';
    import { useI18n } from 'vue-i18n';
    import { ref } from 'vue';
  
    export default {
      name: 'LoginScreen',
      components: {
        Button,
        Card,
        InputText,
        FloatLabel,
        Password
      },
    
      setup() {
        
        const { t } = useI18n(); 
  
        const usernameValue = ref();
        const  passwordValue  = ref();
  
        return {
          t, usernameValue, passwordValue
        };
      },
  
      data() {
          return {
            //cardImage : logo,
            userData: null,
            userPasswordWrong : false
          }
      },
  
      methods: {
        async validaterUserBackend() {
          this.userPasswordWrong = false
          await fetch("http://localhost:8090/login", {
            method: "POST",
            headers: {"Content-Type": "application/json",},
            body: JSON.stringify({ username:this.usernameValue, password:this.passwordValue }), 
          })
         .then(response => response.json())
         .then(json => this.getUserInformations(json))
         .catch(error => this.getUserError(error))    
        },
  
        getUserInformations(json) {
          if (json.length !== 0) {
            this.userData = json[0]
            this.$router.push({
              name: 'user',
              params: { cpf: this.userData.cpf, name: this.userData.tech_name }
            })
          } else {
            this.userPasswordWrong = true
          } 
        },
  
        getUserError(error) {
          console.log(error)
        }
      }
      
    }
  </script>
  <style>
  .screen-size {
    width: 100%;
    min-height:100vh;
    height:100vh; 
    max-height:100vh;
  }
  .screen-item-position {
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .card-position {
    display: flex;
    justify-content: center; 
  }
  .card-dimension {
    width: 50%;
    height: 50%;
  }
  .logo {
    width: 30%;
    height: 40%;
  }
  .footer-itens-position {
    display: flex;
    justify-content: space-between;
  }
  .logo-position {
    display: flex;
    justify-content: flex-end;
  }
  
  </style>