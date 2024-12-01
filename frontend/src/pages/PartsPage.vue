<template>
    <h2>{{ parts }}</h2>
    <div class="card-position">
        <Card style="background-color:darkgray; width: 80%;">
            <template #content>
                <DataTable v-model:expandedRows="expandedRows" :value="products" paginator :rows="5" dataKey="id" 
                        @rowExpand="onRowExpand" @rowCollapse="onRowCollapse">
                    <Column expander style="width: 5rem"/>    
                    <Column field="code" :header= codeHeader />
                    <Column field="name" :header= nameHeader />
                    <Column :header= statusHeader >
                        <template #body="slotProps">
                            <Tag :value="slotProps.data.status" :severity="getStatus(slotProps.data)" />
                        </template>
                    </Column>
                    <Column field="atm" :header= atmHeader />
                    <template #expansion="slotProps">
                        <div class="card-position">
                            <div class="timeline-position">
                                <Timeline :value="history" layout="horizontal" align="top">
                                    <template #opposite="slotProps">
                                        <small>{{slotProps.item.status}}</small>
                                    </template>
                                    <template #content="slotProps">
                                        <small>{{ '' + slotProps.item.date }}</small><br>
                                        <small>{{ '' + slotProps.item.time }}</small>
                                    </template>
                                </Timeline>
                            </div>
                        </div>
                    </template>
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
    import Timeline from 'primevue/timeline';

    export default {
        name: 'PartsPage',
        components: {
            DataTable,
            Column,
            Tag,
            Card,
            Timeline
        },

        setup() {
            const products = ref([]);
            const { t } = useI18n();
            const expandedRows = ref({});
            const history = ref([])

            return {
                products, t, expandedRows, history
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
            this.getPartsList();
        },

        methods: {
            async getPartsList() {
                await fetch("http://localhost:8090/listparts", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.fillTable(json))
                .catch(error => this.getUserError(error))    
            },

            getUserError(error) {
            console.log(error);
            },

            fillTable(json) {
                this.allDataParts = json;
                var partId = 0;

                for(let part of this.allDataParts) {
                    if( partId === part.id) continue;
                    else {
                        this.products.push(part);
                        partId = part.id;
                    }    
                }
            },

            getStatus(product) {
                if(product.status === 'returned') return 'secondary';
                else {
                    for(let part of this.allDataParts) {
                        if(product.taskid === part.taskid && part.status === 'delivered') {
                            let date = part.date.split("T");
                            let dateProductRequest = new Date(date[0]).getTime();
                            let dateToday = new Date(Date.now()).getTime();
                            const daysLate = (dateToday - dateProductRequest) / (1000 * 3600 * 24);

                            return (daysLate > 4) ? 'danger' : 'success';
                        }
                    }
                    return 'warn';     
                }
            },

            onRowExpand(event) {
                var history = this.allDataParts.filter((part) => part.id === event.data.id);
                
                for(let part of history) {
                    part.date = part.date.split("T")[0];
                }

                history.push({time: '', date: ''}); // TODO: this is a workarout for timeline error. 
                this.history = history;
            },

            onRowCollapse(event) {
                console.log(event);
            }
        }
    }
</script>
<style>

</style>
