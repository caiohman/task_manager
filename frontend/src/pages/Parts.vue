<template>
    <div class="card">
        <DataTable :value="products" tableStyle="width: 50%">
            <Column field="code" :header= codeHeader ></Column>
            <Column field="name" :header= nameHeader ></Column>
            <Column field="status" :header= statusHeader ></Column>
            <Column field="atm" :header= atmHeader ></Column>
        </DataTable>
    </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import { useI18n } from 'vue-i18n';

export default {
    name: 'Parts',
    components: {
        DataTable,
        Column
    },

    setup() {
        const products = ref();
        const { t } = useI18n();

        return {
            products, t
        }
    },

    data() {
        return {
            codeHeader: this.t("parts.codeHeader"),
            nameHeader: this.t("parts.nameHeader"),
            statusHeader: this.t("parts.statusHeader"),
            atmHeader: this.t("parts.atmHeader"),
        }
    }
}
</script>
