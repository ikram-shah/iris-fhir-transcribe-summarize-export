<template>
  <div class="container mx-auto p-8">
    <h1 class="text-4xl font-bold mb-8">Observations</h1>

    <!-- Patient search -->
    <div class="mb-4">
      <label
        class="block text-gray-700 text-sm font-bold mb-2"
        for="patientSearch"
      >
        Search Patient:
      </label>
      <div class="relative inline-block w-1/2">
        <input
          v-model="searchQuery"
          id="patientSearch"
          type="text"
          class="form-input block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Enter patient name"
        />
        <div
          v-if="showDropdown && filteredPatients.length > 0"
          class="absolute left-0 right-0 mt-1 bg-white border border-gray-300 rounded-md shadow-lg"
        >
          <ul class="py-2 text-sm text-gray-700">
            <li
              v-for="patient in filteredPatients"
              :key="patient.id"
              class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
              @click="selectPatient(patient)"
            >
              {{ patient.name }}
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Observations list -->
    <div v-if="selectedPatient">
      <h2 class="text-lg font-bold mt-4 mb-4">{{ selectedPatient.name }}</h2>

      <div v-if="filteredObservations.length > 0">
        <ul class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          <li
            v-for="observation in filteredObservations"
            :key="observation.id"
            class="bg-white p-6 rounded-lg shadow-md"
          >
            <div class="flex justify-between mb-4">
              <h3 class="text-base font-bold">{{ observation.title }}</h3>
              <span class="text-gray-500">{{ observation.date }}</span>
            </div>
            <div class="text-gray-600">{{ observation.description }}</div>
            <div class="mt-4">
              <div class="flex space-x-2">
                <span
                  v-for="tag in observation.tags"
                  :key="tag"
                  class="inline-block px-3 py-1 bg-blue-100 text-blue-800 rounded-full"
                  >{{ tag }}</span
                >
              </div>
            </div>
          </li>
        </ul>
      </div>

      <div v-else>
        <p class="text-lg text-gray-500">
          No observations found for the selected patient.
        </p>
      </div>

      <!-- Button for voice recording -->
      <div class="mt-6">
        <button
          @click="startVoiceRecording"
          class="bg-blue-600 hover:bg-blue-800 text-white font-medium py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          Add Observation via Voice Recording
        </button>
      </div>
    </div>

    <!-- No patient selected message -->
    <div v-else>
      <p class="text-lg text-gray-500">
        Please enter a patient name to search.
      </p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      patients: [
        { id: 1, name: "John Doe" },
        { id: 2, name: "Jane Smith" },
        // Add more patient data as needed
      ],
      observations: [
        {
          id: 1,
          title: "Blood Pressure",
          date: "2022-12-15",
          description: "Patient's blood pressure observation",
          tags: ["Vital Sign", "Blood Pressure"],
          patientId: 1,
        },
        {
          id: 2,
          title: "Heart Rate",
          date: "2022-12-16",
          description: "Patient's heart rate observation",
          tags: ["Vital Sign", "Heart Rate"],
          patientId: 1,
        },
        {
          id: 3,
          title: "Temperature",
          date: "2022-12-17",
          description: "Patient's body temperature observation",
          tags: ["Vital Sign", "Temperature"],
          patientId: 2,
        },
        // Add more observation data as needed
      ],
      searchQuery: "",
      showDropdown: false,
      selectedPatient: null,
    };
  },
  computed: {
    filteredPatients() {
      if (this.searchQuery === "") {
        return [];
      }
      return this.patients.filter((patient) =>
        patient.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    },
    filteredObservations() {
      if (!this.selectedPatient) {
        return [];
      }
      return this.observations.filter(
        (observation) => observation.patientId === this.selectedPatient.id
      );
    },
  },
  methods: {
    selectPatient(patient) {
      this.selectedPatient = patient;
      this.showDropdown = false;
      this.searchQuery = "";
    },
    startVoiceRecording() {
      // Add your logic to start voice recording here
    },
  },
  watch: {
    searchQuery(newQuery) {
      if (newQuery.length > 0) {
        this.showDropdown = true;
      } else {
        this.showDropdown = false;
      }
    },
  },
};
</script>
