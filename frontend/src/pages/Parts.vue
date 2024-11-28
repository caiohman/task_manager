<template>
    <div class="card">
        <DataTable :value="products" tableStyle="width: 50%">
            <Column field="code" :header= codeHeader ></Column>
            <Column field="name" :header= nameHeader ></Column>
            <Column :header= statusHeader >
                <template #body="slotProps">
                    <Tag :value="slotProps.data.status" :severity="getStatus(slotProps.data)" />
                </template>
            </Column>
            <Column field="atm" :header= atmHeader ></Column>
        </DataTable>
    </div>
</template>

<script>
import { ref } from 'vue'
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Tag from 'primevue/tag';
import { useI18n } from 'vue-i18n';

export default {
    name: 'Parts',
    components: {
        DataTable,
        Column,
        Tag

    },

    setup() {
        const products = ref([]);
        const { t } = useI18n();

        return {
            products, t
        }
    },

    data() {
        return {
            codeHeader: this.t("parts.codeHeader"),
            nameHeader: this.t("parts.nameHeader"),
            statusHeader: this.t("parts.statusHeader"),
            atmHeader: this.t("parts.atmHeader"),
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
