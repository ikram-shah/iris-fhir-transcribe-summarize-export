<template>
  <div class="container mx-auto p-16">
    <!-- Previous Documents -->
    <div class="mt-4 grid grid-cols-1 gap-8">
      <div v-for="document in documents" :key="document.id"
        class="bg-white shadow-md rounded p-4 flex items-center justify-between">
        <div class="flex-grow">
          <h3 class="text-lg font-medium pl-4 pb-2">{{ document.title }}</h3>
          <p class="mb-6 pl-4">
            {{ trimText(document.summary) }}
          </p>
          <div class="items-center text-gray-500 text-sm m-2">
            <p class="m-2">ID: {{ document.id }}</p>
            <p class="m-2">
              Updated On: {{ formatDate(document.updatedDate) }}
            </p>
            <p class="m-2">Added By: {{ document.practitionerId }}</p>
          </div>
        </div>
        <button @click="createDocument(document.title, document.summary)">
          <font-awesome-icon icon="fa-file-text" class="m-4 w-8 h-8 text-blue-500"></font-awesome-icon>
        </button>
        <button @click="openAsPDF(document.title, document.summary)">
          <font-awesome-icon icon="fa-external-link-alt" class="m-4 w-6 h-6"></font-awesome-icon>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { PDFDocument, StandardFonts } from "pdf-lib";

export default {
  data() {
    return {
      documents: [],
      searchQuery: "",
      searchResults: [],
      oAuth: ""
    };
  },
  props: {
    activePatient: {
      type: Object,
      required: true,
    },
  },
  mounted() {
    this.getDocuments(this.activePatient.id);
    this.oAuth = localStorage.getItem('oAuth');
  },
  methods: {
    createDocument(title, summary) {
      const requestOptions = {
        method: "POST",
        headers: {
          Authorization: "Basic U3VwZXJVc2VyOlNZUw==",
        },
        body: JSON.stringify({
          patientId: this.activePatient.id,
          title: title,
          body: btoa(summary),
          token: this.oAuth,
        }),
      };

      fetch(`/fhir/api/exportDocument`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          if (result.status == "Updated doc with text successfully.") {
            let docURL = this.createGoogleDocLink(result.googleDocId);
            this.$swal({
              icon: "success",
              title: "Created Google Docs Successfully.",
              html: `<a href="${docURL}" target="_blank">${docURL}</a>`,
              confirmButtonText: "Close",
              confirmButtonColor: "#2563EB",
            });
          } else {
            this.$swal({
              icon: "error",
              title: "Google docs creation failed.",
              confirmButtonText: "Close",
              confirmButtonColor: "#2563EB",
            });
          }
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    createGoogleDocLink(docId) {
      const baseUrl = "https://docs.google.com/document/d/";
      const link = `${baseUrl}${docId}`;
      return link;
    },
    async openAsPDF(title, summary) {
      const pdfDoc = await PDFDocument.create();
      const page = pdfDoc.addPage();
      const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
      const fontSize = 12;

      const margin = 50;
      const availableWidth = page.getWidth() - 2 * margin;

      const lines = [];
      const words = summary.split(" ");

      lines.push(title);
      lines.push("");

      let currentLine = words[0];
      for (let i = 1; i < words.length; i++) {
        const word = words[i];
        const width = font.widthOfTextAtSize(
          currentLine + " " + word,
          fontSize
        );
        if (width < availableWidth) {
          currentLine += " " + word;
        } else {
          lines.push(currentLine);
          currentLine = word;
        }
      }
      lines.push(currentLine);

      const startY = page.getHeight() - margin;
      let currentY = startY;
      for (const line of lines) {
        page.drawText(line, { x: margin, y: currentY, size: fontSize, font });
        currentY -= fontSize;
      }

      const pdfBytes = await pdfDoc.save();
      const data = new Blob([pdfBytes], { type: "application/pdf" });
      const url = URL.createObjectURL(data);

      window.open(url, "_blank");
    },
    performSearch() {
      // Simulating semantic search by filtering documents based on the search query
      const query = this.searchQuery.toLowerCase().trim();
      this.searchResults = [];

      if (query.length > 0) {
        this.documents.forEach((document) => {
          const title = document.title.toLowerCase();
          if (title.includes(query)) {
            this.searchResults.push({
              id: document.id,
              title: document.title,
              source: "Sample Source",
              documents: [document],
            });
          }
        });
      }
    },
    trimText(text) {
      let trimmedText = text.slice(0, 125);
      if (text.length > 100) {
        trimmedText += "...";
      }
      return trimmedText;
    },
    getDocuments(id) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      };

      fetch(`/fhir/api/patient/${id}/DocumentReference`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          const documents = result;
          for (let i = 0; i < documents.length; i++) {
            const blob = JSON.parse(atob(documents[i].base64payload));
            documents[i]['summary'] = blob.summary;
            documents[i]['title'] = blob.title;
          }
          this.documents = documents;
          console.log(documents)
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(dateString) {
      return new Date(dateString).toLocaleString();
    },
  },
};
</script>

<style>
/* Add Tailwind CSS classes or custom styles here */
</style>
