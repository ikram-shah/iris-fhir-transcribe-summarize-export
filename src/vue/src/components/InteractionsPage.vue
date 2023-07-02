<template>
  <div class="container mx-auto p-8">
    <div>
      <div class="bg-white rounded-lg p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Basic Details Column -->
          <div>
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">
              Basic Details
            </h2>
            <div class="space-y-4">
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">First Name:</p>
                <p class="text-gray-800">{{ this.activePatient.firstName }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Last Name:</p>
                <p class="text-gray-800">{{ this.activePatient.lastName }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Gender:</p>
                <p class="text-gray-800">{{ this.activePatient.gender }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Date of Birth:</p>
                <p class="text-gray-800">{{ this.activePatient.birthDate }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Address:</p>
                <p class="text-gray-800">
                  {{ this.activePatient.address.line[0] }},
                  {{ this.activePatient.address.city }},
                  {{ this.activePatient.address.state }},
                  {{ this.activePatient.address.postalCode }},
                  {{ this.activePatient.address.country }}
                </p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Phone:</p>
                <p class="text-gray-800">{{ this.activePatient.phone }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Language:</p>
                <p class="text-gray-800">
                  {{ this.activePatient.communicationLanguage }}
                </p>
              </div>
            </div>
          </div>

          <!-- Previous Visits & Observations Column -->
          <div>
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">
              Previous Visits Summary
            </h2>
            <ul class="space-y-2">
              <li v-for="encounter in encounters" :key="encounter.id" class="pb-1">
                <p class="text-gray-800 font-medium mb-2">
                  {{ encounter.type }}
                </p>
                <p class="text-gray-600 mb-2">{{ formatDate(encounter.start) }}</p>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <VoiceRecorder :activePatientData="activePatient" />
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
      selectedPatient: null,
      isLoading: false,
      encounters: [],
    };
  },
  mounted() {
    this.getAllEncounters(this.activePatient.id);
  },
  methods: {
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
          this.encounters = result
            .sort((a, b) => new Date(b.date) - new Date(a.date))
            .slice(0, 3);
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(date) {
      return new Date(date).toLocaleString();
    },
  },
  props: {
    activePatient: {
      type: Object,
      required: true,
    },
  },
};
</script>
