<template>
    <h2>{{ tasks }}</h2>
    <div class="new-task">
        <Card style="width: 35%; background-color:darkgray;" class="field-relation">
            <template #content >
                <h3>{{  atm.toUpperCase() }}</h3>
                <section class="new-task">
                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="atm" :placeholder= atm  class="field-relation">
                    <template #value="slotProps">
                        <div v-if="slotProps.value" class="flex items-center">
                            <div>{{ slotProps.value.atm }}</div>
                        </div>
                        <span v-else>
                            {{ slotProps.placeholder }}
                        </span>    
         
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>{{ slotProps.option.atm }}</div>
                        </div>
                    </template>
                    </Select>

                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="name" :placeholder= atmName  class="field-relation">
                    <template #value="slotProps">
                        <div v-if="slotProps.value" class="flex items-center">
                            <div>{{ slotProps.value.name }}</div>
                        </div>
                        <span v-else>
                            {{ slotProps.placeholder }}
                        </span>    
                    
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>{{ slotProps.option.name }}</div>
                        </div>
                    </template>
                    </Select>

                    <Select v-model="selectedAtm" filter :options="atms" optionLabel="neighborhood" :placeholder= atmNeighborhood class="last-field-relation">
                    <template #value="slotProps">
                        <div v-if="slotProps.value" class="flex items-center">
                            <div>{{ slotProps.value.neighborhood }}</div>
                        </div>
                        <span v-else>
                            {{ slotProps.placeholder }}
                        </span>    
                    
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>{{ slotProps.option.neighborhood }}</div>
                        </div>
                    </template>
                    </Select>
                </section>

                <section>
                    <h3>{{ problem.toUpperCase() }}</h3>
                    <Select v-model="selectedProblems" filter :options="problems" optionLabel="problem" :placeholder= problem  class="field-relation">
                    <template #value="slotProps">
                        <div v-if="slotProps.value" class="flex items-center">
                            <div>{{ slotProps.value.problem }}</div>
                        </div>
                        <span v-else>
                            {{ slotProps.placeholder }}
                        </span>    
                    
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>{{ slotProps.option.problem }}</div>
                        </div>
                    </template>
                    </Select>

                    <Select v-model="selectedProblems" filter :options="problems" optionLabel="name" :placeholder= problemName  class="field-relation">
                    <template #value="slotProps">
                        <div v-if="slotProps.value" class="flex items-center">
                            <div>{{ slotProps.value.name }}</div>
                        </div>
                        <span v-else>
                            {{ slotProps.placeholder }}
                        </span>    
                    
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>{{ slotProps.option.name }}</div>
                        </div>
                    </template>
                    </Select>
                </section>
                <section>
                    <h3>{{ type.toUpperCase() }}</h3>
                    <div class="radio-buttom-align">
                        <div v-for="type in taskType" :key="type.id" >
                            <RadioButton v-model="selectedTaskType" :inputId="'' + type.id" name="dynamic" :value="type.task_type" />
                            <label :for="'' + type.id" style="margin-right: 5%;">{{ type.task_type }}</label>
                        </div>
                    </div>
                </section>
        
                <section class="options-line">
                    <Button icon="pi pi-plus" class="field-relation"/>
                    <Button icon="pi pi-search" class="field-relation"/>
                </section>  
            </template>
        </Card>
        <TaskTable class="field-relation"/>
    </div>
</template>
<script>
    import Card from 'primevue/card';
    import InputNumber from 'primevue/inputnumber';
    import FloatLabel from 'primevue/floatlabel';
    import Select from 'primevue/select';
    import { ref } from 'vue';
    import { useI18n } from 'vue-i18n';
    import Button from 'primevue/button';
    import RadioButton from 'primevue/radiobutton';
    import TaskTable from '../components/TaskTable.vue';

    export default {
        name: 'TaskPage',
        components: {
            Card,
            InputNumber,
            Select,
            FloatLabel,
            Button,
            RadioButton, 
            TaskTable
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

            return {
                value, t, atms, selectedAtm, problems, selectedProblems, selectedTaskType, taskType
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
        }
    }
</script>
<style>
.new-task {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
}
.header-text {
    display: flex;
    justify-content: center;
    
}
.options-line {
    display: flex;
    flex-direction: row;
    justify-content: end;
    
}
.radio-buttom-align {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
}
.field-relation {
    margin-right: 3%;
}
.last-field-relation, .field-relation, .new-task{
    margin-bottom: 3%;
}
</style>