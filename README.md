# 📡 shibuya-airwave-ghost
**Wireless, RF, Bluetooth & Social Engineering Operations | 無線LAN・RF・ソーシャルエンジニアリング演習**

Part of **Project JP Violet Synapse** — a bilingual offensive security portfolio mapped to **CompTIA PenTest+ (PT0-003)**.

## 🗂️ Modules / モジュール構成
* `01-wifi-recon/airwave_scanner.sh` — Monitor mode (`wlp2s0mon`) & `airodump-ng` perimeter discovery
* `02-handshake-capture/handshake_audit.sh` — Targeted BSSID 4-way handshake capture & `hashcat` (`-m 22000`) audit
* `03-rf-bluetooth-audit/rfid_ble_audit.py` — Live `bluetoothctl` BLE recon, Bluejacking/Bluesnarfing triage & RFID audit
* `04-social-engineering/gophish_sim.py` — Shibuya employee spear-phishing & credential harvesting simulation
* `05-perimeter-hardening/harden_airwave.py` — WPA3-SAE, 802.11w PMF, 802.1X EAP-TLS, WIPS & FIDO2 remediation
* `run_airwave_demo.sh` — Multi-window pop-up CLI launcher (`airodump-ng`, `bluetoothctl`, `hashcat`, `bloodhound`)

## 🚀 Usage / 実行方法
```bash
# Safe preview mode (keeps Wi-Fi online)
./run_airwave_demo.sh --demo

# Live monitor mode on wlp2s0 (auto-restores NetworkManager on exit)
sudo ./run_airwave_demo.sh --live
```
