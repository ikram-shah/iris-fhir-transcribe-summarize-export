<template>
    <div>
      <label for="patient-search">Search Patient:</label>
      <input
        id="patient-search"
        type="text"
        v-model="searchTerm"
        @input="searchPatients"
        placeholder="Enter patient name or ID"
      />
      <ul v-if="searchResults.length > 0">
        <li v-for="patient in searchResults" :key="patient[0]" @click="selectPatient(patient)">
          {{ patient[1] }} {{ patient[2] }} (ID: {{ patient[0] }})
        </li>
      </ul>
      <div v-else-if="isLoading">
        Loading patients...
      </div>
      <div v-else>
        No patients found.
      </div>
      <div v-if="selectedPatient">
        <h2>Selected Patient:</h2>
        <p>Name: {{ selectedPatient[1] }} {{ selectedPatient[2] }}</p>
        <p>ID: {{ selectedPatient[0] }}</p>
      </div>
    </div>
  </template>

<script>
export default {
  data() {
    return {
      searchTerm: "",
      searchResults: [],
      allPatients: [],
      selectedPatient: null,
      isLoading: false,
    };
  },
  mounted() {
    this.fetchAllPatients();
  },

  methods: {
    fetchAllPatients() {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      };

      fetch("/fhir/api/patient/all", requestOptions)
        .then((response) => response.text())
        .then((result) => {
          this.allPatients = this.parseResponseData(result);
          this.isLoading = false;
        })
        .catch((error) => {
          console.log("error", error);
          this.isLoading = false;
        });
    },
    parseResponseData(data) {
      // Parse the received data and transform it into an array of arrays
      // based on the assumption that each patient record is separated by a newline
      const lines = data.trim().split("\n");
      return lines.map((line) => line.split(",").map((item) => item.trim()));
    },
    searchPatients() {
      if (this.searchTerm === "") {
        this.searchResults = [];
      } else {
        const searchTermLC = this.searchTerm.toLowerCase();
        this.searchResults = this.allPatients.filter((patient) => {
          const name = `${patient[1]} ${patient[2]}`.toLowerCase();
          const id = patient[0].toLowerCase();
          return name.includes(searchTermLC) || id.includes(searchTermLC);
        });
      }
    },
    selectPatient(patient) {
      this.selectedPatient = patient;
      this.searchTerm = "";
      this.searchResults = [];
    },
  },
};
</script>
