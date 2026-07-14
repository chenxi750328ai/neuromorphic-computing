#!/usr/bin/env bash
# Install Vivado ML / WebPACK (Zynq-7000) on Linux/WSL — 陈正共
# Requires AMD account:
#   export XILINX_EMAIL='you@example.com'
#   export XILINX_PASSWORD='...'
# Optional:
#   export VIVADO_VERSION=2023.2
#   export VIVADO_ROOT=/tools/Xilinx
set -euo pipefail

EMAIL="${XILINX_EMAIL:-${AMD_EMAIL:-}}"
PASS="${XILINX_PASSWORD:-${AMD_PASSWORD:-${XILINX_PASS:-}}}"
VER="${VIVADO_VERSION:-2023.2}"
ROOT_DIR="${VIVADO_ROOT:-/tools/Xilinx}"
WORK="${VIVADO_DOWNLOAD_DIR:-$HOME/Downloads/xilinx-install}"
# Known Linux web installer names (Update if AMD renames)
BIN_CANDIDATES=(
  "FPGAs_AdaptiveSoCs_Unified_${VER}_1013_2256_Lin64.bin"
  "Xilinx_Unified_${VER}_1013_2256_Lin64.bin"
  "FPGAs_AdaptiveSoCs_Unified_${VER}_Lin64.bin"
)

mkdir -p "$WORK" "$ROOT_DIR"
cd "$WORK"

if [[ -z "$EMAIL" || -z "$PASS" ]]; then
  cat <<EOF
ERR: 需要 AMD/Xilinx 账号才能拉安装包。
请执行：
  export XILINX_EMAIL='你的AMD邮箱'
  export XILINX_PASSWORD='密码'
  bash scripts/install_vivado_webpack.sh

或把已下载的 Unified *Lin64.bin 放到：
  $WORK/
然后重跑本脚本（有本地 .bin 可不填密码做静默安装）。
EOF
  exit 2
fi

BIN=""
for c in "${BIN_CANDIDATES[@]}"; do
  if [[ -f "$WORK/$c" ]]; then BIN="$WORK/$c"; break; fi
done

if [[ -z "$BIN" ]]; then
  echo "INFO: 本地无 installer，尝试从 AMD 拉取（需账号；web installer 仍可能要登录会话）"
  echo "请浏览器登录 https://www.xilinx.com/support/download.html 下载 Linux Self Extracting Web Installer"
  echo "存到 $WORK/ 后重跑。"
  # Non-interactive download usually 401/302 to login — fail fast with instruction
  exit 3
fi

chmod +x "$BIN"
echo "INFO: extracting / launching $BIN"
# Web installer extracts xsetup under /tmp or cwd
"$BIN" --noexec --target "$WORK/extracted_${VER}" || true
if [[ ! -x "$WORK/extracted_${VER}/xsetup" ]]; then
  # some bins are self-exec GUI only; run and hope batch later
  echo "WARN: --noexec 未得到 xsetup，尝试直接运行 installer（可能弹出 GUI）"
  "$BIN" &
  echo "请在 GUI 中选 Vivado / WebPACK 或 ML Standard，设备勾选 Zynq-7000，路径 $ROOT_DIR"
  wait || true
fi

XSETUP=$(find "$WORK" -maxdepth 3 -type f -name xsetup | head -1)
if [[ -z "$XSETUP" ]]; then
  echo "ERR: 找不到 xsetup"
  exit 4
fi

# Auth token (batch)
"$XSETUP" -a XilinxEULA,3rdPartyEULA,WebTalkTerms -b AuthTokenGen <<EOF || true
$EMAIL
$PASS
EOF

CFG="$HOME/.Xilinx/install_config.txt"
mkdir -p "$HOME/.Xilinx"
"$XSETUP" -b ConfigGen <<EOF || true
1
EOF

# Rewrite config for minimal Zynq-7000 Vivado
cat >"$CFG" <<EOF
Edition=Vivado ML Standard
Destination=$ROOT_DIR
Modules=Vivado:1,Vitis Embedded Development:0,DocNav:0,Vitis Networking:0,System Generator for DSP:0,Model Composer:0,Petalinux Tools:0
InstallOptions=EnableVitisPlatformInstaller:0,EnableSdkInstaller:0
Devices=Zynq-7000:1,Kintex-7:0,Artix-7:0,Spartan-7:0,Virtex-7:0,Kintex UltraScale:0,Virtex UltraScale:0,Zynq UltraScale+:0,Versal:0
EOF

echo "INFO: batch install with $CFG"
"$XSETUP" --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --batch Install --config "$CFG"

SETTINGS=$(find "$ROOT_DIR" -name 'settings64.sh' | head -1)
if [[ -z "$SETTINGS" ]]; then
  echo "ERR: install finished but settings64.sh missing"
  exit 5
fi
# shellcheck disable=SC1090
source "$SETTINGS"
vivado -version | head -3
echo "VIVADO_INSTALL_OK settings=$SETTINGS"
echo "source $SETTINGS" >>"$HOME/.bashrc.xilinx"
echo "Add to shell: source $SETTINGS"
