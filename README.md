# Learning Erlang from Claude

A readable companion to the official Erlang/OTP documentation, written with Claude.

With AI assistants writing more of the code, the valuable knowledge is less about syntax and more about concepts and how the runtime actually behaves — the details you need to judge whether plausible-looking code is right. Each chapter has the same shape:

1. **Why it exists** — the concept
2. **The building blocks** — the API, condensed
3. **How the runtime actually does it** — mechanics from the Reference Manual and Efficiency Guide
4. **Plausible but wrong** — code that compiles and passes a happy-path test, and why it fails
5. **Review checklist and sources**

All chapters were checked against the OTP 29.1.1 documentation. Start with the [Introduction](md/00-Introduction.md); when reviewing code, use the [Review Cheat Sheet](md/14-Review-Cheat-Sheet.md).

**Companion book:** [Learning Elixir from Claude](https://github.com/ayarodionov/Learning-Elixir-From-Claude) covers what Elixir adds on top of the runtime: pattern matching, GenServer and Task, supervision with Registry, macros, Mix and releases, ExUnit, types and telemetry.

| # | Chapter | PDF | Markdown |
| --- | --- | --- | --- |
| 0 | Introduction | [pdf](pdf/00-Introduction.pdf) | [md](md/00-Introduction.md) |
| 1 | Supervision Trees | [pdf](pdf/01-Supervision-Trees.pdf) | [md](md/01-Supervision-Trees.md) |
| 2 | Processes and Mailboxes | [pdf](pdf/02-Processes-and-Mailboxes.pdf) | [md](md/02-Processes-and-Mailboxes.md) |
| 3 | Binaries and Memory | [pdf](pdf/03-Binaries-and-Memory.pdf) | [md](md/03-Binaries-and-Memory.md) |
| 4 | ETS | [pdf](pdf/04-ETS.pdf) | [md](md/04-ETS.md) |
| 5 | gen_server and gen_statem | [pdf](pdf/05-gen_server-and-gen_statem.pdf) | [md](md/05-gen_server-and-gen_statem.md) |
| 6 | Distribution | [pdf](pdf/06-Distribution.pdf) | [md](md/06-Distribution.md) |
| 7 | Applications and Releases | [pdf](pdf/07-Applications-and-Releases.pdf) | [md](md/07-Applications-and-Releases.md) |
| 8 | Testing | [pdf](pdf/08-Testing.pdf) | [md](md/08-Testing.md) |
| 9 | Observability | [pdf](pdf/09-Observability.pdf) | [md](md/09-Observability.md) |
| 10 | Schedulers and Performance | [pdf](pdf/10-Schedulers-and-Performance.pdf) | [md](md/10-Schedulers-and-Performance.md) |
| 11 | NIFs and Ports | [pdf](pdf/11-NIFs-and-Ports.pdf) | [md](md/11-NIFs-and-Ports.md) |
| 12 | Elixir Alongside Erlang | [pdf](pdf/12-Elixir-Alongside-Erlang.pdf) | [md](md/12-Elixir-Alongside-Erlang.md) |
| 13 | gen_statem in Depth | [pdf](pdf/13-gen_statem-in-Depth.pdf) | [md](md/13-gen_statem-in-Depth.md) |
| 14 | Review Cheat Sheet | [pdf](pdf/14-Review-Cheat-Sheet.pdf) | [md](md/14-Review-Cheat-Sheet.md) |

## Rebuilding the PDFs

Edit the Markdown in `md/`, then run `tools/build.sh` (all chapters) or `tools/build.sh md/04-ETS.md` (one chapter). It needs `pandoc` and Chromium or Chrome; set `CHROME=/path/to/chrome` if it isn't found automatically.
