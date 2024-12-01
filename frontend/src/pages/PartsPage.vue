<template>
    <h2>{{ parts }}</h2>
    <div class="card-position">
        <Card style="background-color:darkgray; width: 80%;">
            <template #content>
                <DataTable :value="products" paginator :rows="5">
                    <Column field="code" :header= codeHeader />
                    <Column field="name" :header= nameHeader />
                    <Column :header= statusHeader >
                        <template #body="slotProps">
                            <Tag :value="slotProps.data.status" :severity="getStatus(slotProps.data)" />
                        </template>
                    </Column>
                    <Column field="atm" :header= atmHeader />
                </DataTable>
            </template>
        </Card>
    </div>
    
</template>

<script>
import { ref } from 'vue'
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Tag from 'primevue/tag';
import { useI18n } from 'vue-i18n';
import Card from 'primevue/card';

export default {
    name: 'PartsPage',
    components: {
        DataTable,
        Column,
        Tag,
        Card

    },

    setup() {
        const products = ref([]);
        const { t } = useI18n();

        return {
            products, t
        };
    },

    data() {
        return {
            codeHeader: this.t("parts.codeHeader"),
            nameHeader: this.t("general.name"),
            statusHeader: this.t("general.status"),
            atmHeader: this.t("general.atm"),
            parts: this.t("parts.parts"),
            allDataParts: null
        }
    },

    beforeMount() {
        this.getPartsList()
    },

    methods: {
        async getPartsList() {
            await fetch("http://localhost:8090/listparts", {
                method: "GET",
                headers: {"Content-Type": "application/json"}, 
            })
            .then(response => response.json())
            .then(json => this.fillTable(json))
            .catch(error => this.getUserError(error))    
        },

        getUserError(error) {
          console.log(error)
        },

        fillTable(json) {
            this.allDataParts = json
            var taskId = 0

            for(let part of this.allDataParts) {
                if( taskId === part.taskid) continue
                else {
                    this.products.push(part)
                    taskId = part.taskid
                }    
            }
        },

        getStatus(product) {
            if(product.status === 'returned') return 'secondary'
            else {
                for(let part of this.allDataParts) {
                    if(product.taskid === part.taskid && part.status === 'delivered') {
                        let date = part.date.split("T")
                        let dateProductRequest = new Date(date[0]).getTime()
                        let dateToday = new Date(Date.now()).getTime()
                        const daysLate = (dateToday - dateProductRequest) / (1000 * 3600 * 24)

                        return (daysLate > 4) ? 'danger' : 'success'
                    }
                }
                return 'warn'     
            }
        }
    }
}
</script>
<style>
.card-position {
    display: flex;
    justify-content: center;
}
</style>
