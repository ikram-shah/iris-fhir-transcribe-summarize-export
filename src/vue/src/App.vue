<template>
  <div class="">
    <TopBar
      :activeTopPage="activeTopPage"
      @topPageChange="changeTopPage"
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
          <InteractionsPage />
        </div>
        <div v-if="activePage === 'Patients'">
          <PatientsPage />
        </div>
        <div v-if="activePage === 'Observations'">
          <ObservationPage :activePatient="selectedPatientData" />
        </div>
        <div v-if="activePage === 'Encounters'">
          <EncountersPage />
        </div>
        <div v-if="activePage === 'DocumentsSearch'">
          <DocumentsSearch />
        </div>
        <div v-if="activePage === 'DocumentsPage'">
          <DocumentsPage />
        </div>
      </SidebarContent>
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
      activePage: "Home",
      activeTopPage: "Home",
      selectedPatientData: null,
    };
  },
  methods: {
    changePage(page) {
      this.activePage = page;
    },
    changeTopPage(page) {
      this.activeTopPage = page;
    },
    patientSelected(data) {
      this.selectedPatientData = data;
    },
  },
};
</script>
