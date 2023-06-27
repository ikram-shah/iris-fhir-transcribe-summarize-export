<template>
  <div class="container mx-auto p-8">
    <EasyDataTable
      :headers="headers"
      :items="observations"
      :rows-per-page="10"
      table-class-name="custom-table" 
    >
    </EasyDataTable>
  </div>
</template>

<script>
export default {
  data() {
    return {
      observations: [],
      headers: [
        { text: "ID", value: "id" },
        { text: "Date", value: "date", sortable: true },
        { text: "Observation Code", value: "code", sortable: true },
        { text: "Value", value: "value", sortable: true },
        { text: "Unit", value: "uom" },
        { text: "Category", value: "category", sortable: true },
      ],
    };
  },
  mounted() {
    console.log(this.activePatient.id);
    this.getAllObservationsForID(this.activePatient.id);
  },
  props: {
    activePatient: {
      type: Object,
      required: true,
    },
  },
  methods: {
    getAllObservationsForID(id) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      };

      fetch(`/fhir/api/patient/${id}/Observation`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          this.observations = result;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(dateTime) {
      const date = new Date(dateTime);
      return date.toLocaleDateString();
    },
  },
};
</script>

<style>
.custom-table {
  --easy-table-header-background-color: #F3F4F6;
  --easy-table-body-row-font-size: 15px;
  --easy-table-body-row-height: 50px;
}
</style>
