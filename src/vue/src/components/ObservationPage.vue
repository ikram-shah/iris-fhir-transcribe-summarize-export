<template>
  <div class="container p-16">
    <button
      class="flex items-center justify-center bg-green-600 mb-4 text-white text-l font-medium py-2 px-4 rounded-md"
      @click="exportToSheets()"
    >
      <font-awesome-icon
        icon="fa-file-excel"
        class="w-5 h-5 mr-2 text-white"
      ></font-awesome-icon>
      Export to Google Sheets
    </button>
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
      oAuth: ""
    };
  },
  mounted() {
    this.getAllObservationsForID(this.activePatient.id);
    this.oAuth = localStorage.getItem('oAuth');
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
    convertToGoogleSheetsFormat(data) {
      const headers = ["id", "date", "code", "value", "uom", "category"];
      const rows = data.map((item) => [
        item.id,
        item.date,
        item.code,
        item.value,
        item.uom,
        item.category,
      ]);

      rows.unshift(headers);

      return (rows);
    },
    createGoogleSheetsLink(sheetId) {
      const baseUrl = "https://docs.google.com/spreadsheets/d/";
      const link = `${baseUrl}${sheetId}`;
      return link;
    },
    exportToSheets() {
      const requestOptions = {
        method: "POST",
        headers: {
          Authorization: "Basic U3VwZXJVc2VyOlNZUw==",
        },
        body: JSON.stringify({
          patientId: this.activePatient.id,
          title: "Observations",
          rows: this.convertToGoogleSheetsFormat(this.observations),
          token: this.oAuth,
        }),
      };

      fetch(`/fhir/api/exportSheet`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          if (result.status == "Updated sheet with rows successfully.") {
            let docURL = this.createGoogleSheetsLink(result.googleSheetId);
            this.$swal({
              icon: "success",
              title: "Created Google Sheets Successfully.",
              html: `<a href="${docURL}" target="_blank">${docURL}</a>`,
              confirmButtonText: "Close",
              confirmButtonColor: "#2563EB",
            });
          } else {
            this.$swal({
              icon: "error",
              title: "Google sheets creation failed.",
              confirmButtonText: "Close",
              confirmButtonColor: "#2563EB",
            });
          }
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
  --easy-table-header-background-color: #f3f4f6;
  --easy-table-body-row-font-size: 15px;
  --easy-table-body-row-height: 50px;
}
</style>
