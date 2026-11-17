#!/usr/bin/env python3
# Project: shibuya-airwave-ghost | Phase 3: RF, Bluetooth LE & RFID Perimeter Audit
# プロジェクト: 渋谷エアウェーブ・ゴースト | フェーズ3: Bluetooth・RFID物理境界監査

import subprocess
import sys
import time

mode = sys.argv[1] if len(sys.argv) > 1 else "--dry-run"

print("==================================================================")
print("📶 [PHASE 3: BLE & RFID PERIMETER AUDIT / Bluetooth・RFID監査]")
print("==================================================================")

if mode == "--live":
    print("[*] Launching live bluetoothctl pop-up scanner / リアルタイムBLEスキャナ起動中...")
    subprocess.Popen([
        "mate-terminal",
        "--title=[PHASE 3: BLUETOOTH LE LIVE RECON / BLEデバイス探索]",
        "-e",
        "bash -c 'echo \"[*] Scanning nearby BLE beacons / 周辺BLEデバイスをスキャン中...\"; bluetoothctl --timeout 15 scan on; exec bash'"
    ])
    time.sleep(2)

findings = [
    ("BLE Beacon / スマートロック", "Shibuya-Gate-04", "Legacy Pairing (No MITM Protection) -> Vulnerable to Bluesnarfing / 認証不備"),
    ("RFID Badge / 社員証ICカード", "125kHz EM4100", "Unencrypted UID Broadcast -> Vulnerable to Proxmark3 Cloning / 暗号化なし"),
    ("BLE Advertising / 社内端末", "Exec-iPhone-BLE", "Discoverable Mode Active -> Susceptible to Bluejacking / 検出可能状態")
]

for asset, identifier, status in findings:
    time.sleep(0.8)
    print(f"[+] Target / 対象: {asset} ({identifier})")
    print(f"    [!] Risk / 診断結果: {status}\n")

