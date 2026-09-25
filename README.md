# Learning Erlang from Claude

A readable companion to the official Erlang/OTP documentation, written with Claude.

With AI assistants writing more of the code, the valuable knowledge is less about syntax and more about concepts and how the runtime actually behaves — the details you need to judge whether plausible-looking code is right. Each chapter has the same shape:

1. **Why it exists** — the concept
2. **The building blocks** — the API, condensed
3. **How the runtime actually does it** — mechanics from the Reference Manual and Efficiency Guide
4. **Plausible but wrong** — code that compiles and passes a happy-path test, and why it fails
5. **Review checklist and sources**

All chapters were checked against the OTP 29.1.1 documentation.

| # | Chapter | PDF | Markdown |
| --- | --- | --- | --- |
| 1 | Supervision Trees | [pdf](pdf/01-Supervision-Trees.pdf) | [md](md/01-Supervision-Trees.md) |
| 2 | Processes and Mailboxes | [pdf](pdf/02-Processes-and-Mailboxes.pdf) | [md](md/02-Processes-and-Mailboxes.md) |
| 3 | Binaries and Memory | [pdf](pdf/03-Binaries-and-Memory.pdf) | [md](md/03-Binaries-and-Memory.md) |
| 4 | ETS | [pdf](pdf/04-ETS.pdf) | [md](md/04-ETS.md) |
| 5 | gen_server and gen_statem | [pdf](pdf/05-gen_server-and-gen_statem.pdf) | [md](md/05-gen_server-and-gen_statem.md) |
| 6 | Distribution | [pdf](pdf/06-Distribution.pdf) | [md](md/06-Distribution.md) |
