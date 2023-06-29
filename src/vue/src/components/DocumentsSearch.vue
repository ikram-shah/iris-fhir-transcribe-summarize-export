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
          @keyup.enter="performSearch()"
        />
        <button
          class="items-center justify-center bg-blue-500 text-white ml-2 py-2 px-2 rounded-md"
          @click="handleButtonClick"
        >
          Search
        </button>
      </div>

      <div v-if="searchResults.length > 0" class="mt-6">
        <h3 class="text-lg font-medium mb-2">Search Results</h3>
        <div class="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-2 gap-6">
          <div
            v-for="result in documents"
            :key="result.id"
            class="bg-white shadow-md rounded p-4 flex justify-between"
          >
            <div class="flex-grow">
              <h3 class="text-lg font-medium">{{ result.title }}</h3>
              <div
                class="flex items-center space-x-4 text-gray-500 text-sm mt-2"
              >
                <p>{{ result.uploadedDate }}</p>
                <p>Uploaded by {{ result.uploadedBy }}</p>
              </div>
            </div>
            <button
              class="px-4 py-2 rounded"
              @click="openDocument(result.id)"
            >
              <font-awesome-icon
                icon="fa-external-link-alt"
                class="mr-2"
              ></font-awesome-icon>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      documents: [
        {
          id: 1,
          title: "Sample Document 1",
          uploadedDate: "2023-06-01",
          uploadedBy: "John Doe",
        },
        {
          id: 2,
          title: "Sample Document 2",
          uploadedDate: "2023-06-15",
          uploadedBy: "Jane Smith",
        },
      ],
      searchQuery: "",
      searchResults: [],
    };
  },
  methods: {
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
