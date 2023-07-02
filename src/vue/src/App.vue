<template>
  <div class="">
    <TopBar @patient="patientSelected"> </TopBar>
    <div v-if="selectedPatientData !== null">
      <SidebarContent
        :activePage="activePage"
        @pageChange="changePage"
        :activePatient="selectedPatientData"
      >
        <div v-if="activePage === 'Interactions'">
          <InteractionsPage :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'Observations'">
          <ObservationPage :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'Encounters'">
          <EncountersPage :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'DocumentsSearch'">
          <DocumentsSearch :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'DocumentsPage'">
          <DocumentsPage :activePatient="selectedPatientData" />
        </div>
      </SidebarContent>
    </div>
    <div v-else>
      <div class="flex justify-center">
        <div class="p-16">
          <h2 class="text-3xl font-bold mb-16">Recently Viewed Patients</h2>
          <div
            v-for="patient in recentPatients"
            :key="patient.id"
            class="mb-12 flex justify-center"
          >
            <h3 class="text-xl font-medium">{{ patient.firstName }} {{ patient.lastName }}</h3>
            <button @click="patientSelected(patient)">
              <font-awesome-icon
                icon="fa-arrow-up-right-from-square"
                class="m-1 pl-4 text-gray-500"
              ></font-awesome-icon>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import TopBar from "./components/TopBar.vue";
import InteractionsPage from "./components/InteractionsPage.vue";
import ObservationPage from "./components/ObservationPage.vue";
import EncountersPage from "./components/EncountersPage.vue";
import SidebarContent from "./components/SidebarContent.vue";
import DocumentsSearch from "./components/DocumentsSearch.vue";
import DocumentsPage from "./components/DocumentsPage.vue";

export default {
  components: {
    TopBar,
    InteractionsPage,
    ObservationPage,
    EncountersPage,
    SidebarContent,
    DocumentsPage,
    DocumentsSearch,
  },
  created() {
    const localStorageKey = "recentlyViewedPatients";
    const storedPatients =
      JSON.parse(localStorage.getItem(localStorageKey)) || [];
    this.recentPatients = storedPatients;
  },
  data() {
    return {
      activePage: "Interactions",
      selectedPatientData: null,
      recentPatients: [],
    };
  },
  methods: {
    changePage(page) {
      this.activePage = page;
    },
    patientSelected(data) {
      this.selectedPatientData = data;
    },
  },
};
</script>
