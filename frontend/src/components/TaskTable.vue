<template>
    <Card style="background-color:darkgray; width: 50%;">
        <template #header>
            <Toast />
            <Button icon="pi pi-check" @click="save" style="margin: 2%;" :disabled=disableSaveButton />
        </template>
            <template #content>
                <DataTable v-model:expandedRows="expandedRows"  
                        :value="taskList" paginator :rows="5" dataKey="id" 
                        @rowExpand="onRowExpand" @rowCollapse="onRowCollapse">
                    <Column expander style="width: 5rem"/>  
                    <Column field="atm" :header= atm />
                    <Column field="problem" :header= problem />
                    <Column field="type" :header= type />
                    <Column field="status" :header= status >
                        <template #body="{ data, field }">
                            <Select v-model="data[field]" :options="generalStatusList" optionLabel="name" optionValue="name" 
                                    :placeholder=data.status v-on:change="event => updateChangedRow(event, data)" />   
                        </template>        
                    </Column>
                    <Column>
                        <template #body="{ data }">
                            <Button icon="pi pi-wrench" rounded @click="addPart(data)" />
                        </template>
                    </Column>
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
                <Dialog v-model:visible="dialogVisible" modal :header= requestPart :style="{ width: '30%' }">
                    <section class="flex-column">
                        <Select v-model="selectedPart" filter :options="parts" optionLabel="name" 
                                :placeholder= partsPlaceholder class="field-relation" fluid>
                            <template #value="slotProps">
                                <div v-if="slotProps.value">
                                    <div>{{ slotProps.value.name }}</div>
                                </div>
                                <span v-else>
                                    {{ slotProps.placeholder }}
                                </span>    
                            </template>
                            <template #option="slotProps">
                                <div>
                                    <div>{{ slotProps.option.name }}</div>
                                </div>
                            </template>
                        </Select>
                    </section>
                    <section class="options-line">
                        <Button icon="pi pi-plus" @click="setPartRequest"/>
                    </section>
                </Dialog>
            </template>
        </Card>
</template>
<script>
    import { ref } from 'vue';
    import { useI18n } from 'vue-i18n';
    import { useToast } from 'primevue/usetoast';

    export default {
        name: "TaskTable",
        emits: ["newTaskId"],
        props: {
            generalStatusList : { type: Array, required: false }
        },

        setup() {
            const taskList = ref([]);
            const taskAllList = ref();

            const history = ref([]);
            const expandedRows = ref({});

            const selectedRow = ref();

            const { t } = useI18n();

            const toast = useToast();

            const changedRow = ref();

            const disableSaveButton = ref(true);

            const dialogVisible = ref(false);

            const parts = ref([]);
            const selectedPart = ref();

            return {
                taskList, taskAllList, history, expandedRows, t,
                 selectedRow, toast, changedRow, disableSaveButton, dialogVisible, 
                 parts, selectedPart
            };
        },

        data() {
            return {
                atm: this.t("tasks.atm"),
                problem: this.t("tasks.taskProblem"),
                type: this.t("tasks.typeHeader"),
                status: this.t("general.status"),
                requestPart: this.t("parts.requestPart"),
                partsPlaceholder: this.t("parts.parts")
            }
        },

        beforeMount() {
            this.getTasKsList();
        },

        methods: {
            async getTasKsList() {
                await fetch("http://localhost:8090/listtasks", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addTaskList(json))
                .catch(error => this.getUserError(error))    
            },

            getUserError(error) {
                console.log(error);
            },

            addTaskList(json) {
                this.taskAllList = json;
                var taskId = 0;

                for(let task of this.taskAllList) {
                    if( taskId === task.id) continue
                    else {
                        this.taskList.push(task);
                        taskId = task.id
                     }     
                }

                (this.taskList.length > 0 ) ?
                    this.$emit("newTaskId", this.taskList[this.taskList.length - 1].id + 1):
                    this.$emit("newTaskId", 1);
            },

            onRowExpand(event) {
                var history = this.taskAllList.filter((task) => task.id === event.data.id);
                
                for(let task of history) {
                    task.date = task.date.split("T")[0];
                    task.time = task.time.split(".")[0];
                }

                history.push({time: '', date: ''}); // TODO: this is a workaround for timeline error. 
                this.history = history;
            },

            onRowCollapse(event) {
                console.log(event);
            },

            async setTaskNewStatus(taskId, status ) {
                await fetch("http://localhost:8090/settasknewstatus", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({id: taskId, status: status}), 
                })
                .then(response => {
                    this.toast.add({ severity: 'success', 
                        summary: this.t("general.successMessage"), 
                        detail: this.t("tasks.taskCreated"), 
                        life: 3000 });
                })
                .catch(error => this.getTaskNewStatusError(error)) 
            },

            getTaskNewStatusError(error) {
                this.toast.add({ severity: 'error', 
                     summary: this.t("general.errorMessage"), 
                     detail: this.t("tasks.taskNotCreated"), 
                     life: 3000 }); 
            },

            save() {
                this.setTaskNewStatus(this.changedRow.id, this.changedRow.status);
            },

            updateChangedRow(event, data) {
                this.changedRow = data;
                this.disableSaveButton = false;
            },

            addPart(data) {
                this.selectedRow = data;
                this.getPartsList(data);
                this.dialogVisible = true;
            },

            async getPartsList(task) {
                await fetch("http://localhost:8090/listpartsatm", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({atm: task.atm}), 
                })
                .then(response => response.json())
                .then(json => this.addPartsList(json))
                .catch(error => this.getPartsError(error))    
            },

            getPartsError(error) {
                this.toast.add({ severity: 'error', 
                     summary: this.t("general.errorMessage"), 
                     detail: this.t("general.serverError"), 
                     life: 3000 });
            },

            addPartsList(json) {
                this.parts = json;
            },

            async setPartRequest() {
                await fetch("http://localhost:8090/setpartsatm", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({ partnumber: this.selectedPart.partnumber, taskId: this.selectedRow.id }), 
                })
                .then(response => this.toast.add({ severity: 'success', 
                    summary: this.t("general.successMessage"), 
                    detail: this.t("parts.partRequested"), 
                    life: 3000 }))
                .catch(error => this.getPartsError(error))    
            }

        }
    }   
     
</script>