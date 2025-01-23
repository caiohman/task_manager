<template>
    <div class="profile-align">
        <img
            :src="image"
            style="width: 5%; height: 5%; border-radius: 50%; margin-right: 1%"
            class="page-margin-left"
        />
        <h3>{{ name }}</h3>
    </div>
    <div class="card-position">
        <DatePicker
            v-model="date"
            inline
            dateFormat="yy-mm-dd"
            style="margin: 2%; width: 30%"
        >
            <template #date="slotProps">
                <div v-tooltip.bottom="findCoworkers(slotProps.date)">
                    <strong
                        v-if="findDayOff(slotProps.date, dayOff) === true"
                        style="color: red"
                        >{{ slotProps.date.day }}</strong
                    >
                    <template v-else>{{ slotProps.date.day }}</template>
                </div>
            </template>
        </DatePicker>
        <ConfirmDialog />
        <Toast />
    </div>
</template>

<script>
import DatePicker from "primevue/datepicker";
import ConfirmDialog from "primevue/confirmdialog";
import Button from "primevue/button";
import { useI18n } from "vue-i18n";
import { useToast } from "primevue/usetoast";
import { ref } from "vue";

export default {
    name: "UserFirstPage",
    props: {
        cpf: { type: String, required: true },
        name: { type: String, required: true },
    },
    components: {
        DatePicker,
        ConfirmDialog,
        Button,
    },

    setup() {
        const { t } = useI18n();
        const toast = useToast();
        const coworkersName = ref([]);
        const techsDayOff = ref([]);

        return {
            t,
            toast,
            coworkersName,
            techsDayOff,
        };
    },

    data() {
        return {
            dayOff: [],
            date: null,
            image: this.name.includes("Caio")
                ? "./src/assets/profiles/caio.jpg"
                : "./src/assets/profiles/tecban.png",
        };
    },

    beforeMount() {
        this.getUserDayOff();
        this.getAlllUsersDayOff();
    },

    methods: {
        findDayOff(date, dayOff) {
            for (let i = 0; i < dayOff.length; i++) {
                if (this.validateDate(dayOff[i], date)) return true;
            }
            return false;
        },

        async getUserDayOff() {
            await fetch("http://localhost:8090/getdayoff", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ cpf: this.cpf }),
            })
                .then((response) => response.json())
                .then((json) => this.separateData(json))
                .catch((error) => this.getUserError(error));
        },

        getUserError(error) {
            console.log(error);
        },

        separateData(json) {
            json.forEach((element) => {
                const separated = element.day_off_date.match(/[^-T]+/g); //TODO: remove all after T
                const date = {
                    year: separated[0],
                    month: separated[1],
                    day: separated[2],
                };
                this.dayOff.push(date);
            });
        },

        async setUserDayOff(day, month, year) {
            await fetch("http://localhost:8090/setdayoff", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    day: day,
                    month: month,
                    year: year,
                    cpf: this.cpf,
                }),
            })
                .then((response) => {
                    if (response.status === 400) {
                        this.toast.add({
                            severity: "error",
                            summary: this.t("general.errorMessage"),
                            detail: this.t("userFirstPage.dateExists"),
                            life: 3000,
                        });
                    } else {
                        this.toast.add({
                            severity: "success",
                            summary: this.t("general.successMessage"),
                            detail: this.t("userFirstPage.dateAdded"),
                            life: 3000,
                        });
                    }
                })
                .catch((error) => this.getInsertDayOffError(error));
        },

        getInsertDayOffError(error) {
            this.toast.add({
                severity: "error",
                summary: this.t("general.errorMessage"),
                detail: this.t("general.serverError"),
                life: 3000,
            });
        },

        confirmAddDayOff(date) {
            const dateObject = new Date(date);
            this.$confirm.require({
                message: this.t("userFirstPage.questionConfirm"),
                header: this.t("userFirstPage.confirmHeader"),

                rejectProps: {
                    label: this.t("userFirstPage.cancel"),
                    severity: "secondary",
                    outlined: true,
                },
                acceptProps: {
                    label: this.t("userFirstPage.save"),
                },
                accept: () => {
                    this.setUserDayOff(
                        dateObject.getDate(),
                        dateObject.getMonth() + 1,
                        dateObject.getFullYear(),
                    );
                },
                reject: () => {
                    console.log("Rejected");
                },
            });
        },

        async getAlllUsersDayOff() {
            await fetch("http://localhost:8090/getalldayoff", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ cpf: this.cpf }),
            })
                .then((response) => response.json())
                .then((json) => this.checkWorkersDayOff(json))
                .catch((error) => this.getUserError(error));
        },

        checkWorkersDayOff(json) {
            json.forEach((element) => {
                const separated = element.day_off_date.match(/[^-T]+/g); //TODO: remove all after T
                const date = {
                    year: separated[0],
                    month: separated[1],
                    day: separated[2],
                };
                this.techsDayOff.push({ name: element.name, date: date });

                if (
                    this.coworkersName.filter(
                        (value) => value?.name === element.name,
                    ).length === 0
                ) {
                    this.coworkersName.push({ name: element.name });
                }
            });
        },

        validateDate(dayOff, date) {
            return (
                Number(dayOff.day) === date.day &&
                Number(dayOff.month) === date.month + 1 &&
                Number(dayOff.year) === date.year
            );
        },

        findCoworkers(day) {
            var text = "";
            this.coworkersName.forEach((coworker) => {
                var dayOffList = this.techsDayOff.filter(
                    (element) =>
                        this.validateDate(element.date, day) === true &&
                        element.name === coworker.name,
                );

                if (dayOffList.length === 0)
                    text = text + "- " + coworker.name + " \n";
            });

            return text;
        },
    },

    watch: {
        date(newDate, oldDate) {
            if (newDate != null) {
                this.confirmAddDayOff(newDate);
            }
        },
    },
};
</script>
<style>
.profile-align {
    display: flex;
    flex-direction: row;
    align-items: center;
}
</style>
