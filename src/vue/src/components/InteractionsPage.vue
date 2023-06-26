<template>
  <div class="container mx-auto p-8">
    <h1 class="text-4xl font-bold mb-8">Interactions</h1>

    <div class="mb-6">
      <label
        class="block text-gray-700 text-sm font-bold mb-2"
        for="patientSearch"
      >
        Search Patient:
      </label>
      <div class="relative inline-block w-full">
        <input
          v-model="searchTerm"
          id="patientSearch"
          type="text"
          class="form-input block w-1/2 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Enter patient name"
        />
      </div>
      <ul
        v-if="searchResults.length > 0"
        class="mt-2 bg-white border border-gray-300 rounded-lg shadow-md dark:bg-gray-800"
      >
        <li
          v-for="patient in searchResults"
          :key="patient[0]"
          @click="selectPatient(patient)"
          :class="{ 'text-blue-500': patient === selectedPatient }"
          class="py-2 px-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700"
        >
          {{ patient[1] }} {{ patient[2] }} (ID: {{ patient[0] }})
        </li>
      </ul>
      <div v-else-if="isLoading" class="mt-2 text-gray-600 dark:text-gray-400">
        Loading patients...
      </div>
      <div v-else class="mt-2 text-gray-600 dark:text-gray-400">
        No patients found.
      </div>
    </div>
    <div v-if="selectedPatient">
        <div class="bg-white shadow rounded-lg p-6">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Basic Details Column -->
      <div>
        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Basic Details</h2>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Name:</p>
          <p class="text-gray-800 text-lg">{{ patient.name }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Gender:</p>
          <p class="text-gray-800 text-lg">{{ patient.gender }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Date of Birth:</p>
          <p class="text-gray-800 text-lg">{{ patient.birthDate }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Address:</p>
          <p class="text-gray-800 text-lg">{{ patient.address }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Phone:</p>
          <p class="text-gray-800 text-lg">{{ patient.phone }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Email:</p>
          <p class="text-gray-800 text-lg">{{ patient.email }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Marital Status:</p>
          <p class="text-gray-800 text-lg">{{ patient.maritalStatus }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Language:</p>
          <p class="text-gray-800 text-lg">{{ patient.language }}</p>
        </div>
        <div class="mb-4">
          <p class="text-gray-600 font-bold">Ethnicity:</p>
          <p class="text-gray-800 text-lg">{{ patient.ethnicity }}</p>
        </div>
      </div>

      <!-- Previous Visits & Observations Column -->
      <div>
        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Previous Visits</h2>
        <ul class="mb-6">
          <li v-for="visit in patient.previousVisits" :key="visit.id" class="mb-2">
            <p class="text-gray-800 font-semibold">{{ visit.date }}</p>
            <p class="text-gray-600">{{ visit.reason }}</p>
          </li>
        </ul>

        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Observations</h2>
        <ul>
          <li v-for="observation in patient.observations" :key="observation.id" class="mb-2">
            <p class="text-gray-800 font-semibold">{{ observation.date }}</p>
            <p class="text-gray-600">{{ observation.description }}</p>
          </li>
        </ul>
      </div>
    </div>
  </div>
  <VoiceRecorder />
    </div>
   
  </div>
</template>

<script>
import VoiceRecorder from "./VoiceRecorder.vue";

export default {
  components: {
    VoiceRecorder,
  },
  data() {
    return {
      searchTerm: "",
      searchResults: [],
      allPatients: [
        ["1", "O'Hara248", "Carroll471", "1954-06-13", "male"],
        ["172", "Jast432", "Frankie174", "1975-08-12", "male"],
        ["459", "Rohan584", "Gabriele201", "2009-05-04", "female"],
        ["705", "Frami345", "Kallie862", "1945-12-19", "female"],
        ["1002", "Davis923", "Lean294", "1945-12-19", "female"],
        ["1510", "Hettinger594", "Margie619", "1995-03-26", "female"],
      ],
      selectedPatient: null,
      isLoading: false,
    };
  },
  methods: {
    search() {
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
  watch: {
    searchTerm: function (newTerm) {
      if (newTerm === "") {
        this.searchResults = [];
      } else {
        const searchTermLC = newTerm.toLowerCase();
        this.searchResults = this.allPatients.filter((patient) => {
          const name = `${patient[1]} ${patient[2]}`.toLowerCase();
          const id = patient[0].toLowerCase();
          return name.includes(searchTermLC) || id.includes(searchTermLC);
        });
      }
    },
  },
  props: {
    patient: {
      type: Object,
      required: true,
      default: () => ({
        name: "John Doe",
        gender: "Male",
        birthDate: "1970-01-01",
        address: "123 Main St, Anytown, USA",
        phone: "123-456-7890",
        email: "johndoe@example.com",
        maritalStatus: "Single",
        language: "English",
        ethnicity: "Caucasian",
        // Add more patient data fields here based on the FHIR standard
      }),
    },
  },
};
</script>
