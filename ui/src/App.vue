<script setup>
import { ref } from 'vue';
const patients = ref(null);
const requestOptions = {
  method: "GET",
  headers: { "Authorization": "Basic " + btoa(unescape(encodeURIComponent("SuperUser" + ':' + "SYS"))) },
};
fetch('http://localhost:52773/fhir/api/patient/all', requestOptions)
  .then(response => response.json())
  .then(data => patients.value = data);
</script>

<template>
  <h3>Patients</h3>
  <p>
    {{ patients.value }}
  </p>
</template>