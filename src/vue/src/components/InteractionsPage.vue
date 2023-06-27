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
                <p class="text-gray-600 font-bold w-32">Name:</p>
                <p class="text-gray-800">{{ patient.name }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Gender:</p>
                <p class="text-gray-800">{{ patient.gender }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Date of Birth:</p>
                <p class="text-gray-800">{{ patient.birthDate }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Address:</p>
                <p class="text-gray-800">{{ patient.address }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Phone:</p>
                <p class="text-gray-800">{{ patient.phone }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Email:</p>
                <p class="text-gray-800">{{ patient.email }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Marital Status:</p>
                <p class="text-gray-800">{{ patient.maritalStatus }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Language:</p>
                <p class="text-gray-800">{{ patient.language }}</p>
              </div>
              <div class="flex">
                <p class="text-gray-600 font-bold w-32">Ethnicity:</p>
                <p class="text-gray-800">{{ patient.ethnicity }}</p>
              </div>
            </div>
          </div>

          <!-- Previous Visits & Observations Column -->
          <div>
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">
              Previous Visits Summary
            </h2>
            <ul class="space-y-2">
              <li v-for="visit in patient.previousVisits" :key="visit.id">
                <p class="text-gray-800 font-semibold">{{ visit.date }}</p>
                <p class="text-gray-600">{{ visit.reason }}</p>
              </li>
            </ul>
            <hr class="mt-6 mb-6" />
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">
              Observations Summary
            </h2>
            <ul class="space-y-2">
              <li v-for="observation in patient.observations" :key="observation.id">
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
      selectedPatient: null,
      isLoading: false,
    };
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
        previousVisits: [
          {
            id: 1,
            date: "2022-02-01",
            reason: "Routine check-up",
          },
          {
            id: 2,
            date: "2022-08-15",
            reason: "Flu symptoms",
          },
        ],
        observations: [
          {
            id: 1,
            date: "2022-02-01",
            description: "Blood pressure: 120/80 mmHg",
          },
          {
            id: 2,
            date: "2022-08-15",
            description: "Heart rate: 75 bpm",
          },
        ],
      }),
    },
  },
};
</script>
