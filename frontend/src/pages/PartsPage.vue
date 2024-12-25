<template>
    <div class="card-position">
        <Card style="background-color:darkgray; width: 80%;">
            <template #header>
                <Toast />
                <Button icon="pi pi-check" @click="save" style="margin: 2%;" :disabled=disableSaveButton />
            </template>
            <template #content>
                <DataTable v-model:expandedRows="expandedRows" :value="products" paginator :rows="5" dataKey="id"  
                        @rowExpand="onRowExpand" @rowCollapse="onRowCollapse">
                    <Column expander style="width: 5rem"/>    
                    <Column field="code" :header= codeHeader />
                    <Column field="name" :header= nameHeader />
                    <Column :header= statusHeader >
                        <template #body="{ data, field }">
                            <Select v-model="data[field]" :options="partStatus"
                                    :placeholder=data.status v-on:change="event => updateChangedRow(event, data)" > 
                                <template #value="slotProps">
                                    <div v-if="slotProps.value">
                                        <Tag :value="slotProps.value.name" :severity="getStatus(slotProps.value)" />
                                    </div>
                                    <div v-else>
                                        <Tag :value="slotProps.placeholder" :severity="getStatus(slotProps.placeholder)" />
                                    </div>    
                                </template>
                                <template #option="slotProps">
                                    <div>
                                        <Tag :value="slotProps.option.name" :severity="getStatus(slotProps.option)" />
                                    </div>
                                </template>    
                            </Select>
                        </template>
                    </Column>
                    <Column field="atm" :header= atmHeader >
                        <template #body="{ data, field }">
                            <div v-tooltip.bottom="data.atm_name">
                                <p>{{ data[field] }}</p>
                            </div>
                        </template>
                    </Column>
                    <Column field="problem" :header= problemHeader />
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
    import { ref } from 'vue';
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

            const partStatus = ref([]);
            const changedRow = ref();

            const disableSaveButton = ref(true);

            return {
                products, t, expandedRows, history, 
                toast, partStatus, changedRow, disableSaveButton
            };
        },

        data() {
            return {
                codeHeader: this.t("parts.codeHeader"),
                nameHeader: this.t("general.name"),
                statusHeader: this.t("general.status"),
                atmHeader: this.t("general.atm"),
                parts: this.t("parts.parts"),
                allDataParts: null,
                problemHeader: this.t("parts.problemHeader")
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

            updateChangedRow(event, data) {
                this.changedRow = data;
                this.disableSaveButton = false;
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
                this.setPartNewStatus(this.changedRow.id, this.changedRow.undefined.id);
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
