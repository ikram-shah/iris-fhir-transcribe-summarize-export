<template>
  <div class="container mx-auto p-4">
    <!-- Encounters Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div
        v-for="encounter in encounters"
        :key="encounter.id"
        class="bg-white shadow-md rounded-md p-4"
      >
        <!-- Most Important Content - Encounter Type -->
        <div class="text-lg font-bold mb-2">{{ encounter.type }}</div>

        <!-- Other Details -->
        <div class="flex justify-between mb-2">
          <div class="text-sm text-gray-500">
            {{ encounter.practitionerName }}
          </div>
          <div class="text-sm text-gray-500">
            {{ formatDate(encounter.updatedDate) }}
          </div>
        </div>
        <div class="text-sm text-gray-500">{{ encounter.status }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      encounters: [
        {
          id: "4",
          status: "Patient/1",
          type: "General examination of patient (procedure)",
          practitionerId: "Practitioner/3",
          practitionerName: "Dr. Merideth332 Thompson596",
          patientId: "Patient/1",
          patientName: "Mr. Frankie174 Jast432",
          start: "1993-10-05T07:56:49+00:00",
          end: "1993-10-05T08:11:49+00:00",
          updatedDate: "2023-06-26T21:29:22Z",
        },
        {
          id: "5",
          status: "Patient/1",
          type: "General examination of patient (procedure)",
          practitionerId: "Practitioner/3",
          practitionerName: "Dr. Merideth332 Thompson596",
          patientId: "Patient/1",
          patientName: "Mr. Frankie174 Jast432",
          start: "1993-10-05T07:56:49+00:00",
          end: "1993-10-05T08:11:49+00:00",
          updatedDate: "2023-06-26T21:29:22Z",
        },
      ],
      searchQuery: "",
    };
  },
  methods: {
    formatDate(date) {
      return new Date(date).toLocaleDateString();
    },
  },
};
</script>
