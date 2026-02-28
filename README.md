# 🐧 S.I.R.E.N. - Shell Interactive Runtime Entity Notifier

S.I.R.E.N. is a high-speed forensic memory acquisition tool designed for Linux systems. It streams physical RAM content directly into an analytical pipeline, performing integrity hashing and string extraction in real-time.

## ● Key Features
- **Forensic Pipeline:** Integrated SHA256 hashing and string extraction during acquisition.
- **Pre-Acquisition Storage Check:** (New) Automatically verifies if your disk has enough space to hold the RAM dump, preventing system instability.
- **Kernel-Aware Mapping:** Identifies safe "System RAM" ranges to avoid hardware-reserved zones.
- **Safety First:** Includes logic to handle kernel-level access denials (STRICT_DEVMEM).

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

## ● Critical Safety: The "ACTION REQUIRED" Warning

When performing **Option 3 (Live Memory Extraction)**, the system accesses `/dev/mem`. 

> **IMPORTANT:** Selecting Option 3 triggers a mandatory confirmation. To prevent a **System Freeze**, the user must acknowledge that they are bypassing reserved memory ranges. Selecting option 3 (Ignore) or following safe offsets prevents system freezing.

## ● Features

* **Memory Mapping:** Identifies safe `System RAM` ranges vs. dangerous `Reserved` regions via `/proc/iomem`.
* **Live Pipeline:** Streams data through `sha256sum` and `strings` simultaneously to minimize I/O overhead.
* **Forensic Integrity:** Generates SHA-256 hashes for every dump to ensure evidence chain of custody.
* **Kernel Awareness:** Detects `STRICT_DEVMEM` restrictions and provides diagnostic feedback.

## ● Post-Analysis Tools

Once a dump is generated in the `dumps/` directory, you can perform deep analysis:

### 1. Integrity Verification

```bash
sha256sum -c dump_filename.sha256

```

### 2. Forensic Grep

```bash

grep -Ei "pass|user|config" mem_strings.txt

```

### 3. Hexadecimal Inspection

```bash

hexdump -C mem_dump.bin | head -n 20

```
---

## ● Troubleshooting: Kernel Restrictions

If you see `[DENIED BY KERNEL]` during Option 4, it means your Linux Kernel is protected by `CONFIG_STRICT_DEVMEM`.

To bypass this for educational or forensic purposes:

1. Edit your GRUB configuration (`/etc/default/grub`).
2. Add `iomem=relaxed` to the `GRUB_CMDLINE_LINUX_DEFAULT` line.
3. Update GRUB and reboot:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg

```
> **Note for other Bootloaders:** If you use **systemd-boot**, **rEFInd**, or others, ensure `iomem=relaxed` is added to your specific boot configuration (e.g., `loader.conf`). A system reboot is always required for kernel changes to take effect. Please save your work before restarting.
