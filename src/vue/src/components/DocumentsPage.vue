<template>
  <div class="container mx-auto p-16">
    <!-- Previous Documents -->
    <button
      ref="googleLoginBtn"
      class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md"
    >
      Export to Google Sheets
    </button>
    <div class="mt-4 grid grid-cols-2 gap-8">
      <div
        v-for="document in documents"
        :key="document.id"
        class="bg-white shadow-md rounded p-4 flex items-center justify-between"
      >
        <div class="flex-grow">
          <h3 class="text-lg font-medium">{{ document.title }}</h3>
          <p class="mb-6 pl-4">
            {{ trimText(document.base64payload) }}
          </p>
          <div class="items-center text-gray-500 text-sm m-2">
            <p class="m-2">ID: {{ document.id }}</p>
            <p class="m-2">
              Updated On: {{ formatDate(document.updatedDate) }}
            </p>
            <p class="m-2">Added By: {{ document.practitionerId }}</p>
          </div>
        </div>
        <button @click="createDocument(document.base64payload)">
          <font-awesome-icon
            icon="fa-file-text"
            class="m-4 w-8 h-8 text-blue-500"
          ></font-awesome-icon>
        </button>
        <button @click="openAsPDF(document.base64payload)">
          <font-awesome-icon
            icon="fa-external-link-alt"
            class="m-4 w-6 h-6"
          ></font-awesome-icon>
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
      gClientId: process.env.G_CLIENT_ID,
      documents: [],
      searchQuery: "",
      searchResults: [],
    };
  },
  props: {
    activePatient: {
      type: Object,
      required: true,
    },
  },
  mounted() {
    this.loginInit(this.gClientId);
    this.getDocuments(this.activePatient.id);
  },
  methods: {
    loginInit(gClientId) {
      this.initGoogleOAuth(gClientId);
      this.renderGoogleLoginButton();
    },
    initGoogleOAuth(gClientId) {
      this.gClient = window.google.accounts.oauth2.initTokenClient({
        client_id: gClientId,
        scope: "https://www.googleapis.com/auth/documents",
        callback: this.handleOauthToken,
      });
      window.google.accounts.id.initialize({
        client_id: gClientId,
        callback: this.handleCredentialResponse,
      });
    },
    renderGoogleLoginButton() {
      window.google.accounts.id.renderButton(this.$refs.googleLoginBtn, {
        text: "Login",
        size: "large",
        theme: "filled_blue", // options: filled_black | outline | filled_blue
      });
    },
    async handleCredentialResponse(response) {
      try {
        this.gClient.requestAccessToken();
        console.log(response);
      } catch (error) {
        console.error(error);
      }
    },
    async handleOauthToken(response) {
      this.oAuth = response["access_token"];
      localStorage.setItem("oAuth", this.oAuth);
    },
    encodeBase64(string) {
      const bytes = new TextEncoder().encode(string);
      const base64String = btoa(String.fromCharCode.apply(null, bytes));
      return base64String;
    },
    createDocument(content) {
      const requestOptions = {
        method: "POST",
        headers: {
          Authorization: "Basic U3VwZXJVc2VyOlNZUw==",
        },
        body: JSON.stringify({
          patientId: 1,
          title: "Title",
          body: this.encodeBase64(content),
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
    async openAsPDF(textContent) {
      const pdfDoc = await PDFDocument.create();
      const page = pdfDoc.addPage();
      const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
      const fontSize = 12;

      const margin = 50;
      const availableWidth = page.getWidth() - 2 * margin;

      const lines = [];
      const words = textContent.split(" ");

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
          this.documents = result;
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
