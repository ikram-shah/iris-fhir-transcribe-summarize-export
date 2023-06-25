<template>
  <div class="container mx-auto p-4">
    <div class="flex justify-center gap-64 items-center mb-4">
      <HeaderContent />
      <FhirServerDropdown />
    </div>
    <br/>
    <PatientDropdown />
    <PatientProfile />
    <VoiceRecorder />
  </div>
</template>

<script>
import HeaderContent from "./components/HeaderContent.vue";
import PatientDropdown from "./components/PatientDropdown.vue";
import FhirServerDropdown from "./components/FhirServerDropdown.vue";
import PatientProfile from "./components/PatientProfile.vue";
import VoiceRecorder from "./components/VoiceRecorder.vue";

export default {
  components: {
    HeaderContent,
    PatientDropdown,
    FhirServerDropdown,
    PatientProfile,
    VoiceRecorder,
  },
};
</script>
