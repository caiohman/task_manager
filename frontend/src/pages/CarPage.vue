<template>
    <div class="flex-row flex-evenly">
        <section style="width: 45%">
            <Carousel
                :value="carPhotos"
                :numVisible="1"
                :numScroll="1"
                circular
                :autoplayInterval="30000"
            >
                <template #item="slotProps">
                    <div class="card-position">
                        <img
                            :src="slotProps.data.image"
                            alt="car image"
                            class="photo-config"
                            @click="selectedCar(slotProps.data.name)"
                        />
                    </div>
                </template>
            </Carousel>
        </section>
        <section style="width: 45%">
            <div>
                <Fieldset v-show="isCarMatched === true" :legend="carLegend">
                    <div>
                        <p>
                            {{
                                "" + t("cars.model") + " : " + carMatched.model
                            }}
                        </p>
                        <p>
                            {{
                                "" +
                                t("cars.licensePlate") +
                                " : " +
                                carMatched.license_plate
                            }}
                        </p>
                        <p>
                            {{
                                "" +
                                t("cars.receivedDate") +
                                " : " +
                                carMatched.user_date?.substring(0, 10)
                            }}
                        </p>

                        <p>
                            {{ "" + t("cars.km") + " : " + carMatched.car_km }}
                        </p>
                    </div>
                </Fieldset>
            </div>
        </section>
    </div>
</template>
<script>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import loggedStore from "../stores/LoggedStore";

export default {
    name: "CarPage",

    setup() {
        const { t } = useI18n();
        const userLogged = loggedStore();
        const userCars = ref();
        const isCarMatched = ref(false);
        const carMatched = ref([]);

        return {
            t,
            userLogged,
            userCars,
            isCarMatched,
            carMatched,
        };
    },

    mounted() {
        this.getCarInformation(this.userLogged.cpf);
    },

    data() {
        return {
            carPhotos: [
                { name: "Gol", image: "/src/assets/cars/gol.jpg" },
                { name: "HB20", image: "/src/assets/cars/hb20.jpg" },
                { name: "Argo", image: "/src/assets/cars/argo.jpg" },
            ],
            carLegend: this.t("cars.car"),
        };
    },

    methods: {
        async getCarInformation(cpf) {
            await fetch("http://localhost:8090/listcar", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ cpf: cpf }),
            })
                .then((response) => response.json())
                .then((json) => (this.userCars = json))
                .catch((error) => this.getCarsError(error));
        },

        getCarsError(error) {
            console.log(error);
        },

        selectedCar(name) {
            this.userCars.forEach((car) => {
                if (car.model === name) {
                    this.carMatched = car;
                    this.isCarMatched = true;
                }
            });
        },
    },
};
</script>
<style>
.photo-config {
    width: 80%;
    height: 60%;
}
</style>
