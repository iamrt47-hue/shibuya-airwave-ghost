#!/bin/bash
# Project: shibuya-airwave-ghost | Phase 1: Wireless Perimeter Recon
# プロジェクト: 渋谷エアウェーブ・ゴースト | フェーズ1: 無線LAN境界偵察

INTERFACE="wlp2s0"
MON_IFACE="${INTERFACE}mon"
MODE="${1:---dry-run}"

cleanup() {
    echo -e "\n[!] Restoring managed mode & NetworkManager / 管理モードとネットワークを復元中..."
    sudo airmon-ng stop "$MON_IFACE" >/dev/null 2>&1
    sudo ip link set "$INTERFACE" up >/dev/null 2>&1
    sudo systemctl restart NetworkManager >/dev/null 2>&1
    echo "[+] Wi-Fi connection restored on $INTERFACE / Wi-Fi接続が復元されました。"
}

echo "=================================================================="
echo "📡 [PHASE 1: SHIBUYA AIRWAVE RECON / 無線LAN境界スキャン]"
echo "=================================================================="

if [ "$MODE" == "--live" ]; then
    trap cleanup EXIT INT TERM
    echo "[*] Killing conflicting processes & enabling monitor mode on $INTERFACE..."
    echo "[*] 競合プロセスを停止し、$INTERFACE をモニターモードに切り替えます..."
    sudo airmon-ng check kill
    sudo airmon-ng start "$INTERFACE"

    echo "[+] Launching live airodump-ng pop-up window / リアルタイムスキャン画面を起動中..."
    mate-terminal --title="[PHASE 1: AIRODUMP-NG LIVE SCAN / 渋谷無線LAN監視]" \
        -e "bash -c 'sudo airodump-ng $MON_IFACE; exec bash'"

    read -p "[?] Press [ENTER] when finished scanning to restore Wi-Fi / スキャン完了後 Enter で Wi-Fi を復元: "
else
    echo "[*] DRY-RUN MODE (Safe / Managed Mode) / ドライランモード（通信維持）"
    echo "[>] Target Interface / 対象インターフェース: $INTERFACE"
    echo "[>] Command Queued / 実行予定コマンド: sudo airmon-ng start $INTERFACE && sudo airodump-ng $MON_IFACE"
    echo "[+] Run with '--live' during final demo to spawn live pop-up CLI window."
    echo "[+] 最終デモ時は '--live' を付けて実行するとリアルタイム画面がポップアップします。"
fi


