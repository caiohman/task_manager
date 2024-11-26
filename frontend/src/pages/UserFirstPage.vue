<template>
    <h1>{{ name }}</h1>
    <div class="card flex justify-center">
        <DatePicker v-model="date" inline class="w-full sm:w-[30rem]" dateFormat="yy-mm-dd">
            <template #date="slotProps">
                <strong v-if="findDayOff(slotProps.date) === true" style="color: red">{{ slotProps.date.day }}</strong>
                <template v-else>{{ slotProps.date.day }}</template>
            </template>
        </DatePicker>
        <ConfirmDialog />
    </div>
</template>

<script>
import { ref } from "vue"
import DatePicker from 'primevue/datepicker'
import ConfirmDialog from 'primevue/confirmdialog'
import Button from 'primevue/button'
import { useI18n } from 'vue-i18n'

export default {
    name: 'UserFirstPage',
    props: {
        cpf: { type: String , required: true },
        name: { type: String , required: true }
    },
    components: {
        DatePicker,
        ConfirmDialog,
        Button
    },

    setup() {
        const { t } = useI18n(); 
        return {
            t
        } 
    },

    data() {
        return {
            dayOff: [],
            date : null
        }
    },

    beforeMount() {
        this.getUserDayOff()
    },

    methods: {
        findDayOff(date) {
            for(let i = 0; i < this.dayOff.length; i++) {
                if(Number(this.dayOff[i].day) === date.day &&
                    Number(this.dayOff[i].month) === (date.month + 1) &&
                    Number(this.dayOff[i].year) === date.year
                 ) return true   
            }
             return false
        },

        async getUserDayOff() {  
          await fetch("http://localhost:8090/getdayoff", {
            method: "POST",
            headers: {"Content-Type": "application/json",}, 
            body: JSON.stringify({ cpf: this.cpf}),
          })
          .then(response => response.json())
          .then(json => this.separateData(json))
          .catch(error => this.getUserError(error))    
        },
  
        getUserError(error) {
          console.log(error);
        },

        separateData(json) {
            json.forEach(element => {
                const separated = element.day_off_date.match(/[^-T]+/g) //TODO: remove all after T
                const date = {year: separated[0] , month: separated[1], day: separated[2]}
                this.dayOff.push(date)
            });
        },

        async setUserDayOff(day, month, year) {  
          await fetch("http://localhost:8090/setdayoff", {
            method: "POST",
            headers: {"Content-Type": "application/json",}, 
            body: JSON.stringify({ day: day, month: month, year: year, cpf: this.cpf}),
          })
          .then(response => response.json())
          .then(json => console.log(json))
          .catch(error => this.getUserError(error))    
        },

        confirmAddDayOff(date) {
            const dateObject = new Date(date)
            this.$confirm.require({
                message: this.t("userFirstPage.questionConfirm"),
                header: this.t("userFirstPage.confirmHeader"),
                
                rejectProps: {
                    label: this.t("userFirstPage.cancel"),
                    severity: 'secondary',
                    outlined: true
                },
                acceptProps: {
                    label: this.t("userFirstPage.save")
                },
                accept: () => {
                    this.setUserDayOff(dateObject.getDate(), dateObject.getMonth() + 1, dateObject.getFullYear())
                },
                reject: () => {
                    console.log('Rejected')
                }
            });
        },
    },

    watch: {
        date(newDate, oldDate) {
            if(newDate != null) {
                this.confirmAddDayOff(newDate)
            }
        }
    }

}

</script>
