<template>
  <div>
    <div class="flex m-6">
      <button class="flex items-center justify-center bg-blue-500 text-white text-l font-medium py-2 px-4 rounded-md"
        @click="handleButtonClick">
        <font-awesome-icon class="text-white mr-2" icon="microphone" />
        Take Notes
      </button>
      <div v-if="isRecording" class="flex items-center justify-center ml-4">
        <div class="rounded-full h-4 w-4 bg-red-500 mr-2"></div>
        <p class="text-gray-600">Recording...</p>
      </div>
    </div>

    <div v-if="isLoading" role="status" class="flex m-6">
      <svg aria-hidden="true" class="w-8 h-8 mr-2 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
        viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path
          d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
          fill="currentColor" />
        <path
          d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
          fill="currentFill" />
      </svg>
      <div class="flex">
        <span class="sr-only"></span>
        <span>Loading...</span>
      </div>
    </div>

    <div v-if="transcription && summary" class="flex m-6">
      <div class="w-1/2 pr-4">
        <h2 class="text-xl font-semibold mb-4">Title</h2>
        <textarea class="w-full h-14 p-4 bg-gray-100 rounded-lg mb-4" v-model="summaryTitle"></textarea>
        <h2 class="text-xl font-semibold mb-4">Summary</h2>
        <textarea class="w-full h-48 p-4 bg-gray-100 rounded-lg mb-4" v-model="summary"></textarea>
        <div class="flex">
          <button class="px-4 py-2 bg-blue-500 text-white rounded-lg"
            @click="saveDocument(this.summary, this.summaryTitle)">
            Save as Document
          </button>
        </div>
      </div>
      <div class="w-1/2 pl-4">
        <h2 class="text-xl font-semibold mb-4">Transcript</h2>
        <div class="bg-gray-100 p-4 rounded-lg h-80 overflow-auto">
          <p>{{ transcription }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isRecording: false,
      mediaRecorder: null,
      chunks: [],
      transcription: "",
      summary: "",
      summaryTitle: "",
      isLoading: false,
    };
  },
  props: {
    activePatientData: {
      type: Object,
      required: true,
    },
  },
  methods: {
    handleButtonClick() {
      if (this.isRecording === false) {
        this.isRecording = true;
        this.startRecording();
      } else {
        this.isRecording = false;
        this.stopRecording();
      }
    },
    async startRecording() {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          audio: true,
        });
        this.mediaRecorder = new MediaRecorder(stream);
        this.mediaRecorder.start();

        this.mediaRecorder.ondataavailable = (event) => {
          this.chunks.push(event.data);
        };
        this.isRecording = true;
      } catch (error) {
        console.error("Error starting recording:", error);
      }
    },
    async sendAudioToWhisper(blob) {
      const apiKey = process.env.OPENAI_API_KEY;
      const formData = new FormData();
      formData.append("file", blob);
      formData.append("model", "whisper-1");
      formData.append("response_format", "json");
      formData.append("temperature", "0");
      formData.append("language", "en");

      try {
        const response = await fetch(
          "https://api.openai.com/v1/audio/transcriptions",
          {
            method: "POST",
            headers: {
              Accept: "application/json",
              Authorization: `Bearer ${apiKey}`,
            },
            body: formData,
            redirect: "follow",
          }
        );

        const data = await response.json();
        if (data.text) {
          this.transcription = data.text;
        }
      } catch (error) {
        console.error("Error sending audio to Whisper API:", error);
      }

      return this.transcription;
    },
    getSummary(transcription) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var raw = JSON.stringify({ text: transcription });

      var requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: raw,
        redirect: "follow",
      };

      fetch(`/fhir/api/summarize`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          this.isLoading = false;
          this.summaryTitle = result.title;
          this.summary = result.summary;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(dateTime) {
      const date = new Date(dateTime);
      return date.toLocaleDateString();
    },
    stopRecording() {
      if (this.mediaRecorder) {
        this.isLoading = true;
        this.mediaRecorder.stop();
        this.mediaRecorder.onstop = async () => {
          const blob = new Blob(this.chunks, {
            type: "audio/webm;codecs=opus",
          });
          await this.sendAudioToWhisper(
            new File([blob], `file${Date.now()}.m4a`)
          );

          this.getSummary(this.transcription);
        };
      }
    },
    saveDocument(summary, title) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      const blob = {
        'summary': summary,
        'title': title
      }

      var raw = JSON.stringify({
        //todo: patient ID and practitioner ID
        patientId: this.activePatientData.id,
        practitionerId: process.env.PRACTITIONER_ID,
        base64payload: btoa(JSON.stringify(blob)),
        mimeType: "application/json",
      });

      var requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: raw,
        redirect: "follow",
      };

      fetch(`/fhir/api/documentreference`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          if (result.id) {
            alert("✅ Document added successfully!");
            this.transcription = "";
            this.summary = "";
            this.summaryTitle = "";
          } else {
            alert("🚩 Document addition failed");
          }
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
  },
};
</script>
