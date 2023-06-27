<template>
  <div class="topbar bg-gray-200 text-gray-800 flex items-center px-4 py-2">
    <div class="flex items-center">
      <img src="../assets/logo.png" alt="Logo" class="w-8 h-8 mr-2" />
      <h1 class="text-xl font-bold">AI Voice to Summary</h1>
    </div>
    <div class="relative flex items-center justify-center flex-grow">
      <input
        v-model="searchQuery"
        id="patientSearch"
        type="text"
        class="form-input block w-1/2 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        placeholder="Enter patient name"
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
          class="py-2 px-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700"
        >
          <div class="flex justify-between">
            <span>{{ patient.firstName }} {{ patient.lastName }}</span>
            <span>{{ patient.id }}</span>
          </div>
        </li>
      </ul>
    </div>
    <div class="flex items-center">
      <button class="flex items-center mr-8">
        <font-awesome-icon icon="fa-cog" class="mr-2"></font-awesome-icon>
        <p>Settings</p>
      </button>
      <button class="flex items-center mr-8">
        <font-awesome-icon icon="fa-home" class="mr-2"></font-awesome-icon>
        <p>Home</p>
      </button>
    </div>
  </div>
  <!-- Main Content -->
  <div class="flex-1 overflow-auto bg-white">
    <slot :activeTopPage="activeTopPage"></slot>
  </div>
</template>

<script>
export default {
  props: {
    activeTopPage: {
      type: String,
      required: true,
    },
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
        return [];
      }
    },
  },
  mounted() {
    this.fetchAllPatients();
  },
  data() {
    return {
      searchQuery: "",
      patients: [],
      selectedPatient: null,
    };
  },
  methods: {
    selectPatient(patient) {
      this.selectedPatient = patient;
      console.log("selected");
      this.searchQuery = "";
      this.$emit("patient", this.selectedPatient);
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