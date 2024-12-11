<template>
    <Select v-model="selectedOption" filter editable :options="field" optionLabel="name" :placeholder= placeholder >
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
</template>
<script>
    import { ref } from 'vue';

    export default {
        name: "InputFilter",
        props: {
            field : { type: Array, required: false },
            placeholder : { type: String, required: true },
            submitted: { type: Boolean, required: false }
        },
        emits: ["selectOption"], 
        setup() {
            const selectedOption = ref();

            return {
                selectedOption
            }
        },
        watch: {
            submitted(newValue, oldValue) {
                if(newValue === true) { 
                    this.$emit("selectOption", this.selectedOption);
                }
            }
        }
    }
</script>