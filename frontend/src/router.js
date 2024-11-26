import { createMemoryHistory, createRouter } from 'vue-router'
import LoginPage from './pages/LoginPage.vue'
import UserFirstPage from './pages/UserFirstPage.vue'
import HomePage from './pages/HomePage.vue'
import Parts from './pages/Parts.vue'


const routes = [
    {
        path: '/',  
        component: HomePage
    },
    { 
        path: '/login',  
        component: LoginPage 
    },
    { 
        path: '/user/:cpf:name',
        name: 'user', 
        component: UserFirstPage,
        props: true
    },
    {
        path: '/parts/',
        name: 'parts', 
        component: Parts,
        props: true
    }
]

const router = createRouter({
    history: createMemoryHistory(),
    routes,
})
  
export default router