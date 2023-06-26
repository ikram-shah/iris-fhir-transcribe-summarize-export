<template>
  <div class="container mx-auto p-8">
    <h1 class="text-4xl font-bold mb-8">Settings</h1>

    <!-- Practitioner selection -->
    <div class="mb-6">
      <label
        class="block text-gray-700 text-sm font-bold mb-2"
        for="practitionerSelect"
      >
        Select Practitioner:
      </label>
      <div class="relative inline-block w-1/3">
        <select
          v-model="selectedPractitioner"
          id="practitionerSelect"
          class="form-select block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="">Select Practitioner</option>
          <option
            v-for="practitioner in practitioners"
            :key="practitioner.id"
            :value="practitioner.id"
          >
            {{ practitioner.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- FHIR server selection -->
    <div class="mb-6">
      <label
        class="block text-gray-700 text-sm font-bold mb-2"
        for="fhirServerSelect"
      >
        Select FHIR Server:
      </label>
      <div class="relative inline-block w-1/3">
        <select
          v-model="selectedFhirServer"
          id="fhirServerSelect"
          class="form-select block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="">Select FHIR Server</option>
          <option
            v-for="server in fhirServers"
            :key="server.id"
            :value="server.id"
          >
            {{ server.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- Other settings -->
    <!-- Add other settings components here -->

    <!-- Save button -->
    <div>
      <button
        @click="saveSettings"
        class="bg-blue-600 hover:bg-blue-800 text-white font-medium py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        Save Settings
      </button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      practitioners: [
        { id: 1, name: "Dr. John Doe" },
        { id: 2, name: "Dr. Jane Smith" },
        // Add more practitioner data as needed
      ],
      fhirServers: [
        { id: 1, name: "FHIR Server 1" },
        { id: 2, name: "FHIR Server 2" },
        // Add more FHIR server data as needed
      ],
      selectedPractitioner: "",
      selectedFhirServer: "",
    };
  },
  methods: {
    saveSettings() {
      // Add your logic to save the selected practitioner and FHIR server here
    },
  },
};
</script>
