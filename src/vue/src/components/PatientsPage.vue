<template>
  <div class="container mx-auto p-8">
    <h1 class="text-4xl font-bold mb-8">Patients</h1>

    <!-- Export options -->
    <div class="mt-6 mb-6">
      <div class="flex space-x-4">
        <button ref="googleLoginBtn" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md">
          Export to Google Sheets
        </button>
        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md">
          Export to Airtable
        </button>
        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md">
          Export to PDF
        </button>
      </div>
    </div>

    <!-- Search input -->
    <div class="mb-8">
      <label for="search" class="text-gray-600">Search Patients</label>
      <div class="relative">
        <input type="text" id="search" v-model="searchQuery" placeholder="Enter a patient name or ID"
          class="w-1/2 px-4 py-2.5 rounded-md border border-gray-300 focus:outline-none focus:border-blue-600" />
        <button v-if="searchQuery" @click="clearSearch"
          class="absolute top-0 right-0 mt-3 mr-3 text-gray-500 hover:text-gray-700 focus:outline-none">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zM9 4a1 1 0 012 0v7a1 1 0 11-2 0V4zM8 14a1 1 0 012 0v1a1 1 0 11-2 0v-1z"
              clip-rule="evenodd"></path>
          </svg>
        </button>
      </div>
    </div>

    <!-- Patient list -->
    <div v-if="filteredPatients.length > 0">
      <ul class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
        <li v-for="patient in filteredPatients" :key="patient.id" class="bg-white p-6 rounded-lg shadow-md">
          <div class="flex justify-between mb-4">
            <h2 class="text-lg">
              <span class="font-bold mr-2">{{ patient.firstName }}</span>
              <span class=""> {{ patient.lastName }}</span>
            </h2>
            <span class="text-gray-500">{{ patient.id }}</span>
          </div>
          <div class="flex justify-left mb-4">
            <div class="text-gray-600 mr-6">{{ patient.gender }}</div>
            <div class="text-gray-600">{{ patient.birthDate }}</div>
          </div>

        </li>
      </ul>
    </div>

    <!-- No patients found message -->
    <div v-else>
      <p class="text-lg text-gray-500">No patients found.</p>
    </div>
  </div>
</template>

<script>
export default {
  mounted() {
    this.fetchAllPatients();
    this.loginInit(this.gClientId);
  },
  data() {
    return {
      patients: [],
      searchQuery: "",
      gClientId: '701611997086-4lm9753lipuddaq7i89gj1uq2p9rv6i9.apps.googleusercontent.com'
    };
  },
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
        return this.patients;
      }
    },
  },
  methods: {
    clearSearch() {
      this.searchQuery = "";
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
          this.isLoading = false;
        })
        .catch((error) => {
          console.log("error", error);
          this.isLoading = false;
        });
    },
    loginInit(gClientId) {
      this.gClient = window.google.accounts.oauth2.initTokenClient({
        client_id: gClientId,
        scope: 'https://www.googleapis.com/auth/documents',
        callback: this.handleOauthToken,
      })
      window.google.accounts.id.initialize({
        client_id: gClientId,
        callback: this.handleCredentialResponse,
      })
      window.google.accounts.id.renderButton(
        this.$refs.googleLoginBtn, {
        text: 'Login',
        size: 'large',
        theme: 'filled_blue' // option : filled_black | outline | filled_blue
      })
    },
    async handleCredentialResponse(response) {
      try {
        this.gClient.requestAccessToken();
        console.log(response)
      } catch (error) {
        //on fail do something
        if (error) console.error(error);
        else console.error(error);
        return null;
      }
    },
    async handleOauthToken(response) {
      try {
        this.oAuth = response['access_token'];
        localStorage.setItem("oAuth", this.oAuth);
        var myHeaders = new Headers();
        myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

        var requestOptions = {
          method: "POST",
          headers: myHeaders,
          body: JSON.stringify({ patientId: 1, docId: 1921, token: this.oAuth })
        };
        fetch("/fhir/api/exportDocument", requestOptions)
          .then(response => response.json())
        window.alert("created doc")
      } catch (error) {
        //on fail do something
        if (error) console.error(error);
        else console.error(error);
        return null;
      }
    },
  }
};
</script>
