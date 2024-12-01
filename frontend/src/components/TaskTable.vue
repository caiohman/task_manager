<template>
    <Card style="background-color:darkgray; width: 40%;">
            <template #content>
                <DataTable v-model:expandedRows="expandedRows" :value="taskList" paginator :rows="5" dataKey="id" 
                        @rowExpand="onRowExpand" @rowCollapse="onRowCollapse">
                    <Column expander style="width: 5rem"/>  
                    <Column field="atm" :header= atm />
                    <Column field="problem" :header= problem />
                    <Column field="type" :header= type />
                    <Column field="status" :header= status />
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

    export default {
        name: "TaskTable",

        setup() {
            const taskList = ref([]);
            const taskAllList = ref();

            const history = ref([]);
            const expandedRows = ref({});

            const { t } = useI18n();

            return {
                taskList, taskAllList, history, expandedRows, t
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
            },

            onRowExpand(event) {
                var history = this.taskAllList.filter((task) => task.id === event.data.id);
                
                for(let task of history) {
                    task.date = task.date.split("T")[0];
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