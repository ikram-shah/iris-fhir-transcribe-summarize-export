<template>
  <div class="container w-1/2 p-16">
    <!-- Previous Documents -->
    <div>
      <h2 class="text-xl font-semibold mb-4">Previous Documents</h2>
      <ul class="space-y-4">
        <li
          v-for="document in documents"
          :key="document.id"
          class="bg-white shadow-md rounded p-4 flex items-center justify-between"
        >
          <div class="flex-grow">
            <h3 class="text-lg font-medium">{{ document.title }}</h3>
            <div class="flex items-center space-x-4 text-gray-500 text-sm mt-2">
              <p>{{ formatDate(document.uploadedDate) }}</p>
              <p>Uploaded by {{ document.uploadedBy }}</p>
            </div>
          </div>
          <button class="px-4 py-2 rounded" @click="openDocument(document.id)">
            <font-awesome-icon
              icon="fa-external-link-alt"
              class="mr-2"
            ></font-awesome-icon>
          </button>
        </li>
      </ul>
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
