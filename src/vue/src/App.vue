<template>
  <div class="">
    <SidebarContent :activePage="activePage" @pageChange="changePage">
      <div v-if="activePage === 'Home'">
        <HomePage />
      </div>
      <div v-if="activePage === 'Interactions'">
        <InteractionsPage />
      </div>
      <div v-if="activePage === 'Patients'">
        <PatientsPage />
      </div>
      <div v-if="activePage === 'Observations'">
        <ObservationPage />
      </div>
      <div v-if="activePage === 'Settings'">
        <SettingsPage />
      </div>
    </SidebarContent>
  </div>
</template>

<script>
import HomePage from "./components/HomePage.vue";
import PatientsPage from "./components/PatientsPage.vue";
import InteractionsPage from "./components/InteractionsPage.vue";
import ObservationPage from "./components/ObservationPage.vue";
import SettingsPage from "./components/SettingsPage.vue";
import SidebarContent from "./components/SidebarContent.vue";

export default {
  components: {
    HomePage,
    PatientsPage,
    SettingsPage,
    InteractionsPage,
    ObservationPage,
    SidebarContent,
  },
  data() {
    return {
      activePage: "Home", // Set the initial active page
    };
  },
  methods: {
    changePage(page) {
      this.activePage = page;
    },
  },
};
</script>
