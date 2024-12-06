<template>
    <h2>{{ parts }}</h2>
    <div class="card-position">
        <Card style="background-color:darkgray; width: 80%;">
            <template #header>
                <Toast />
                <Button icon="pi pi-check" @click="save" style="margin: 2%;" />
            </template>
            <template #content>
                <DataTable v-model:expandedRows="expandedRows" :value="products" paginator :rows="5" dataKey="id" 
                        editMode="cell" @cell-edit-complete="onCellEdit" 
                        @rowExpand="onRowExpand" @rowCollapse="onRowCollapse">
                    <Column expander style="width: 5rem"/>    
                    <Column field="code" :header= codeHeader />
                    <Column field="name" :header= nameHeader />
                    <Column :header= statusHeader >
                        <template #body="slotProps">
                            <Tag :value="slotProps.data.status" :severity="getStatus(slotProps.data)" />
                        </template>
                        <template #editor="{ data, field }">
                            <Select v-model="data[field]" :options="partStatus" optionLabel="name" />    
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
    import { useToast } from 'primevue/usetoast';

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
            const history = ref([]);

            const toast = useToast();

            const saveNewStatus = ref(false);
            const partStatus = ref([]);

            return {
                products, t, expandedRows, history, 
                toast, saveNewStatus
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
            this.getPartStatusOptions();
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
                    part.time = part.time.split(".")[0];
                }

                history.push({time: '', date: ''}); // TODO: this is a workarout for timeline error. 
                this.history = history;
            },

            onRowCollapse(event) {
                console.log(event);
            },

            onCellEdit(event) {
                let { data, newValue, field } = event;

                if(this.saveNewStatus) {
                    if(newValue !== data[field] && newValue.name !== data[field]) {
                        data[field] = newValue.name;
                        this.setPartNewStatus(data.id, newValue.id);
                        this.saveNewStatus = false; 
                    }    
                }
            },

            async setPartNewStatus(partId, status) {
                await fetch("http://localhost:8090/setnewstatuspart", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({id: partId, status: status}), 
                })
                .then(response => {
                    this.toast.add({ severity: 'success', 
                        summary: this.t("general.successMessage"), 
                        detail: this.t("parts.updatedPart"), 
                        life: 3000 });
                })
                .catch(error => this.getPartNewStatusError(error)) 
            },

            getPartNewStatusError(error) {
                this.toast.add({ severity: 'error', 
                     summary: this.t("general.errorMessage"), 
                     detail: this.t("parts.partNotUpdated"), 
                     life: 3000 }); 
            },


            save() {
                this.saveNewStatus = true;
                console.log('Saving ...');
            },

            async getPartStatusOptions() {
                await fetch("http://localhost:8090/listpartstatus", {
                    method: "GET",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addPartStatusList(json))
                .catch(error => this.getPartStatusError(error))
            },

            addPartStatusList(json) {
                this.partStatus = json;
            },

            getPartStatusError(error) {
                console.log(error);
            }
        }
    }
</script>
<style>

</style>
