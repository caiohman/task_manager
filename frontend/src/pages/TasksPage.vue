<template>
    <div class="flex-row" style="justify-content: space-evenly" >    
        <Fieldset :legend="tasks" class="field-relation" style="width: 35%; height: fit-content;">   
                <section class="flex-row">
                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="atm" 
                            :placeholder= atm  style="width: 30%;" size="small" class="field-relation">
                        <template #value="slotProps">
                            <div v-if="slotProps.value">
                                <div>{{ slotProps.value.atm }}</div>
                            </div>
                            <span v-else>
                                {{ slotProps.placeholder }}
                            </span>    
                        </template>
                        <template #option="slotProps">
                            <div>
                                <div>{{ slotProps.option.atm }}</div>
                            </div>
                        </template>
                    </Select>

                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="name"
                            :placeholder= atmName size="small" class="field-relation" style="width: 30%;">
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

                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="neighborhood" 
                            :placeholder= atmNeighborhood size="small" class="last-field-relation" style="width: 30%;">
                        <template #value="slotProps">
                            <div v-if="slotProps.value">
                                <div>{{ slotProps.value.neighborhood }}</div>
                            </div>
                            <span v-else>
                                {{ slotProps.placeholder }}
                            </span>                        
                        </template>
                        <template #option="slotProps">
                            <div>
                                <div>{{ slotProps.option.neighborhood }}</div>
                            </div>
                        </template>
                    </Select>
                </section>

                <section>
                    <Select v-model="selectedProblems" filter :options="problems" optionLabel="problem" 
                            :placeholder= problem size="small" class="field-relation" style="width: 30%;">
                        <template #value="slotProps">
                            <div v-if="slotProps.value">
                                <div>{{ slotProps.value.problem }}</div>
                            </div>
                            <span v-else>
                                {{ slotProps.placeholder }}
                            </span>                        
                        </template>
                        <template #option="slotProps">
                            <div>
                                <div>{{ slotProps.option.problem }}</div>
                            </div>
                        </template>
                    </Select>

                    <Select v-model="selectedProblems" filter :options="problems" optionLabel="name" 
                            :placeholder= problemName size="small" class="field-relation" style="width: 30%;">
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
                <section class="flex-column">
                    <div class="radio-buttom-align">
                        <div v-for="type in taskType" :key="type.id" class="radio-buttom-self">
                            <RadioButton v-model="selectedTaskType" :inputId="'' + type.id" name="dynamic" :value="type.task_type" />
                            <label :for="'' + type.id" style="margin-right: 5%;" >{{ type.task_type }}</label>
                        </div>
                    </div>
                    <div class="radio-buttom-align">
                        <div v-for="status in generalStatus" :key="status.id" class="radio-buttom-self">
                            <RadioButton v-model="selectGeneralStatus" :inputId="'' + status.id" name="dynamic" :value="status.name" />
                            <label :for="'' + status.id" style="margin-right: 5%;">{{ status.name }}</label>
                        </div>
                    </div>
                </section>
        
                <section class="options-line">
                    <Toast />
                    <Button icon="pi pi-plus" class="field-relation" @click="saveNewTaskValidation"/>
                    <Button icon="pi pi-search" class="field-relation"/>
                </section>  
        
        </Fieldset>
        <TaskTable class="field-relation" :general-status-list="generalStatus"
          :update="tableUpdate"  
          @new-task-id="(id) => newTaskId = id"/>
    </div>
</template>
<script>
    import InputNumber from 'primevue/inputnumber';
    import FloatLabel from 'primevue/floatlabel';
    import Select from 'primevue/select';
    import { ref } from 'vue';
    import { useI18n } from 'vue-i18n';
    import Button from 'primevue/button';
    import RadioButton from 'primevue/radiobutton';
    import TaskTable from '../components/TaskTable.vue';
    import { useToast } from 'primevue/usetoast';
    import Fieldset from 'primevue/fieldset';

    export default {
        name: 'TaskPage',
        components: {
            InputNumber,
            Select,
            FloatLabel,
            Button,
            RadioButton, 
            TaskTable,
            Fieldset
        },

        setup() {
            const value = ref();
            const { t } = useI18n();

            const atms = ref();
            const problems = ref();

            const selectedAtm = ref();
            const selectedProblems = ref();

            const selectedTaskType = ref();
            const taskType = ref();

            const generalStatus = ref();
            const selectGeneralStatus = ref();

            const toast = useToast();

            const newTaskId = ref();

            const tableUpdate = ref(false);

            return {
                value, t, atms, selectedAtm, problems, selectedProblems, selectedTaskType, taskType, toast, newTaskId,
                 generalStatus, selectGeneralStatus, tableUpdate
            };
        },

        data() {
            return {
                atm: this.t("tasks.atm"),
                atmName: this.t("tasks.atmName"),
                atmNeighborhood: this.t("tasks.atmNeighborhood"),
                problem: this.t("tasks.taskProblem"),
                problemName: this.t("tasks.taskProblemName"),
                type: this.t("tasks.typeHeader"),
                status: this.t("general.status"),
                tasks: this.t("tasks.tasks")
            };
        },

        beforeMount() {
            this.getAtmsList();   
            this.getProblemsList(); 
            this.getTaskTypeList();
            this.getGeneralStatusList();   
        },

        methods: {
            async getAtmsList() {
                await fetch("http://localhost:8090/listatms", {
                    method: "GET",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addAtmsList(json))
                .catch(error => this.getUserError(error))    
            },

            getUserError(error) {
                console.log(error);
            },

            addAtmsList(json) {
                this.atms = json;
            },

            async getProblemsList() {
                await fetch("http://localhost:8090/listproblems", {
                    method: "GET",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addProblemsList(json))
                .catch(error => this.getUserError(error))    
            },

            addProblemsList(json) {
                this.problems = json;
            },

            async getTaskTypeList() {
                await fetch("http://localhost:8090/listtasktype", {
                    method: "GET",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addTaskTypeList(json))
                .catch(error => this.getUserError(error))    
            },

            addTaskTypeList(json) {
                this.taskType = json;
            },

            async setNewTask() {
                await fetch("http://localhost:8090/setnewtask", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({id: this.newTaskId, atm: this.selectedAtm.atm, problem: this.selectedProblems.problem, type: this.selectedTaskType}), 
                })
                .then(response => {
                    this.toast.add({ severity: 'success', 
                        summary: this.t("general.successMessage"), 
                        detail: this.t("tasks.taskCreated"), 
                        life: 3000 });
                    
                    this.tableUpdate = true;
                    
                })
                .catch(error => this.getNewTaskError(error)) 
            },

            saveNewTaskValidation() {
                if(this.selectedAtm === undefined || 
                 this.selectedProblems === undefined || 
                 this.selectedTaskType === undefined ) {
                    this.toast.add({ severity: 'error', 
                     summary: this.t("general.errorMessage"), 
                     detail: this.t("tasks.errorDetail"), 
                     life: 3000 });
                } else {
                    this.setNewTask();
                }
            },

            getNewTaskError(error) {
                this.toast.add({ severity: 'error', 
                     summary: this.t("general.errorMessage"), 
                     detail: this.t("tasks.taskNotCreated"), 
                     life: 3000 }); 
            },

            async getGeneralStatusList() {
                await fetch("http://localhost:8090/listgeneralstatus", {
                    method: "GET",
                    headers: {"Content-Type": "application/json"}, 
                })
                .then(response => response.json())
                .then(json => this.addGeneralStatusList(json))
                .catch(error => this.getUserError(error))    
            },

            addGeneralStatusList(json) {
                this.generalStatus = json;
            }
        }
    }
</script>
<style>
.header-text {
    display: flex;
    justify-content: center;
    
}
.radio-buttom-align {
    display: flex;
    flex-direction: row;
    justify-content:space-evenly;
    flex-wrap: wrap;
    width: 80%;
}
.field-relation {
    margin-right: 3%;
}
.last-field-relation, .field-relation, .new-task{
    margin-bottom: 3%;
}
.radio-buttom-self {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}


</style>