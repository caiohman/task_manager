<template>
    <Card style="background-color:darkgray; width: 50%;">
        <template #header>
            <Toast />
            <Button icon="pi pi-check" @click="save" style="margin: 2%;" :disabled=disableSaveButton />
        </template>
            <template #content>
                <DataTable v-model:expandedRows="expandedRows"  v-model:selection="selectedRow"
                        selectionMode="single"
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

            return {
                taskList, taskAllList, history, expandedRows, t,
                 selectedRow, toast, changedRow, disableSaveButton
            };
        },

        data() {
            return {
                atm: this.t("tasks.atm"),
                problem: this.t("tasks.taskProblem"),
                type: this.t("tasks.typeHeader"),
                status: this.t("general.status"),
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
                this.$emit("newTaskId", this.taskList[this.taskList.length - 1].id + 1);
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
            }
        }

    }   
     
</script>