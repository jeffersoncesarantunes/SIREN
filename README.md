# 🐧 S.I.R.E.N. - Shell Interactive Runtime Entity Notifier

High-speed forensic memory acquisition tool focused on live streaming and integrity validation.

> **Project:** S.I.R.E.N. (Shell Interactive Runtime Entity Notifier)  
> **Author:** Jefferson Cesar Antunes  
> **License:** MIT  
> **Version:** 1.3.0  
> **Description:** Forensic Memory Streamer & Real-time Integrity Auditor for Linux.

## ● Key Features
- **Remote Exfiltration:** (New) Stream raw memory data to a remote forensic workstation via Netcat.
- **Forensic Pipeline:** Integrated SHA256 hashing and string extraction during acquisition.
- **Pre-Acquisition Storage Check:** Automatically verifies if your disk has enough space to hold the RAM dump.
- **Kernel-Aware Mapping:** Identifies safe "System RAM" ranges to avoid hardware-reserved zones.
- **Enhanced Error Handling:** Detects kernel-level access denials (STRICT_DEVMEM) and network failures.

## ● Quick Start

### 1. Clone & Access
```bash
git clone https://github.com/jeffersoncesarantunes/S.I.R.E.N.git && cd S.I.R.E.N
```

### 2. Set Permissions & Run (Requires Root)
```bash
chmod +x src/siren.sh
sudo ./src/siren.sh
```

---

## ● Remote Forensic Streaming (Option 5)

This feature allows the extraction of RAM without writing a large file to the target's local disk (Zero-Footprint approach).

### 1. On Forensic Workstation (Receiver):
Prepare the "digital evidence bag" to receive the stream:
```bash
nc -l -p 4444 > remote_mem_dump.bin
```

### 2. On Target Machine (S.I.R.E.N.):
Select **Option 5**, enter the Workstation IP and Port (4444). The script will stream the data and generate a local SHA256 hash for integrity comparison.

---

## ● Critical Safety: The "ACTION REQUIRED" Warning

When performing **Option 3 (Live Memory Extraction)**, the system accesses `/dev/mem`. 

> **IMPORTANT:** Selecting Option 3 triggers a mandatory confirmation. To prevent a **System Freeze**, the user must acknowledge that they are bypassing reserved memory ranges. Selecting option 3 (Ignore) or following safe offsets prevents system freezing.

## ● Post-Analysis Tools

Once a dump is generated, you can perform deep analysis using external tools:

### 1. Integrity Verification
```bash
sha256sum -c dump_filename.sha256
```

### 2. Forensic String Search
```bash
grep -Ei "pass|user|config" mem_strings.txt
```

### 3. Hexadecimal Inspection
```bash
hexdump -C mem_dump.bin | head -n 20
```

---

## ● Troubleshooting: Kernel Restrictions

If the dump stops at exactly **1.0MB** or you see `[DENIED BY KERNEL]`, your kernel is protected by `CONFIG_STRICT_DEVMEM`.

To bypass this for forensic purposes:

1. Edit your GRUB configuration (`/etc/default/grub`).
2. Add `iomem=relaxed` to the `GRUB_CMDLINE_LINUX_DEFAULT` line.
3. Update GRUB and reboot:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
> **Note:** For **systemd-boot** or **rEFInd**, add `iomem=relaxed` to your specific loader configuration. A reboot is mandatory for changes to take effect.
