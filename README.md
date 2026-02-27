# 🐧 S.I.R.E.N. - Shell Interactive Runtime Entity Notifier

S.I.R.E.N. is a high-speed forensic memory acquisition tool designed for Linux systems. It streams physical RAM content directly into an analytical pipeline, performing integrity hashing and string extraction in real-time.

## 🚨 Critical Safety: The "ACTION REQUIRED" Warning

When performing **Option 3 (Live Memory Extraction)**, the system accesses `/dev/mem`. 

> **IMPORTANT:** Selecting Option 3 triggers a mandatory confirmation. To prevent a **System Freeze**, the user must acknowledge that they are bypassing reserved memory ranges. By limiting the acquisition to known `System RAM` offsets (mapped via Option 1) or using controlled block sizes (as implemented in our `dd` pipeline), the system remains stable.

## 🛠 Features

* **Memory Mapping:** Identifies safe `System RAM` ranges vs. dangerous `Reserved` regions via `/proc/iomem`.
* **Live Pipeline:** Streams data through `sha256sum` and `strings` simultaneously to minimize I/O overhead.
* **Forensic Integrity:** Generates SHA-256 hashes for every dump to ensure evidence chain of custody.

## 🔍 Post-Analysis Tools

Once a dump is generated in the `dumps/` directory, you can perform deep analysis using external tools:

### 1. Integrity Verification
Ensure the dump hasn't been tampered with:
```bash
sha256sum -c dump_filename.sha256
