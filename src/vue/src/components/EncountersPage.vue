<template>
  <div class="container m-8 p-8">
    <!-- Search Bar -->
    <div class="w-1/2 mb-8">
      <input
        v-model="searchTerm"
        type="text"
        placeholder="Search by encounter type or practitioner name"
        class="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>

    <!-- Encounters Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div
        v-for="encounter in filteredEncounters"
        :key="encounter.id"
        class="bg-white shadow-md rounded-md p-4"
      >
        <!-- Most Important Content - Encounter Type -->
        <div class="text-lg font-bold mb-2">{{ encounter.type }}</div>

        <!-- Other Details -->
        <div class="text-sm text-gray-500 mb-2">
          {{ encounter.practitionerName }} ({{ encounter.practitionerId }})
        </div>
        <div class="flex justify-between mb-2">
          <div class="text-sm text-gray-500 mb-2">
            Start: {{ formatDate(encounter.start) }}
          </div>
          <div class="text-sm text-gray-500 mb-2">
            End: {{ formatDate(encounter.end) }}
          </div>
        </div>
        <div class="text-sm text-gray-500">ID: {{ encounter.id }}</div>
        <div class="text-sm text-gray-500">
          Updated On: {{ formatDate(encounter.updatedDate) }}
        </div>
      </div>
    </div>

    <!-- No Results Message -->
    <div v-if="filteredEncounters.length === 0" class="justify-between text-left">
      No results found.
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      encounters: [],
      searchTerm: "",
    };
  },
  props: {
    activePatient: {
      type: Object,
      required: true,
    },
  },
  mounted() {
    this.getAllEncounters(this.activePatient.id);
  },
  computed: {
    filteredEncounters() {
      const searchTerm = this.searchTerm.toLowerCase().trim();
      if (!searchTerm) {
        return this.encounters;
      }
      return this.encounters.filter(
        (encounter) =>
          encounter.type.toLowerCase().includes(searchTerm) ||
          encounter.practitionerName.toLowerCase().includes(searchTerm)
      );
    },
  },
  methods: {
    formatDate(date) {
      return new Date(date).toLocaleString();
    },
    getAllEncounters(id) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      };

      fetch(`/fhir/api/patient/${id}/Encounter`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          this.encounters = result;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
  },
};
</script>
