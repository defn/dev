<script lang="ts">
  interface ProgressUpdate {
    type: "tool_call" | "text";
    name?: string;
    text?: string;
  }

  let fileName = $state("");
  let content = $state("");
  let lineCount = $state(0);
  let wordCount = $state(0);
  let charCount = $state(0);
  let serverConnected = $state(false);
  let serverLoading = $state(true); // Start as loading until we know status
  let serverStartTime = $state(0);
  let serverPid = $state(0);
  let uptimeSeconds = $state(0);
  let alucardResponse = $state("");
  let alucardLoading = $state(false);
  let alucardSummoned = $state(false); // Track if we've ever summoned Alucard
  let currentIncantation = $state(""); // The incantation being sent
  let progressUpdates = $state<ProgressUpdate[]>([]); // Progress updates during loading

  // Update uptime every second
  setInterval(() => {
    if (serverStartTime > 0) {
      uptimeSeconds = Math.floor(Date.now() / 1000 - serverStartTime);
    }
  }, 1000);

  function formatUptime(seconds: number): string {
    if (seconds < 60) return `${seconds}s`;
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    if (mins < 60) return `${mins}m ${secs}s`;
    const hours = Math.floor(mins / 60);
    const remainingMins = mins % 60;
    return `${hours}h ${remainingMins}m`;
  }

  // Listen for messages from the extension
  window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.type === "update") {
      fileName = message.fileName;
      content = message.content;
      // Store incantation (first line) for display
      currentIncantation = content.split("\n")[0] || fileName;
      // Stats are only calculated by the server, so wait for stats message
    } else if (message.type === "stats") {
      serverConnected = true;
      serverLoading = false;
      if (message.stats) {
        lineCount = message.stats.lines;
        wordCount = message.stats.words;
        charCount = message.stats.characters;
      }
    } else if (message.type === "serverInfo") {
      serverConnected = true;
      serverLoading = false;
      serverStartTime = message.server_start_time || 0;
      serverPid = message.server_pid || 0;
      uptimeSeconds = Math.floor(Date.now() / 1000 - serverStartTime);
    } else if (message.type === "serverStatus") {
      serverConnected = message.connected;
      serverLoading = false; // We got a definitive status
      if (!message.connected) {
        serverStartTime = 0;
        serverPid = 0;
        uptimeSeconds = 0;
      }
    } else if (message.type === "summoning") {
      // Server is sending the alucard request
      currentIncantation = message.incantation || "";
      alucardLoading = true;
      alucardSummoned = true;
      progressUpdates = []; // Clear previous progress
    } else if (message.type === "progress") {
      // Agent progress update
      if (message.progress) {
        progressUpdates = [...progressUpdates, message.progress];
      }
    } else if (message.type === "alucard") {
      alucardResponse = message.alucard_response || "";
      alucardLoading = false;
      progressUpdates = []; // Clear progress on completion
    }
  });
</script>

<main class="min-h-screen p-6 bg-abyss-950">
  <!-- Header with Hellsing emblem feel -->
  <header class="mb-8 border-b border-blood-800 pb-4">
    <div class="flex items-center gap-4">
      <!-- Pentagram/cross icon -->
      <div class="w-12 h-12 flex items-center justify-center rounded-full bg-blood-900 border-2 border-blood-600 shadow-blood">
        <svg class="w-6 h-6 text-blood-400" viewBox="0 0 24 24" fill="currentColor">
          <path d="M12 2L9 9H2l6 4.5L5.5 22 12 17l6.5 5-2.5-8.5L22 9h-7z"/>
        </svg>
      </div>
      <div>
        <h1 class="font-hellsing text-2xl font-bold tracking-wider text-blood-400 uppercase">
          {fileName || "No File Selected"}
        </h1>
        <p class="text-abyss-400 text-sm tracking-wide">The Vampire's Codex</p>
      </div>
    </div>
  </header>

  <!-- Stats bar -->
  <div class="flex flex-wrap gap-4 mb-8 p-4 bg-abyss-900/50 rounded-lg border border-abyss-700">
    <div class="flex items-center gap-2">
      <span class="text-blood-500 font-bold text-lg">{lineCount}</span>
      <span class="text-abyss-400 text-sm uppercase tracking-wider">lines</span>
    </div>
    <div class="w-px h-6 bg-abyss-700"></div>
    <div class="flex items-center gap-2">
      <span class="text-blood-500 font-bold text-lg">{wordCount}</span>
      <span class="text-abyss-400 text-sm uppercase tracking-wider">words</span>
    </div>
    <div class="w-px h-6 bg-abyss-700"></div>
    <div class="flex items-center gap-2">
      <span class="text-blood-500 font-bold text-lg">{charCount}</span>
      <span class="text-abyss-400 text-sm uppercase tracking-wider">chars</span>
    </div>
    <div class="ml-auto flex items-center gap-2">
      {#if serverConnected}
        <span class="w-2 h-2 rounded-full bg-blood-500 animate-pulse"></span>
        <span class="text-abyss-300 text-xs">
          PID:{serverPid} | {formatUptime(uptimeSeconds)}
        </span>
      {:else if serverLoading}
        <span class="w-2 h-2 rounded-full bg-gold-500 animate-pulse"></span>
        <span class="text-gold-400 text-xs">AWAKENING...</span>
      {:else}
        <span class="w-2 h-2 rounded-full bg-abyss-600"></span>
        <span class="text-abyss-500 text-xs">DISCONNECTED</span>
      {/if}
    </div>
  </div>

  <!-- Alucard's Chamber -->
  <section class="mb-8 relative">
    <!-- Decorative corner elements -->
    <div class="absolute -top-2 -left-2 w-8 h-8 border-t-2 border-l-2 border-blood-600"></div>
    <div class="absolute -top-2 -right-2 w-8 h-8 border-t-2 border-r-2 border-blood-600"></div>
    <div class="absolute -bottom-2 -left-2 w-8 h-8 border-b-2 border-l-2 border-blood-600"></div>
    <div class="absolute -bottom-2 -right-2 w-8 h-8 border-b-2 border-r-2 border-blood-600"></div>

    <div class="bg-gradient-to-b from-blood-900/30 to-abyss-900/80 p-6 rounded border border-blood-800">
      <div class="flex items-center gap-3 mb-4">
        <div class="w-10 h-10 rounded-full bg-blood-800 flex items-center justify-center border border-blood-600">
          <!-- Bat/vampire icon -->
          <svg class="w-5 h-5 text-blood-400" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 3c-1.5 0-2.8.5-3.8 1.4-.3-.1-.6-.2-1-.3C4.5 3.4 2 5.5 2 8c0 1.5.7 2.9 1.8 3.8-.5.9-.8 2-.8 3.2 0 3.3 2.7 6 6 6h6c3.3 0 6-2.7 6-6 0-1.2-.3-2.3-.8-3.2 1.1-.9 1.8-2.3 1.8-3.8 0-2.5-2.5-4.6-5.2-3.9-.4.1-.7.2-1 .3C14.8 3.5 13.5 3 12 3z"/>
          </svg>
        </div>
        <h2 class="font-hellsing text-xl font-semibold text-blood-300 tracking-widest uppercase">
          Alucard Speaks
        </h2>
      </div>

      <div class="min-h-[120px] flex items-center">
        {#if alucardLoading}
          <div class="flex flex-col gap-3 text-abyss-400 w-full">
            <div class="flex items-center gap-3">
              <div class="flex gap-1">
                <span class="w-2 h-2 bg-blood-600 rounded-full animate-bounce" style="animation-delay: 0ms"></span>
                <span class="w-2 h-2 bg-blood-600 rounded-full animate-bounce" style="animation-delay: 150ms"></span>
                <span class="w-2 h-2 bg-blood-600 rounded-full animate-bounce" style="animation-delay: 300ms"></span>
              </div>
              <span class="italic text-blood-400">Summoning the No-Life King...</span>
            </div>
            <div class="text-sm text-abyss-500 pl-6 border-l-2 border-abyss-700">
              Incantation: <span class="text-abyss-300 font-mono">"{currentIncantation}"</span>
            </div>
            {#if progressUpdates.length > 0}
              <div class="mt-2 space-y-1 pl-6 border-l-2 border-blood-800">
                {#each progressUpdates as update}
                  {#if update.type === "tool_call"}
                    <div class="text-xs flex items-center gap-2">
                      <span class="text-blood-500">⚡</span>
                      <span class="text-abyss-400">Invoking dark power:</span>
                      <span class="text-blood-400 font-mono">{update.name}</span>
                    </div>
                  {:else if update.type === "text"}
                    <div class="text-xs text-abyss-300 italic">
                      {update.text?.slice(0, 100)}{update.text && update.text.length > 100 ? "..." : ""}
                    </div>
                  {/if}
                {/each}
              </div>
            {/if}
          </div>
        {:else if alucardResponse}
          <blockquote class="relative pl-6 border-l-4 border-blood-600">
            <span class="absolute -left-3 -top-2 text-5xl text-blood-800 font-serif">"</span>
            <p class="text-xl italic leading-relaxed text-abyss-100 font-light">
              {alucardResponse}
            </p>
            <span class="absolute -right-1 -bottom-4 text-5xl text-blood-800 font-serif">"</span>
          </blockquote>
        {:else if !alucardSummoned}
          <!-- Show nothing until first summon -->
        {/if}
      </div>

      <!-- Blood drip decoration -->
      <div class="flex justify-center mt-6 gap-8 opacity-40">
        <div class="w-1 h-8 bg-gradient-to-b from-blood-600 to-transparent rounded-full"></div>
        <div class="w-1 h-12 bg-gradient-to-b from-blood-600 to-transparent rounded-full"></div>
        <div class="w-1 h-6 bg-gradient-to-b from-blood-600 to-transparent rounded-full"></div>
      </div>
    </div>
  </section>

  <!-- Source Code Section -->
  <details class="group">
    <summary class="cursor-pointer p-4 bg-abyss-900/50 rounded-t-lg border border-abyss-700 hover:bg-abyss-800/50 transition-colors flex items-center gap-3">
      <svg class="w-4 h-4 text-abyss-400 transition-transform group-open:rotate-90" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
      </svg>
      <span class="text-abyss-300 uppercase tracking-wider text-sm font-medium">
        Source Manuscript
      </span>
      <span class="text-abyss-500 text-xs">({lineCount} lines of mortal code)</span>
    </summary>
    <div class="border border-t-0 border-abyss-700 rounded-b-lg overflow-hidden">
      <pre class="p-4 bg-abyss-900/80 overflow-x-auto text-sm"><code class="text-abyss-200 font-mono">{content}</code></pre>
    </div>
  </details>

  <!-- Footer -->
  <footer class="mt-12 pt-4 border-t border-abyss-800 text-center">
    <p class="text-abyss-600 text-xs tracking-widest uppercase">
      Hellsing Organization - Code Division
    </p>
  </footer>
</main>
