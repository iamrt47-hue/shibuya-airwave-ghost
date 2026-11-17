#!/bin/bash
# Project: shibuya-airwave-ghost | Phase 2: WPA2 Handshake & Hashcat Audit
# プロジェクト: 渋谷エアウェーブ・ゴースト | フェーズ2: ハンドシェイク捕捉 & Hashcat解析

MON_IFACE="wlp2s0mon"
TARGET_BSSID="${2:-AA:BB:CC:DD:EE:FF}"
TARGET_CH="${3:-6}"
MODE="${1:---dry-run}"

echo "=================================================================="
echo "🔓 [PHASE 2: HANDSHAKE CAPTURE & HASHCAT / ハンドシェイク捕捉・解析]"
echo "=================================================================="

if [ "$MODE" == "--live" ]; then
    echo "[*] Spawning targeted airodump-ng capture pop-up / ターゲット捕捉画面を起動..."
    mate-terminal --title="[PHASE 2A: WPA2 HANDSHAKE CAPTURE / ハンドシェイク監視]" \
        -e "bash -c 'sudo airodump-ng --bssid $TARGET_BSSID -c $TARGET_CH -w /tmp/shibuya_cap $MON_IFACE; exec bash'" &

    sleep 2
    echo "[*] Spawning Hashcat WPA-PBKDF2-PBKDF2 (Mode 22000) live audit pop-up / Hashcat解析画面を起動..."
    mate-terminal --title="[PHASE 2B: HASHCAT WPA2 AUDIT / パスワード強度解析]" \
        -e "bash -c 'echo \"[*] Initializing Hashcat Mode 22000 (WPA-PBKDF2)...\"; hashcat -b -m 22000; exec bash'" &
else
    echo "[*] DRY-RUN MODE / ドライランモード"
    echo "[>] Target BSSID / 対象MAC: $TARGET_BSSID | Channel / チャンネル: $TARGET_CH"
    echo "[>] Pop-Up 1: sudo airodump-ng --bssid $TARGET_BSSID -c $TARGET_CH -w /tmp/shibuya_cap $MON_IFACE"
    echo "[>] Pop-Up 2: hashcat -m 22000 shibuya_cap.hc22000 /usr/share/wordlists/rockyou.txt"
fi
