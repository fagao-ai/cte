# 安装指南

## 方式一：使用 Homebrew（推荐 macOS/Linux）

### 1. 添加 Tap

```bash
brew tap fagao-ai/tap
```

### 2. 安装

```bash
brew install cte
```

### 3. 更新

```bash
brew upgrade cte
```

### 4. 卸载

```bash
brew uninstall cte
```

## 方式二：使用 APT（推荐 Debian/Ubuntu）

### 1. 添加仓库

```bash
# 下载并添加仓库 GPG 密钥
wget -qO- https://fagao-ai.github.io/cte/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cte.gpg

# 添加仓库到 sources.list
echo "deb [arch=$(dpkg --print-architecture)] https://fagao-ai.github.io/cte/apt stable main" | sudo tee /etc/apt/sources.list.d/cte.list

# 更新包列表
sudo apt update
```

### 2. 安装

```bash
sudo apt install cte
```

### 3. 更新

```bash
sudo apt update && sudo apt upgrade cte
```

### 4. 卸载

```bash
sudo apt remove cte
```

## 方式三：从 GitHub Releases 下载

### macOS

```bash
# Intel Mac
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-darwin-amd64.tar.gz | tar xz
sudo mv cte /usr/local/bin/

# Apple Silicon (M1/M2)
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-darwin-arm64.tar.gz | tar xz
sudo mv cte /usr/local/bin/
```

### Linux

```bash
# AMD64
curl -L https://github.com/fagao-ai/cte/releases/latest/download/cte-linux-amd64.tar.gz | tar xz
sudo mv cte /usr/local/bin/
```

### Windows

**PowerShell:**
```powershell
# 使用安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

**手动下载:**
```powershell
# 下载并解压
Invoke-WebRequest -Uri "https://github.com/fagao-ai/cte/releases/latest/download/cte-windows-amd64.zip" -OutFile "cte.zip"
Expand-Archive -Path "cte.zip" -DestinationPath "."
# 将 cte.exe 添加到 PATH 或移动到系统路径
```

### 验证安装

```bash
cte --version
cte --help
```

## 方式四：使用 Cargo（从源码编译）

如果你已经安装了 Rust：

```bash
cargo install cte
```

或从源码构建：

```bash
git clone https://github.com/fagao-ai/cte.git
cd cte
cargo build --release
sudo cp target/release/cte /usr/local/bin/
```

## 方式五：使用安装脚本（Linux/macOS）

```bash
curl -fsSL https://raw.githubusercontent.com/fagao-ai/cte/main/scripts/install.sh | sudo sh
```

## 开发者指南

### 发布新版本

1. 更新 `Cargo.toml` 中的版本号
2. 创建并推送 tag：

```bash
git tag -a v0.x.x -m "Release v0.x.x"
git push origin v0.x.x
```

3. GitHub Actions 会自动：
   - 构建多平台二进制文件
   - 创建 GitHub Release
   - 更新 Homebrew Tap
   - 构建 Debian 包

### 手动构建 Debian 包

```bash
cargo install cargo-deb
cargo deb
```

生成的 .deb 文件在 `target/debian/` 目录。

## 系统要求

- **最低**: Linux glibc 2.17+ 或 macOS 10.12+
- **推荐**: Linux glibc 2.27+ 或 macOS 11+
- **架构**: amd64 (x86_64) 或 arm64 (aarch64)

## 故障排除

### Homebrew 安装失败

```bash
# 更新 Homebrew
brew update

# 清理缓存
brew cleanup

# 重新安装
brew reinstall cte
```

### APT 安装失败

```bash
# 检查网络连接
ping fagao-ai.github.io

# 手动更新密钥
wget -qO- https://fagao-ai.github.io/cte/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cte.gpg

# 重新更新
sudo apt update
```

### 权限问题

```bash
# 确保有执行权限
chmod +x /usr/local/bin/cte
```
