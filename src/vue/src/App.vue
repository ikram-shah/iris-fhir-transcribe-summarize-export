<template>
  <div class="">
    <TopBar
      :activeTopPage="activeTopPage"
      @topPageChange="changeTopPage"
      @patient="patientSelected"
    >
    <div v-if="selectedPatientData === null">
      <HomePage/>
    </div>
    
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
        <div v-if="activePage === 'Settings'">
          <SettingsPage />
        </div>
      </SidebarContent>
    </div>
  </div>
</template>

<script>
import HomePage from "./components/HomePage.vue"
import TopBar from "./components/TopBar.vue";
import PatientsPage from "./components/PatientsPage.vue";
import InteractionsPage from "./components/InteractionsPage.vue";
import ObservationPage from "./components/ObservationPage.vue";
import EncountersPage from "./components/EncountersPage.vue";
import SettingsPage from "./components/SettingsPage.vue";
import SidebarContent from "./components/SidebarContent.vue";

export default {
  components: {
    HomePage,
    TopBar,
    PatientsPage,
    SettingsPage,
    InteractionsPage,
    ObservationPage,
    EncountersPage,
    SidebarContent,
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
