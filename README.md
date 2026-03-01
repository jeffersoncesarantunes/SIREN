# 🐧 S.I.R.E.N. - Shell Interactive Runtime Entity Notifier

High-speed forensic memory acquisition tool focused on live streaming and integrity validation.

    Project: S.I.R.E.N. (Shell Interactive Runtime Entity Notifier)  
    Author: Jefferson Cesar Antunes  
    License: MIT  
    Version: 1.3.0  
    Description: Forensic Memory Streamer & Real-time Integrity Auditor for Linux.

● Etymology & Origin

The name S.I.R.E.N. is a recursive acronym that reflects the tool's dual nature: an alert system and a data harvester.

In forensic mythology, the Siren calls for the truth hidden within the depths. In this context, it symbolizes the systematic notification (Entity Notifier) of memory states during runtime. It acts as a digital beacon, ensuring that even as data is streamed (Runtime Entity), its integrity remains monitored and auditable, sounding the 'alarm' if any hardware-reserved zone or kernel restriction is breached.

● Overview

S.I.R.E.N. is a specialized forensic utility designed for high-speed memory acquisition and real-time integrity auditing.

It bypasses traditional file-first dumping by implementing a streaming pipeline that allows analysts to:

    Identify safe System RAM regions.
    Perform live forensic exfiltration via network sockets.
    Calculate integrity hashes (SHA256) and extract strings simultaneously.

The tool is written in pure Bash, ensuring zero-dependency operation in emergency incident response scenarios.

● How It Works

S.I.R.E.N. interfaces with the Linux Kernel through the /proc/iomem interface and the /dev/mem character device.

The acquisition logic follows a non-destructive path:

1.  **Memory Mapping:** It parses /proc/iomem to differentiate between 'System RAM' and reserved hardware offsets.
2.  **Streaming Pipeline:** Instead of temporary files, it uses process substitution and pipes to feed data into sha256sum and strings in parallel.
3.  **Network Exfiltration:** It leverages Netcat (nc) to stream raw memory blocks directly to a remote workstation.

All inspection is designed to minimize the forensic footprint on the target system.

● Example Output

┌────────────────────────────────────────────────────────┐
│ [+] Mapping safe System RAM regions...                 │
├────────────────────────────────────────────────────────┤
│ Address: 00001000-0009fbff [SAFE RANGE]                │
│ Address: 00100000-b697efff [SAFE RANGE]                │
│ Address: b6b5f000-b6b5ffff [SAFE RANGE]                │
└────────────────────────────────────────────────────────┘
[!] Starting acquisition from: /dev/mem
[+] Pipeline completed successfully. Results in ../dumps

● Remote Forensic Streaming (Option 5)

This feature allows the extraction of RAM without writing a large file to the target's local disk (Zero-Footprint approach).

1. **On Forensic Workstation (Receiver):**
```bash
nc -l -p 4444 > remote_mem_dump.bin
```

2. **On Target Machine (S.I.R.E.N.):**
Select Option 5, enter the IP and Port. The script streams data while generating a local hash for verification.

● Critical Safety: The "ACTION REQUIRED" Warning

When performing Option 3 (Live Memory Extraction), the system accesses /dev/mem.

> **IMPORTANT:** Selecting Option 3 triggers a mandatory confirmation. To prevent a **System Freeze**, the user must acknowledge that they are bypassing reserved memory ranges. Selecting option 3 (Ignore) or following safe offsets prevents system freezing.

● Features

    Remote Exfiltration via Netcat.
    Live SHA256 integrity auditing.
    Real-time string extraction.
    Pre-acquisition disk space verification.
    /proc/iomem safe-range mapping.
    STRICT_DEVMEM restriction detection.

● Operational Integrity

S.I.R.E.N. is designed for forensic stability:

    Read-only access to system memory devices.
    Parallel processing to reduce I/O wait times.
    No modification of kernel structures or process states.
    Graceful termination upon kernel-level access denial.

● Investigation Workflow

After a successful dump or stream, analysts may proceed with:

1. **Integrity Verification:**
```bash
sha256sum -c dump_filename.sha256
```

2. **Forensic String Search:**
```bash
grep -Ei "pass|user|config" mem_strings.txt
```

3. **Hexadecimal Inspection:**
```bash
hexdump -C mem_dump.bin | head -n 20
```

● Deployment

**Requirements:**
- Linux OS with root privileges.
- Netcat (for remote exfiltration).
- Bash 4.x or higher.

**Build and Execute:**
```bash
git clone https://github.com/jeffersoncesarantunes/S.I.R.E.N.git
cd S.I.R.E.N
chmod +x src/siren.sh
sudo ./src/siren.sh
```

● Troubleshooting: Kernel Restrictions

If the dump stops at exactly **1.0MB** or you see `[DENIED BY KERNEL]`, your kernel is protected by `CONFIG_STRICT_DEVMEM`.

To bypass this for forensic purposes, add `iomem=relaxed` to your boot parameters (GRUB/systemd-boot) and reboot.

● Tech Stack

    Language: Bash Script
    Data Source: /dev/mem, /proc/iomem
    Utilities: dd, sha256sum, strings, nc

● Roadmap

    Automated safe-range extraction (Beta optimization).
    Integrated RAM compression during exfiltration.
    Support for Lime/LiME memory drivers.
    JSON metadata report generation.

● License

Distributed under the MIT License. See LICENSE for details.
