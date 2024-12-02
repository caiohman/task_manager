<template>
    <h1>{{ name }}</h1>
    <div >
        <DatePicker v-model="date" inline dateFormat="yy-mm-dd">
            <template #date="slotProps">
                <strong v-if="findDayOff(slotProps.date) === true" style="color: red">{{ slotProps.date.day }}</strong>
                <template v-else>{{ slotProps.date.day }}</template>
            </template>
        </DatePicker>
        <ConfirmDialog />
        <Toast />
    </div>
</template>

<script>
    import DatePicker from 'primevue/datepicker';
    import ConfirmDialog from 'primevue/confirmdialog';
    import Button from 'primevue/button';
    import { useI18n } from 'vue-i18n';
    import { useToast } from 'primevue/usetoast';

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
            const toast = useToast();

            return {
                t, toast
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
                .then(response => {
                    if(response.status === 400) {
                        this.toast.add({ severity: 'error', 
                            summary: this.t("general.errorMessage"), 
                            detail: this.t("userFirstPage.dateExists"), 
                            life: 3000 });
                    } else {
                        this.toast.add({ severity: 'success', 
                            summary: this.t("general.successMessage"), 
                            detail: this.t("userFirstPage.dateAdded"), 
                            life: 3000 });
                }  
                })
                .catch(error => this.getInsertDayOffError(error))    
            },

            getInsertDayOffError(error) {
                this.toast.add({ severity: 'error', 
                    summary: this.t("general.errorMessage"), 
                    detail: this.t("general.serverError"), 
                    life: 3000 });
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
