<template>
  <div class="">
    <TopBar
      @patient="patientSelected"
    >
    </TopBar>
    <div v-if="selectedPatientData !== null">
      <SidebarContent
        :activePage="activePage"
        @pageChange="changePage"
        :activePatient="selectedPatientData"
      >
        <div v-if="activePage === 'Interactions'">
          <InteractionsPage :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'Patients'">
          <PatientsPage />
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
          <h2 class="text-3xl font-bold mb-16">Recently Viewed</h2>
          <div
            v-for="patient in recentPatients"
            :key="patient.id"
            class="mb-12 flex justify-center"
          >
            <h3 class="text-xl font-medium">{{ patient.name }}</h3>
            <button>
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
import PatientsPage from "./components/PatientsPage.vue";
import InteractionsPage from "./components/InteractionsPage.vue";
import ObservationPage from "./components/ObservationPage.vue";
import EncountersPage from "./components/EncountersPage.vue";
import SidebarContent from "./components/SidebarContent.vue";
import DocumentsSearch from "./components/DocumentsSearch.vue";
import DocumentsPage from "./components/DocumentsPage.vue";

export default {
  components: {
    TopBar,
    PatientsPage,
    InteractionsPage,
    ObservationPage,
    EncountersPage,
    SidebarContent,
    DocumentsPage,
    DocumentsSearch,
  },
  data() {
    return {
      activePage: "Interactions",
      selectedPatientData: null,
      recentPatients: [
        { id: 1, name: "Liam Johnson" },
        { id: 2, name: "Olivia Patel" },
        { id: 3, name: "Noah Nguyen" },
        { id: 4, name: "Ava Martinez" },
        { id: 5, name: "Lucas Kim" },
        { id: 6, name: "Sophia Ali" },
        { id: 7, name: "Jackson Wong" },
        { id: 8, name: "Amara Gonzalez" },
      ],
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
