import { spawn } from "bun"

let startedByPlugin = false

export default async ({ $ }) => {
  // Check if Ollama is already running
  const isRunning = await $`pgrep -x ollama`.quiet().nothrow()

  if (isRunning.exitCode !== 0) {
    console.log("Starting Ollama server...")
    // Use Bun's spawn for background process
    spawn(["ollama", "serve"], {
      stdout: "ignore",
      stderr: "ignore",
    })
    startedByPlugin = true
    // Wait for server to be ready
    for (let i = 0; i < 30; i++) {
      const ready = await $`curl -s http://127.0.0.1:11434/api/tags`.quiet().nothrow()
      if (ready.exitCode === 0) break
      await new Promise(r => setTimeout(r, 1000))
    }
    console.log("Ollama server ready")
  }

  return {
    async shutdown() {
      if (startedByPlugin) {
        console.log("Stopping Ollama server...")
        await $`pkill ollama`.quiet().nothrow()
      }
    }
  }
}
