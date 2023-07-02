<template>
  <div
    class="topbar bg-gray-100 border text-gray-800 flex items-center px-4 py-2"
  >
    <button @click="refreshPage()" class="flex items-center">
      <img src="../assets/logo.png" alt="Logo" class="w-8 h-8 ml-4 mr-2" />
      <h1 class="text-xl font-bold">Transcribe-Summarize-Export</h1>
    </button>
    <div class="relative flex items-center justify-center flex-grow">
      <input
        v-model="searchQuery"
        id="patientSearch"
        type="text"
        class="form-input block w-1/2 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        placeholder="Enter patient name or id"
        @input="search"
      />
      <ul
        v-if="filteredPatients.length > 0"
        class="absolute mt-2 bg-white border border-gray-300 rounded-md shadow-md dark:bg-gray-800 w-1/2 z-10"
        style="top: 100%"
      >
        <li
          v-for="patient in filteredPatients"
          :key="patient.id"
          @click="selectPatient(patient)"
          :class="{ 'text-blue-500': patient === selectedPatient }"
          class="py-2 px-4 cursor-pointer bg-white hover:bg-gray-100 dark:hover:bg-gray-100"
        >
          <div class="flex justify-between">
            <span>{{ patient.firstName }} {{ patient.lastName }}</span>
            <span>{{ patient.id }}</span>
          </div>
        </li>
      </ul>
    </div>
    <button ref="googleLoginBtn"></button>
  </div>
</template>

<script>
export default {
  computed: {
    filteredPatients() {
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        return this.patients.filter(
          (patient) =>
            patient.firstName.toLowerCase().includes(query) ||
            patient.lastName.toString().includes(query) ||
            patient.id.toString().includes(query)
        );
      } else {
        return [];
      }
    },
  },
  mounted() {
    this.loginInit(this.gClientId);
    this.fetchAllPatients();
  },
  data() {
    return {
      gClientId: process.env.G_CLIENT_ID,
      searchQuery: "",
      patients: [],
      selectedPatient: null,
    };
  },
  methods: {
    refreshPage() {
      window.location.reload();
    },
    loginInit(gClientId) {
      this.initGoogleOAuth(gClientId);
      this.renderGoogleLoginButton();
    },
    initGoogleOAuth(gClientId) {
      this.gClient = window.google.accounts.oauth2.initTokenClient({
        client_id: gClientId,
        scope:
          "https://www.googleapis.com/auth/documents https://www.googleapis.com/auth/spreadsheets",
        callback: this.handleOauthToken,
      });
      window.google.accounts.id.initialize({
        client_id: gClientId,
        callback: this.handleCredentialResponse,
      });
    },
    renderGoogleLoginButton() {
      window.google.accounts.id.renderButton(this.$refs.googleLoginBtn, {
        text: "Login",
        size: "large",
        theme: "filled_blue", // options: filled_black | outline | filled_blue
      });
    },
    async handleCredentialResponse(response) {
      try {
        this.gClient.requestAccessToken();
        console.log(response);
      } catch (error) {
        console.error(error);
      }
    },
    async handleOauthToken(response) {
      this.oAuth = response["access_token"];
      localStorage.setItem("oAuth", this.oAuth);
    },
    selectPatient(patient) {
      this.selectedPatient = patient;
      this.storePatientHistory(patient);
      this.searchQuery = "";
      this.$emit("patient", this.selectedPatient);
    },
    storePatientHistory(patient) {
      const localStorageKey = "recentlyViewedPatients";
      const storedPatients =
        JSON.parse(localStorage.getItem(localStorageKey)) || [];

      const updatedPatients = storedPatients.filter((p) => p.id !== patient.id);
      updatedPatients.unshift(patient);

      if (updatedPatients.length > 8) {
        updatedPatients.pop();
      }

      localStorage.setItem(localStorageKey, JSON.stringify(updatedPatients));

      this.recentlyViewedPatients = updatedPatients;
    },
    fetchAllPatients() {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      };

      fetch("/fhir/api/patient/all", requestOptions)
        .then((response) => response.json())
        .then((result) => {
          this.patients = result;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
  },
};
</script>
