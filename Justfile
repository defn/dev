coder-agent *host:
  cd m && exec setsid just coder::coder-agent {{host}} &

