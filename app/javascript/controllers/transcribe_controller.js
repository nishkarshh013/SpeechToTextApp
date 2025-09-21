import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transcribe"
export default class extends Controller {
  static targets = ["live", "full", "startBtn", "stopBtn", "summary"]

  connect() {
    this.recognition = null
    this.fullTranscript = ""
    this.isRecording = false
    // feature detect
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SpeechRecognition) {
      this.liveTarget.innerText = "Web Speech API not supported in this browser. Use Chrome or Edge."
      this.startBtnTarget.disabled = true
      return
    }

    this.recognition = new SpeechRecognition()
    this.recognition.continuous = true
    this.recognition.interimResults = true
    this.recognition.lang = "en-US" // adjust as needed

    this.recognition.onresult = (event) => {
      let interim = ""
      let final = ""
      for (let i = event.resultIndex; i < event.results.length; ++i) {
        const res = event.results[i]
        if (res.isFinal) final += res[0].transcript + " "
        else interim += res[0].transcript + " "
      }
      // live shows interim + final
      this.liveTarget.innerText = (this.fullTranscript + final + " " + interim).trim()
      if (final.trim().length) {
        this.fullTranscript += final
        this.fullTarget.innerText = this.fullTranscript.trim()
      }
    }

    this.recognition.onerror = (e) => {
      console.error("Speech recognition error", e)
    }

    this.recognition.onend = () => {
      this.isRecording = false
      this.startBtnTarget.disabled = false
      this.stopBtnTarget.disabled = true
    }
  }

  start() {
    if (!this.recognition) return
    try {
      this.fullTranscript = ""
      this.liveTarget.innerText = "Listening..."
      this.fullTarget.innerText = ""
      this.summaryTarget.innerText = ""
      this.recognition.start()
      this.isRecording = true
      this.startBtnTarget.disabled = true
      this.stopBtnTarget.disabled = false
    } catch (e) {
      console.error("Could not start recognition", e)
    }
  }

  async stop() {
    if (!this.recognition || !this.isRecording) return
    this.recognition.stop()
    this.isRecording = false
    this.startBtnTarget.disabled = false
    this.stopBtnTarget.disabled = true

    // Ensure live shows final
    this.liveTarget.innerText = this.fullTranscript.trim()
    this.fullTarget.innerText = this.fullTranscript.trim()

    // Send final transcript to backend
    debugger;
    try {
      const resp = await fetch("/transcriptions", {
        method: "POST",
        headers: { "Content-Type": "application/json", "Accept": "application/json" },
        body: JSON.stringify({ text: this.fullTranscript.trim() })
      })
      if (!resp.ok) {
        const err = await resp.json().catch(()=>({error: resp.statusText}))
        this.summaryTarget.innerText = `Error saving transcription: ${err.error || resp.statusText}`
        return
      }
      const data = await resp.json()
      const id = data.id
      // fetch summary
      this.summaryTarget.innerText = "Generating summary..."
      const sresp = await fetch(`/summary/${id}`)
      if (!sresp.ok) {
        const err = await sresp.json().catch(()=>({error: sresp.statusText}))
        this.summaryTarget.innerText = `Error generating summary: ${err.error || sresp.statusText}`
        return
      }
      const summaryJson = await sresp.json()
      this.summaryTarget.innerText = summaryJson.summary || "No summary returned"
    } catch (e) {
      console.error(e)
      this.summaryTarget.innerText = `Network error: ${e.message}`
    }
  }
}
