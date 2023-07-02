<template>
  <div class="container mx-auto p-16">
    <!-- AI Semantic Search -->
    <div>
      <h2 class="text-xl font-semibold mb-4">AI Semantic Search</h2>
      <div class="flex">
        <input
          v-model="searchQuery"
          class="border flex rounded w-1/2 px-4 py-2 focus:outline-none focus:ring-2 mr-2 focus:ring-blue-500"
          placeholder="Enter search query"
          @keyup.enter="searchContents()"
        />
        <button
          class="items-center justify-center bg-blue-500 text-white ml-2 py-2 px-2 rounded-md"
          @click="handleButtonClick"
        >
          Search
        </button>
      </div>

      <div v-if="searchResponse" class="mt-6">
        <h3 class="text-lg font-medium mb-2 mt-2">{{ this.searchResponse }}</h3>
        <h3 class="text-m font-medium mb-2 mt-2">Source:</h3>
        <ul class="m-2">
          <li v-for="(docId, index) in sourceDocIds" :key="index" class="mb-2">
            <a
              @click="showDocumentContent(docId)"
              class="text-blue-500 hover:underline"
              >{{ docId }}</a
            >
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchQuery: "",
      searchResponse: "",
      sourceDocIds: [],
    };
  },
  methods: {
    async showDocumentContent(docId) {
      try {
        const { title, description } = await this.getDocumentDetails(docId);
        
        this.$swal({
          title: title,
          text: description,
          confirmButtonText: "Close",
          confirmButtonColor: "#2563EB",
        });
      } catch (error) {
        console.log("error", error);
      }
    },
    async getDocumentDetails(id) {
      try {
        const myHeaders = new Headers();
        myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

        const requestOptions = {
          method: "GET",
          headers: myHeaders,
          redirect: "follow",
        };

        const response = await fetch(
          `/fhir/api/documentReference/${id}`,
          requestOptions
        );
        const result = await response.json();
        const documents = result[0];
        const blob = JSON.parse(atob(documents.base64payload));
        return { title: blob.title, description: blob.summary };
      } catch (error) {
        throw new Error(error);
      }
    },
    searchContents() {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: JSON.stringify({
          query: this.searchQuery,
        }),
        redirect: "follow",
      };

      fetch(`/fhir/api/queryDocs`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          this.searchResponse = result.response;
          this.sourceDocIds = result.sourceDocIds;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(dateString) {
      const options = { year: "numeric", month: "long", day: "numeric" };
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
  },
};
</script>

<style>
/* Add Tailwind CSS classes or custom styles here */
</style>
