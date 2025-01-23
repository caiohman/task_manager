<template>
    <section class="flex-row" style="justify-content: space-evenly">
        <img
            :src="image"
            alt="Aligned Atms"
            style="width: 35%"
            class="page-margin-left"
        />
        <Fieldset
            :legend="atms"
            style="width: 30%; margin-left: 3%; height: fit-content"
        >
            <div class="flex-column">
                <InputFilter
                    :field="region"
                    :placeholder="selectRegion"
                    class="space-below"
                    :submitted="submitted"
                    @select-option="
                        (option) => validateField(option, field[0].id)
                    "
                />
                <InputFilter
                    :field="models"
                    :placeholder="selectModel"
                    class="space-below"
                    :submitted="submitted"
                    @select-option="
                        (option) => validateField(option, field[1].id)
                    "
                />
                <InputNumber
                    v-model="atmNumber"
                    size="small"
                    :placeholder="atm"
                    :useGrouping="false"
                    class="space-below"
                />
                <InputText
                    v-model="coordinates"
                    size="small"
                    :placeholder="coordinate"
                    coordinate
                    type="text"
                    class="space-below"
                />
                <InputText
                    v-model="addressName"
                    size="small"
                    :placeholder="name"
                    type="text"
                    class="space-below"
                />

                <section class="options-line">
                    <Toast />
                    <div class="field-relation">
                        <Button
                            icon="pi pi-plus"
                            @click="saveNewAtmValidation"
                        />
                    </div>
                    <div class="field-relation">
                        <Button icon="pi pi-search" @click="searchAtm" />
                    </div>
                </section>
            </div>
        </Fieldset>
    </section>
</template>
<script>
import { useI18n } from "vue-i18n";
import { ref } from "vue";
import Fieldset from "primevue/fieldset";
import InputFilter from "../components/InputFilter.vue";
import InputNumber from "primevue/inputnumber";
import InputText from "primevue/inputtext";
import { useToast } from "primevue/usetoast";

export default {
    name: "AtmPage",
    components: {
        Fieldset,
        InputFilter,
        InputNumber,
        InputText,
    },

    setup() {
        const { t } = useI18n();

        const region = ref([]);
        const selectedRegion = ref();

        const models = ref([]);
        const selectedModel = ref();

        const atmNumber = ref();

        const coordinates = ref();

        const submitted = ref(false);

        const toast = useToast();

        const addressName = ref();

        const atmList = ref([]);

        return {
            t,
            selectedRegion,
            region,
            models,
            atmNumber,
            coordinates,
            selectedModel,
            submitted,
            toast,
            addressName,
            atmList,
        };
    },

    beforeMount() {
        this.getRegionList();
        this.getModelsList();
        this.getAtm();
    },

    data() {
        return {
            image: "./src/assets/profiles/atm.jpg",
            atms: this.t("atms.atms"),
            selectRegion: this.t("atms.selectRegion"),
            selectModel: this.t("atms.selectModels"),
            field: [
                { id: 1, name: "region" },
                { id: 2, name: "models" },
            ],
            atm: this.t("atms.atmNumber"),
            coordinate: this.t("atms.coordinates"),
            name: this.t("atms.addressName"),
            test: "Atm",
        };
    },

    methods: {
        async getRegionList() {
            await fetch("http://localhost:8090/listregion", {
                method: "GET",
                headers: { "Content-Type": "application/json" },
            })
                .then((response) => response.json())
                .then((json) => this.addRegionList(json))
                .catch((error) => this.getRegionError(error));
        },

        addRegionList(json) {
            this.region = json;
        },

        getRegionError(error) {
            console.log(error);
        },

        async getModelsList() {
            await fetch("http://localhost:8090/listmodels", {
                method: "GET",
                headers: { "Content-Type": "application/json" },
            })
                .then((response) => response.json())
                .then((json) => this.addModelsList(json))
                .catch((error) => this.getModelsError(error));
        },

        addModelsList(json) {
            this.models = json;
        },

        getModelsError(error) {
            console.log(error);
        },

        saveNewAtmValidation() {
            this.submitted = true;
        },

        validateField(value, field) {
            if (value === undefined || value.length === 0) {
                this.toast.add({
                    severity: "error",
                    summary: this.t("general.errorMessage"),
                    detail: this.t("atms.errorEmpty"),
                    life: 3000,
                });

                this.submitted = false;
            } else {
                field === this.field[0].id
                    ? (this.selectedRegion = value)
                    : this.submitUpdate(value);
            }
        },

        submitUpdate(value) {
            this.selectedModel = value;
            this.submitted = false;
            this.newAtm();
        },

        async newAtm() {
            if (
                this.selectedRegion !== undefined &&
                this.selectedModel !== undefined &&
                this.atmNumber !== undefined &&
                this.coordinates !== undefined &&
                this.addressName !== undefined
            ) {
                await fetch("http://localhost:8090/setnewatm", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        id: this.atmNumber,
                        coordinates: this.coordinates,
                        region: this.selectedRegion.id,
                        model: this.selectedModel.id,
                        name: this.addressName,
                    }),
                })
                    .then((response) => {
                        if (response.status === 400) {
                            this.toast.add({
                                severity: "error",
                                summary: this.t("general.errorMessage"),
                                detail: this.t("atms.atmExists"),
                                life: 3000,
                            });
                        } else {
                            this.toast.add({
                                severity: "success",
                                summary: this.t("general.successMessage"),
                                detail: this.t("atms.atmCreated"),
                                life: 3000,
                            });
                        }
                    })
                    .catch((error) => this.setAtmError(error));
            }
        },

        setAtmError(error) {
            this.toast.add({
                severity: "error",
                summary: this.t("general.errorMessage"),
                detail: this.t("general.serverError"),
                life: 3000,
            });
        },

        async getAtm() {
            await fetch("http://localhost:8090/getatmlist", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
            })
                .then((response) => response.json())
                .then((json) => (this.atmList = json))
                .catch((error) => this.getAtmListError(error));
        },

        getAtmListError(error) {
            this.toast.add({
                severity: "error",
                summary: this.t("general.errorMessage"),
                detail: this.t("general.serverError"),
                life: 3000,
            });
        },

        searchAtm() {
            // TODO : create a v-model for InputFilter and search alg
        },
    },
};
</script>
<style></style>
